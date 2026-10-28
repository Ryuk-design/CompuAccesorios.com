-- Personas: la cedula no se puede modificar
CREATE OR REPLACE FUNCTION fn_cedula_no_modificable()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.cedula <> OLD.cedula THEN
        RAISE EXCEPTION 'La cedula de una persona no se puede modificar';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_cedula_no_modificable
BEFORE UPDATE ON Personas
FOR EACH ROW
EXECUTE FUNCTION fn_cedula_no_modificable();


-- Empleados: no puede ser tecnico y vendedor al mismo tiempo
CREATE OR REPLACE FUNCTION fn_tecnico_no_es_vendedor()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Vendedores WHERE cedula_vendedor = NEW.cedula_tecnico) THEN
        RAISE EXCEPTION 'El empleado % ya es vendedor, no puede ser tecnico', NEW.cedula_tecnico;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_tecnico_no_es_vendedor
BEFORE INSERT OR UPDATE ON Tecnicos
FOR EACH ROW
EXECUTE FUNCTION fn_tecnico_no_es_vendedor();


CREATE OR REPLACE FUNCTION fn_vendedor_no_es_tecnico()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Tecnicos WHERE cedula_tecnico = NEW.cedula_vendedor) THEN
        RAISE EXCEPTION 'El empleado % ya es tecnico, no puede ser vendedor', NEW.cedula_vendedor;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_vendedor_no_es_tecnico
BEFORE INSERT OR UPDATE ON Vendedores
FOR EACH ROW
EXECUTE FUNCTION fn_vendedor_no_es_tecnico();


-- Servicios tecnicos: Entregado exige fecha de entrega
CREATE OR REPLACE FUNCTION fn_servicio_entregado_con_fecha()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_entrega IS NULL AND EXISTS (
        SELECT 1 FROM EstadosdeServicios
        WHERE id = NEW.id_estado_servicio AND nombre_estado = 'Entregado'
    ) THEN
        RAISE EXCEPTION 'Un servicio en estado Entregado debe tener fecha de entrega';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_servicio_entregado_con_fecha
BEFORE INSERT OR UPDATE ON ServiciosTecnicos
FOR EACH ROW
EXECUTE FUNCTION fn_servicio_entregado_con_fecha();


-- Servicios tecnicos: no se elimina uno en estado Entregado
CREATE OR REPLACE FUNCTION fn_servicio_entregado_no_eliminable()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM EstadosdeServicios
        WHERE id = OLD.id_estado_servicio AND nombre_estado = 'Entregado'
    ) THEN
        RAISE EXCEPTION 'No se puede eliminar un servicio en estado Entregado';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_servicio_entregado_no_eliminable
BEFORE DELETE ON ServiciosTecnicos
FOR EACH ROW
EXECUTE FUNCTION fn_servicio_entregado_no_eliminable();


-- Detalles de venta: no se vende mas de lo disponible
CREATE OR REPLACE FUNCTION fn_detalle_validar_existencias()
RETURNS TRIGGER AS $$
DECLARE
    v_disponible INT;
BEGIN
    SELECT cantidad_producto INTO v_disponible
    FROM Productos
    WHERE id = NEW.id_producto;

    -- Si el producto no existe, se avisa con un mensaje claro
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto % no existe', NEW.id_producto;
    END IF;

    -- Si se modifica la cantidad del mismo producto, lo ya descontado vuelve a estar disponible
    IF TG_OP = 'UPDATE' AND OLD.id_producto = NEW.id_producto THEN
        v_disponible := v_disponible + OLD.cantidad;
    END IF;

    IF NEW.cantidad > v_disponible THEN
        RAISE EXCEPTION 'Existencias insuficientes del producto %: disponibles %, solicitadas %',
            NEW.id_producto, v_disponible, NEW.cantidad;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_detalle_validar_existencias
BEFORE INSERT OR UPDATE ON DetallesdeVenta
FOR EACH ROW
EXECUTE FUNCTION fn_detalle_validar_existencias();


-- Detalles de venta: descuenta / devuelve existencias
CREATE OR REPLACE FUNCTION fn_detalle_ajustar_existencias()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE Productos
        SET cantidad_producto = cantidad_producto - NEW.cantidad
        WHERE id = NEW.id_producto;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE Productos
        SET cantidad_producto = cantidad_producto + OLD.cantidad
        WHERE id = OLD.id_producto;

        UPDATE Productos
        SET cantidad_producto = cantidad_producto - NEW.cantidad
        WHERE id = NEW.id_producto;

    ELSE -- DELETE
        UPDATE Productos
        SET cantidad_producto = cantidad_producto + OLD.cantidad
        WHERE id = OLD.id_producto;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_detalle_ajustar_existencias
AFTER INSERT OR UPDATE OR DELETE ON DetallesdeVenta
FOR EACH ROW
EXECUTE FUNCTION fn_detalle_ajustar_existencias();


-- Detalles de venta: recalcula el total de la venta
-- Si el detalle cambia de venta, se recalculan la venta anterior y la nueva
CREATE OR REPLACE FUNCTION fn_detalle_recalcular_total()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP IN ('UPDATE', 'DELETE') THEN
        UPDATE Ventas
        SET total_venta = COALESCE((
                SELECT SUM(COALESCE(cantidad, 0) * COALESCE(precio_unitario, 0))
                FROM DetallesdeVenta
                WHERE id_venta = OLD.id_venta
            ), 0)
        WHERE id = OLD.id_venta;
    END IF;

    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        UPDATE Ventas
        SET total_venta = COALESCE((
                SELECT SUM(COALESCE(cantidad, 0) * COALESCE(precio_unitario, 0))
                FROM DetallesdeVenta
                WHERE id_venta = NEW.id_venta
            ), 0)
        WHERE id = NEW.id_venta;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_detalle_recalcular_total
AFTER INSERT OR UPDATE OR DELETE ON DetallesdeVenta
FOR EACH ROW
EXECUTE FUNCTION fn_detalle_recalcular_total();