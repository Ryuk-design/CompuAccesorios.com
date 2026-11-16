-- COMPONENTES
-- Un esquema por caso de uso (CRUD) con las operaciones estandar:
--   ad = adicionar (registrar), up = modificar, de = eliminar, co = consultar (REFCURSOR)
-- Los ids los entrega quien llama, igual que en el poblar.
-- Las demas reglas (existencias, totales, estados, fechas, etc.) las aplican los disparadores y restricciones.


-- ============================================================
-- ADMINISTRADOR
-- ============================================================

-- MANTENER ESTADO PAGO
CREATE SCHEMA IF NOT EXISTS SV_ESTADOPAGO;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_ESTADOPAGO.ad(
    p_id INT, p_nombre_estado_pago TEstadoPago
) RETURNS void AS $$
BEGIN
    INSERT INTO estadosDePago (id, nombre_estado_pago)
    VALUES (p_id, p_nombre_estado_pago);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_ESTADOPAGO.up(
    p_id INT, p_nombre_estado_pago TEstadoPago
) RETURNS void AS $$
BEGIN
    UPDATE estadosDePago
    SET nombre_estado_pago = p_nombre_estado_pago
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El estado de pago % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_ESTADOPAGO.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM estadosDePago
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El estado de pago % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el estado de pago %: esta siendo usado', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_ESTADOPAGO.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, nombre_estado_pago
        FROM estadosDePago
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- MANTENER ESTADO SERVICIO
CREATE SCHEMA IF NOT EXISTS SV_ESTADOSERVICIO;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_ESTADOSERVICIO.ad(
    p_id INT, p_nombre_estado TEstado
) RETURNS void AS $$
BEGIN
    INSERT INTO estadosDeServicios (id, nombre_estado)
    VALUES (p_id, p_nombre_estado);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_ESTADOSERVICIO.up(
    p_id INT, p_nombre_estado TEstado
) RETURNS void AS $$
BEGIN
    UPDATE estadosDeServicios
    SET nombre_estado = p_nombre_estado
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El estado de servicio % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_ESTADOSERVICIO.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM estadosDeServicios
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El estado de servicio % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el estado de servicio %: esta siendo usado', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_ESTADOSERVICIO.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, nombre_estado
        FROM estadosDeServicios
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- MANTENER ESPECIALIZACION
CREATE SCHEMA IF NOT EXISTS SV_ESPECIALIZACION;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_ESPECIALIZACION.ad(
    p_id INT, p_especializacion TEspecializacion
) RETURNS void AS $$
BEGIN
    INSERT INTO especializaciones (id, especializacion)
    VALUES (p_id, p_especializacion);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_ESPECIALIZACION.up(
    p_id INT, p_especializacion TEspecializacion
) RETURNS void AS $$
BEGIN
    UPDATE especializaciones
    SET especializacion = p_especializacion
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La especializacion % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_ESPECIALIZACION.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM especializaciones
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La especializacion % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar la especializacion %: esta siendo usado', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_ESPECIALIZACION.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, especializacion
        FROM especializaciones
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- MANTENER CATALOGOS (catalogo de servicios)
CREATE SCHEMA IF NOT EXISTS SV_CATALOGO;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_CATALOGO.ad(
    p_id INT, p_descripcion_servicio VARCHAR(200), p_precio_base INT
) RETURNS void AS $$
BEGIN
    INSERT INTO catalogoDeServicios (id, descripcion_servicio, precio_base)
    VALUES (p_id, p_descripcion_servicio, p_precio_base);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_CATALOGO.up(
    p_id INT, p_descripcion_servicio VARCHAR(200), p_precio_base INT
) RETURNS void AS $$
BEGIN
    UPDATE catalogoDeServicios
    SET descripcion_servicio = p_descripcion_servicio, precio_base = p_precio_base
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio del catalogo % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_CATALOGO.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM catalogoDeServicios
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio del catalogo % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el servicio del catalogo %: esta siendo usado', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_CATALOGO.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, descripcion_servicio, precio_base
        FROM catalogoDeServicios
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- MANTENER CATEGORIA
CREATE SCHEMA IF NOT EXISTS SV_CATEGORIA;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_CATEGORIA.ad(
    p_id INT, p_nombre_categoria VARCHAR(100), p_descripcion_categoria VARCHAR(200)
) RETURNS void AS $$
BEGIN
    INSERT INTO categorias (id, nombre_categoria, descripcion_categoria)
    VALUES (p_id, p_nombre_categoria, p_descripcion_categoria);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_CATEGORIA.up(
    p_id INT, p_nombre_categoria VARCHAR(100), p_descripcion_categoria VARCHAR(200)
) RETURNS void AS $$
BEGIN
    UPDATE categorias
    SET nombre_categoria = p_nombre_categoria, descripcion_categoria = p_descripcion_categoria
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La categoria % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_CATEGORIA.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM categorias
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La categoria % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar la categoria %: esta siendo usado', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_CATEGORIA.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, nombre_categoria, descripcion_categoria
        FROM categorias
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- MANTENER INVENTARIO
CREATE SCHEMA IF NOT EXISTS SV_INVENTARIO;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_INVENTARIO.ad(
    p_id INT, p_descripcion_inventario VARCHAR(200)
) RETURNS void AS $$
BEGIN
    INSERT INTO inventarios (id, descripcion_inventario)
    VALUES (p_id, p_descripcion_inventario);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_INVENTARIO.up(
    p_id INT, p_descripcion_inventario VARCHAR(200)
) RETURNS void AS $$
BEGIN
    UPDATE inventarios
    SET descripcion_inventario = p_descripcion_inventario
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El inventario % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_INVENTARIO.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM inventarios
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El inventario % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el inventario %: esta siendo usado', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_INVENTARIO.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, descripcion_inventario
        FROM inventarios
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- MANTENER PRODUCTO
CREATE SCHEMA IF NOT EXISTS SV_PRODUCTO;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_PRODUCTO.ad(
    p_id INT, p_nombre_producto VARCHAR(100), p_precio_unitario_producto INT, p_cantidad_producto INT, p_id_categoria INT, p_id_proveedor INT, p_id_inventario INT
) RETURNS void AS $$
BEGIN
    INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario)
    VALUES (p_id, p_nombre_producto, p_precio_unitario_producto, p_cantidad_producto, p_id_categoria, p_id_proveedor, p_id_inventario);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_PRODUCTO.up(
    p_id INT, p_nombre_producto VARCHAR(100), p_precio_unitario_producto INT, p_cantidad_producto INT, p_id_categoria INT, p_id_proveedor INT, p_id_inventario INT
) RETURNS void AS $$
BEGIN
    UPDATE productos
    SET nombre_producto = p_nombre_producto, precio_unitario_producto = p_precio_unitario_producto, cantidad_producto = p_cantidad_producto, id_categoria = p_id_categoria, id_proveedor = p_id_proveedor, id_inventario = p_id_inventario
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_PRODUCTO.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM productos
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el producto %: esta siendo usado', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_PRODUCTO.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario
        FROM productos
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;



