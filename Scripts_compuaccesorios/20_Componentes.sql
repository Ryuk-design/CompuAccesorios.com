-- PERSONAS
CREATE OR REPLACE PROCEDURE registrarPersona(
    p_cedula VARCHAR(10),
    p_email TEmail,
    p_telefono TTelefono,
    p_nombre TNombre
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Personas(cedula, email, telefono, nombre)
    VALUES (p_cedula, p_email, p_telefono, p_nombre);
END;
$$;


-- CLIENTES
CREATE OR REPLACE PROCEDURE registrarCliente(
    p_cedula_cliente VARCHAR(10)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Clientes(cedula_cliente)
    VALUES (p_cedula_cliente);
END;
$$;


-- EMPLEADOS
CREATE OR REPLACE PROCEDURE registrarEmpleado(
    p_cedula_empleado VARCHAR(10),
    p_salario_empleado INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Empleados(cedula_empleado, salario_empleado)
    VALUES (p_cedula_empleado, p_salario_empleado);
END;
$$;


-- TECNICOS
CREATE OR REPLACE PROCEDURE registrarTecnico(
    p_cedula_tecnico VARCHAR(10),
    p_comision_servicio INT,
    p_id_especializacion INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Tecnicos(cedula_tecnico, comision_servicio, id_especializacion)
    VALUES (p_cedula_tecnico, p_comision_servicio, p_id_especializacion);
END;
$$;


-- VENDEDORES
CREATE OR REPLACE PROCEDURE registrarVendedor(
    p_cedula_vendedor VARCHAR(10),
    p_comision_venta INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Vendedores(cedula_vendedor, comision_venta)
    VALUES (p_cedula_vendedor, p_comision_venta);
END;
$$;


-- ESPECIALIZACIONES
CREATE OR REPLACE PROCEDURE registrarEspecializacion(
    p_id INT,
    p_especializacion TEspecializacion
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Especializaciones(id, especializacion)
    VALUES (p_id, p_especializacion);
END;
$$;


-- CATEGORIAS
CREATE OR REPLACE PROCEDURE registrarCategoria(
    p_id INT,
    p_nombre_categoria VARCHAR(100),
    p_descripcion_categoria VARCHAR(200)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Categorias(id, nombre_categoria, descripcion_categoria)
    VALUES (p_id, p_nombre_categoria, p_descripcion_categoria);
END;
$$;


-- INVENTARIOS
CREATE OR REPLACE PROCEDURE registrarInventario(
    p_id INT,
    p_descripcion_inventario VARCHAR(200)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Inventarios(id, descripcion_inventario)
    VALUES (p_id, p_descripcion_inventario);
END;
$$;


-- PROVEEDORES
CREATE OR REPLACE PROCEDURE registrarProveedor(
    p_id INT,
    p_telefono_proveedor TTelefono,
    p_email_proveedor TEmail,
    p_nombre_proveedor VARCHAR(100)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Proveedores(
        id, telefono_proveedor, email_proveedor, nombre_proveedor
    )
    VALUES (
        p_id, p_telefono_proveedor, p_email_proveedor, p_nombre_proveedor
    );
END;
$$;


-- PRODUCTOS
CREATE OR REPLACE PROCEDURE registrarProducto(
    p_id INT,
    p_nombre_producto VARCHAR(100),
    p_precio_unitario_producto INT,
    p_cantidad_producto INT,
    p_id_categoria INT,
    p_id_proveedor INT,
    p_id_inventario INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Productos(
        id, nombre_producto, precio_unitario_producto, cantidad_producto,
        id_categoria, id_proveedor, id_inventario
    )
    VALUES (
        p_id, p_nombre_producto, p_precio_unitario_producto,
        p_cantidad_producto, p_id_categoria, p_id_proveedor, p_id_inventario
    );
END;
$$;


-- CATALOGO DE SERVICIOS
CREATE OR REPLACE PROCEDURE registrarCatalogoServicio(
    p_id INT,
    p_descripcion_servicio VARCHAR(200),
    p_precio_base INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO CatalogodeServicios(id, descripcion_servicio, precio_base)
    VALUES (p_id, p_descripcion_servicio, p_precio_base);
END;
$$;


-- ESTADOS DE SERVICIOS
CREATE OR REPLACE PROCEDURE registrarEstadoServicio(
    p_id INT,
    p_nombre_estado TEstado
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO EstadosdeServicios(id, nombre_estado)
    VALUES (p_id, p_nombre_estado);
END;
$$;


-- ESTADOS DE PAGO
CREATE OR REPLACE PROCEDURE registrarEstadoPago(
    p_id INT,
    p_nombre_estado_pago TEstadoPago
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO EstadosdePago(id, nombre_estado_pago)
    VALUES (p_id, p_nombre_estado_pago);
END;
$$;


-- ACTUALIZAR PRODUCTO
CREATE OR REPLACE PROCEDURE actualizarProducto(
    p_id INT,
    p_nombre_producto VARCHAR(100),
    p_precio_unitario_producto INT,
    p_cantidad_producto INT
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Productos
    SET nombre_producto = p_nombre_producto,
        precio_unitario_producto = p_precio_unitario_producto,
        cantidad_producto = p_cantidad_producto
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto no existe';
    END IF;
END;
$$;


-- ACTUALIZAR PROVEEDOR
CREATE OR REPLACE PROCEDURE actualizarProveedor(
    p_id INT,
    p_telefono_proveedor TTelefono,
    p_email_proveedor TEmail,
    p_nombre_proveedor VARCHAR(100),
    p_actualmente_provee BOOLEAN
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Proveedores
    SET telefono_proveedor = p_telefono_proveedor,
        email_proveedor = p_email_proveedor,
        nombre_proveedor = p_nombre_proveedor,
        actualmente_provee = p_actualmente_provee
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El proveedor no existe';
    END IF;
END;
$$;