-- MANTENER PROVEEDOR
CREATE SCHEMA IF NOT EXISTS SV_PROVEEDOR;


-- Adicionar (el proveedor queda activo por defecto)
CREATE OR REPLACE FUNCTION SV_PROVEEDOR.ad(
    p_id INT,
    p_telefono_proveedor TTelefono,
    p_email_proveedor TEmail,
    p_nombre_proveedor VARCHAR
) RETURNS void AS $$
BEGIN
    INSERT INTO proveedores (id, telefono_proveedor, email_proveedor, nombre_proveedor)
    VALUES (p_id, p_telefono_proveedor, p_email_proveedor, p_nombre_proveedor);
END;
$$ LANGUAGE plpgsql;


-- Modificar (tambien sirve para activar o desactivar al proveedor)
CREATE OR REPLACE FUNCTION SV_PROVEEDOR.up(
    p_id INT,
    p_telefono_proveedor TTelefono,
    p_email_proveedor TEmail,
    p_nombre_proveedor VARCHAR,
    p_actualmente_provee BOOLEAN
) RETURNS void AS $$
BEGIN
    UPDATE proveedores
    SET telefono_proveedor = p_telefono_proveedor,
        email_proveedor = p_email_proveedor,
        nombre_proveedor = p_nombre_proveedor,
        actualmente_provee = p_actualmente_provee
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El proveedor % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar
CREATE OR REPLACE FUNCTION SV_PROVEEDOR.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM proveedores
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El proveedor % no existe', p_id;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el proveedor %: tiene productos asociados', p_id
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_PROVEEDOR.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT id, telefono_proveedor, email_proveedor, nombre_proveedor, actualmente_provee
        FROM proveedores
        WHERE id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- MANTENER EMPLEADO
-- Un empleado es una persona con un rol: tecnico o vendedor (los disparadores impiden tener los dos).
-- Si la persona ya existe (por ejemplo, ya es cliente) se reutiliza su registro.
CREATE SCHEMA IF NOT EXISTS SV_EMPLEADO;


-- Adicionar tecnico
CREATE OR REPLACE FUNCTION SV_EMPLEADO.ad_tecnico(
    p_cedula VARCHAR,
    p_email TEmail,
    p_telefono TTelefono,
    p_nombre TNombre,
    p_salario_empleado INT,
    p_comision_servicio INT,
    p_id_especializacion INT
) RETURNS void AS $$
BEGIN
    INSERT INTO personas (cedula, email, telefono, nombre)
    VALUES (p_cedula, p_email, p_telefono, p_nombre)
    ON CONFLICT (cedula) DO NOTHING;

    IF EXISTS (SELECT 1 FROM empleados WHERE cedula_empleado = p_cedula) THEN
        RAISE EXCEPTION 'El empleado % ya esta registrado', p_cedula;
    END IF;

    INSERT INTO empleados (cedula_empleado, salario_empleado)
    VALUES (p_cedula, p_salario_empleado);

    INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion)
    VALUES (p_cedula, p_comision_servicio, p_id_especializacion);
END;
$$ LANGUAGE plpgsql;


-- Adicionar vendedor
CREATE OR REPLACE FUNCTION SV_EMPLEADO.ad_vendedor(
    p_cedula VARCHAR,
    p_email TEmail,
    p_telefono TTelefono,
    p_nombre TNombre,
    p_salario_empleado INT,
    p_comision_venta INT
) RETURNS void AS $$
BEGIN
    INSERT INTO personas (cedula, email, telefono, nombre)
    VALUES (p_cedula, p_email, p_telefono, p_nombre)
    ON CONFLICT (cedula) DO NOTHING;

    IF EXISTS (SELECT 1 FROM empleados WHERE cedula_empleado = p_cedula) THEN
        RAISE EXCEPTION 'El empleado % ya esta registrado', p_cedula;
    END IF;

    INSERT INTO empleados (cedula_empleado, salario_empleado)
    VALUES (p_cedula, p_salario_empleado);

    INSERT INTO vendedores (cedula_vendedor, comision_venta)
    VALUES (p_cedula, p_comision_venta);
END;
$$ LANGUAGE plpgsql;


-- Modificar datos del empleado (tambien sirve para marcarlo como retirado)
CREATE OR REPLACE FUNCTION SV_EMPLEADO.up(
    p_cedula VARCHAR,
    p_email TEmail,
    p_telefono TTelefono,
    p_nombre TNombre,
    p_salario_empleado INT,
    p_actualmente_trabaja BOOLEAN
) RETURNS void AS $$
BEGIN
    UPDATE empleados
    SET salario_empleado = p_salario_empleado,
        actualmente_trabaja = p_actualmente_trabaja
    WHERE cedula_empleado = p_cedula;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El empleado % no existe', p_cedula;
    END IF;

    UPDATE personas
    SET email = p_email,
        telefono = p_telefono,
        nombre = p_nombre
    WHERE cedula = p_cedula;
END;
$$ LANGUAGE plpgsql;


-- Modificar datos del tecnico
CREATE OR REPLACE FUNCTION SV_EMPLEADO.up_tecnico(
    p_cedula VARCHAR,
    p_comision_servicio INT,
    p_id_especializacion INT
) RETURNS void AS $$
BEGIN
    UPDATE tecnicos
    SET comision_servicio = p_comision_servicio,
        id_especializacion = p_id_especializacion
    WHERE cedula_tecnico = p_cedula;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El tecnico % no existe', p_cedula;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Modificar datos del vendedor
CREATE OR REPLACE FUNCTION SV_EMPLEADO.up_vendedor(
    p_cedula VARCHAR,
    p_comision_venta INT
) RETURNS void AS $$
BEGIN
    UPDATE vendedores
    SET comision_venta = p_comision_venta
    WHERE cedula_vendedor = p_cedula;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El vendedor % no existe', p_cedula;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar (borra tambien su registro de tecnico o vendedor; la persona se conserva si es cliente)
CREATE OR REPLACE FUNCTION SV_EMPLEADO.de(
    p_cedula VARCHAR
) RETURNS void AS $$
BEGIN
    DELETE FROM empleados
    WHERE cedula_empleado = p_cedula;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El empleado % no existe', p_cedula;
    END IF;

    DELETE FROM personas
    WHERE cedula = p_cedula
      AND NOT EXISTS (SELECT 1 FROM clientes WHERE cedula_cliente = p_cedula);
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el empleado %: tiene servicios tecnicos o ventas registrados', p_cedula
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_EMPLEADO.co(
    p_cursor REFCURSOR,
    p_cedula VARCHAR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT p.cedula, p.nombre, p.email, p.telefono,
               e.salario_empleado, e.actualmente_trabaja,
               CASE WHEN t.cedula_tecnico IS NOT NULL THEN 'Tecnico'
                    WHEN v.cedula_vendedor IS NOT NULL THEN 'Vendedor' END AS rol,
               t.comision_servicio, es.especializacion, v.comision_venta
        FROM empleados e
        JOIN personas p ON p.cedula = e.cedula_empleado
        LEFT JOIN tecnicos t ON t.cedula_tecnico = e.cedula_empleado
        LEFT JOIN especializaciones es ON es.id = t.id_especializacion
        LEFT JOIN vendedores v ON v.cedula_vendedor = e.cedula_empleado
        WHERE e.cedula_empleado = p_cedula;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- VENDEDOR Y TECNICO
-- ============================================================

-- MANTENER CLIENTE
-- Si la persona ya existe (por ejemplo, ya es empleado) se reutiliza su registro.
CREATE SCHEMA IF NOT EXISTS SV_CLIENTE;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_CLIENTE.ad(
    p_cedula VARCHAR,
    p_email TEmail,
    p_telefono TTelefono,
    p_nombre TNombre
) RETURNS void AS $$
BEGIN
    INSERT INTO personas (cedula, email, telefono, nombre)
    VALUES (p_cedula, p_email, p_telefono, p_nombre)
    ON CONFLICT (cedula) DO NOTHING;

    IF EXISTS (SELECT 1 FROM clientes WHERE cedula_cliente = p_cedula) THEN
        RAISE EXCEPTION 'El cliente % ya esta registrado', p_cedula;
    END IF;

    INSERT INTO clientes (cedula_cliente)
    VALUES (p_cedula);
END;
$$ LANGUAGE plpgsql;


-- Modificar
CREATE OR REPLACE FUNCTION SV_CLIENTE.up(
    p_cedula VARCHAR,
    p_email TEmail,
    p_telefono TTelefono,
    p_nombre TNombre
) RETURNS void AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM clientes WHERE cedula_cliente = p_cedula) THEN
        RAISE EXCEPTION 'El cliente % no existe', p_cedula;
    END IF;

    UPDATE personas
    SET email = p_email,
        telefono = p_telefono,
        nombre = p_nombre
    WHERE cedula = p_cedula;
END;
$$ LANGUAGE plpgsql;


-- Eliminar (la persona se conserva si es empleado)
CREATE OR REPLACE FUNCTION SV_CLIENTE.de(
    p_cedula VARCHAR
) RETURNS void AS $$
BEGIN
    DELETE FROM clientes
    WHERE cedula_cliente = p_cedula;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El cliente % no existe', p_cedula;
    END IF;

    DELETE FROM personas
    WHERE cedula = p_cedula
      AND NOT EXISTS (SELECT 1 FROM empleados WHERE cedula_empleado = p_cedula);
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el cliente %: tiene ventas o servicios tecnicos registrados', p_cedula
            USING ERRCODE = 'foreign_key_violation';
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_CLIENTE.co(
    p_cursor REFCURSOR,
    p_cedula VARCHAR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT p.cedula, p.nombre, p.email, p.telefono
        FROM clientes c
        JOIN personas p ON p.cedula = c.cedula_cliente
        WHERE c.cedula_cliente = p_cedula;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- VENDEDOR
-- ============================================================

-- REGISTRAR VENTA
-- La venta se abre en cero; el total, las existencias y la validacion de stock
-- las calculan los disparadores al agregar, modificar o quitar detalles.
CREATE SCHEMA IF NOT EXISTS SV_VENTA;


-- Adicionar venta (la fecha es la actual)
CREATE OR REPLACE FUNCTION SV_VENTA.ad(
    p_id INT,
    p_cedula_cliente VARCHAR,
    p_cedula_vendedor VARCHAR
) RETURNS void AS $$
BEGIN
    INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
    VALUES (p_id, 0, p_cedula_cliente, p_cedula_vendedor);
END;
$$ LANGUAGE plpgsql;


-- Adicionar producto a la venta (el precio es el actual del producto)
CREATE OR REPLACE FUNCTION SV_VENTA.ad_detalle(
    p_id_venta INT,
    p_id_producto INT,
    p_cantidad INT
) RETURNS void AS $$
DECLARE
    v_precio INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ventas WHERE id = p_id_venta) THEN
        RAISE EXCEPTION 'La venta % no existe', p_id_venta;
    END IF;

    SELECT precio_unitario_producto INTO v_precio
    FROM productos
    WHERE id = p_id_producto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto % no existe', p_id_producto;
    END IF;

    INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
    VALUES (p_id_venta, p_id_producto, p_cantidad, v_precio);
END;
$$ LANGUAGE plpgsql;


-- Modificar la cantidad de un producto de la venta
CREATE OR REPLACE FUNCTION SV_VENTA.up_detalle(
    p_id_venta INT,
    p_id_producto INT,
    p_cantidad INT
) RETURNS void AS $$
BEGIN
    UPDATE detallesDeVenta
    SET cantidad = p_cantidad
    WHERE id_venta = p_id_venta
      AND id_producto = p_id_producto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La venta % no tiene el producto %', p_id_venta, p_id_producto;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Quitar un producto de la venta
CREATE OR REPLACE FUNCTION SV_VENTA.de_detalle(
    p_id_venta INT,
    p_id_producto INT
) RETURNS void AS $$
BEGIN
    DELETE FROM detallesDeVenta
    WHERE id_venta = p_id_venta
      AND id_producto = p_id_producto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La venta % no tiene el producto %', p_id_venta, p_id_producto;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Anular venta (borra tambien su detalle y devuelve las existencias)
CREATE OR REPLACE FUNCTION SV_VENTA.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM ventas
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La venta % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Consultar venta (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_VENTA.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT v.id, v.fecha_venta, v.total_venta,
               v.cedula_cliente, pc.nombre AS nombre_cliente,
               v.cedula_vendedor, pv.nombre AS nombre_vendedor
        FROM ventas v
        JOIN personas pc ON pc.cedula = v.cedula_cliente
        JOIN personas pv ON pv.cedula = v.cedula_vendedor
        WHERE v.id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar los productos de una venta (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_VENTA.co_detalle(
    p_cursor REFCURSOR,
    p_id_venta INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT d.id_producto, p.nombre_producto, d.cantidad, d.precio_unitario,
               d.cantidad * d.precio_unitario AS subtotal
        FROM detallesDeVenta d
        JOIN productos p ON p.id = d.id_producto
        WHERE d.id_venta = p_id_venta
        ORDER BY d.id_producto;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- TECNICO
-- ============================================================

-- MANTENER SERVICIO TECNICO
-- Al crearlo: fecha de inicio = ahora, estado = En proceso y pago = No pagado (valores por defecto de la tabla).
CREATE SCHEMA IF NOT EXISTS SV_SERVICIOTECNICO;


-- Adicionar
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.ad(
    p_id INT,
    p_id_tecnico VARCHAR,
    p_cedula_cliente VARCHAR,
    p_id_catalogo_servicio INT,
    p_fecha_estimada_entrega TIMESTAMP
) RETURNS void AS $$
BEGIN
    INSERT INTO serviciosTecnicos (id, id_tecnico, cedula_cliente, id_catalogo_servicio, fecha_estimada_entrega)
    VALUES (p_id, p_id_tecnico, p_cedula_cliente, p_id_catalogo_servicio, p_fecha_estimada_entrega);
END;
$$ LANGUAGE plpgsql;


-- Modificar datos del servicio
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.up(
    p_id INT,
    p_id_tecnico VARCHAR,
    p_cedula_cliente VARCHAR,
    p_id_catalogo_servicio INT,
    p_fecha_estimada_entrega TIMESTAMP
) RETURNS void AS $$
BEGIN
    UPDATE serviciosTecnicos
    SET id_tecnico = p_id_tecnico,
        cedula_cliente = p_cedula_cliente,
        id_catalogo_servicio = p_id_catalogo_servicio,
        fecha_estimada_entrega = p_fecha_estimada_entrega
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio tecnico % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Modificar el estado del servicio (para Entregado se debe enviar la fecha de entrega)
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.up_estado(
    p_id INT,
    p_id_estado_servicio INT,
    p_fecha_entrega TIMESTAMP DEFAULT NULL
) RETURNS void AS $$
BEGIN
    UPDATE serviciosTecnicos
    SET id_estado_servicio = p_id_estado_servicio,
        fecha_entrega = COALESCE(p_fecha_entrega, fecha_entrega)
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio tecnico % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Modificar el estado de pago del servicio
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.up_pago(
    p_id INT,
    p_id_estado_pago INT
) RETURNS void AS $$
BEGIN
    UPDATE serviciosTecnicos
    SET id_estado_pago = p_id_estado_pago
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio tecnico % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Eliminar (no se permite si esta Entregado)
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.de(
    p_id INT
) RETURNS void AS $$
BEGIN
    DELETE FROM serviciosTecnicos
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El servicio tecnico % no existe', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Consultar (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.co(
    p_cursor REFCURSOR,
    p_id INT
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT s.id, s.id_tecnico, pt.nombre AS nombre_tecnico,
               s.cedula_cliente, pc.nombre AS nombre_cliente,
               cs.descripcion_servicio, cs.precio_base,
               es.nombre_estado, ep.nombre_estado_pago,
               s.fecha_inicio_servicio, s.fecha_estimada_entrega, s.fecha_entrega
        FROM serviciosTecnicos s
        JOIN personas pt ON pt.cedula = s.id_tecnico
        JOIN personas pc ON pc.cedula = s.cedula_cliente
        JOIN catalogoDeServicios cs ON cs.id = s.id_catalogo_servicio
        JOIN estadosDeServicios es ON es.id = s.id_estado_servicio
        JOIN estadosDePago ep ON ep.id = s.id_estado_pago
        WHERE s.id = p_id;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar los servicios de un tecnico (retorna REFCURSOR)
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.co_tecnico(
    p_cursor REFCURSOR,
    p_cedula_tecnico VARCHAR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT s.id, s.cedula_cliente, pc.nombre AS nombre_cliente,
               cs.descripcion_servicio, es.nombre_estado, ep.nombre_estado_pago,
               s.fecha_inicio_servicio, s.fecha_estimada_entrega, s.fecha_entrega
        FROM serviciosTecnicos s
        JOIN personas pc ON pc.cedula = s.cedula_cliente
        JOIN catalogoDeServicios cs ON cs.id = s.id_catalogo_servicio
        JOIN estadosDeServicios es ON es.id = s.id_estado_servicio
        JOIN estadosDePago ep ON ep.id = s.id_estado_pago
        WHERE s.id_tecnico = p_cedula_tecnico
        ORDER BY s.fecha_inicio_servicio DESC;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- CONSULTAS OPERATIVAS
-- Cada consulta vive en el esquema de su dominio y lee la vista correspondiente (19_Vistas.sql).
-- ============================================================

-- Consultar ventas del ultimo mes
CREATE OR REPLACE FUNCTION SV_VENTA.co_ultimo_mes(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_ventas_ultimo_mes
        ORDER BY fecha_venta DESC;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar ventas procesadas por vendedor (ultimo mes)
CREATE OR REPLACE FUNCTION SV_VENTA.co_por_vendedor(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_ventas_por_vendedor
        ORDER BY total_vendido DESC;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar historial de ventas realizadas por un vendedor
CREATE OR REPLACE FUNCTION SV_VENTA.co_historial_vendedor(
    p_cursor REFCURSOR,
    p_cedula_vendedor VARCHAR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_historial_ventas_vendedor
        WHERE cedula_vendedor = p_cedula_vendedor
        ORDER BY fecha_venta DESC;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar catalogo de productos disponibles y precios
CREATE OR REPLACE FUNCTION SV_PRODUCTO.co_catalogo_disponibles(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_catalogo_productos_disponibles
        ORDER BY id_producto;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar cuanto stock tiene cada producto
CREATE OR REPLACE FUNCTION SV_PRODUCTO.co_stock(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_stock_productos
        ORDER BY id_producto;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar productos con bajo inventario
CREATE OR REPLACE FUNCTION SV_PRODUCTO.co_bajo_inventario(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_productos_bajo_inventario;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar el producto mas vendido
CREATE OR REPLACE FUNCTION SV_PRODUCTO.co_mas_vendido(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_producto_mas_vendido;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar la categoria con los productos mas vendidos
CREATE OR REPLACE FUNCTION SV_CATEGORIA.co_mas_vendida(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_categoria_mas_vendida;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar servicios tecnicos asignados a cada tecnico y sus clientes
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.co_por_tecnico_y_cliente(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_servicios_por_tecnico
        ORDER BY id_servicio;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar historial de clientes atendidos por un tecnico
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.co_clientes_atendidos(
    p_cursor REFCURSOR,
    p_cedula_tecnico VARCHAR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_clientes_atendidos_por_tecnico
        WHERE cedula_tecnico = p_cedula_tecnico
        ORDER BY ultimo_servicio DESC;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar el servicio tecnico mas comun
CREATE OR REPLACE FUNCTION SV_SERVICIOTECNICO.co_mas_comun(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_servicio_tecnico_mas_comun;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- Consultar el proveedor mas frecuente
CREATE OR REPLACE FUNCTION SV_PROVEEDOR.co_mas_frecuente(
    p_cursor REFCURSOR
) RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM vw_proveedor_mas_frecuente;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;


-- XCOMPONENTES
/*
DROP SCHEMA IF EXISTS SV_ESTADOPAGO CASCADE;
DROP SCHEMA IF EXISTS SV_ESTADOSERVICIO CASCADE;
DROP SCHEMA IF EXISTS SV_ESPECIALIZACION CASCADE;
DROP SCHEMA IF EXISTS SV_CATALOGO CASCADE;
DROP SCHEMA IF EXISTS SV_CATEGORIA CASCADE;
DROP SCHEMA IF EXISTS SV_INVENTARIO CASCADE;
DROP SCHEMA IF EXISTS SV_PRODUCTO CASCADE;
DROP SCHEMA IF EXISTS SV_PROVEEDOR CASCADE;
DROP SCHEMA IF EXISTS SV_EMPLEADO CASCADE;
DROP SCHEMA IF EXISTS SV_CLIENTE CASCADE;
DROP SCHEMA IF EXISTS SV_VENTA CASCADE;
DROP SCHEMA IF EXISTS SV_SERVICIOTECNICO CASCADE;
*/