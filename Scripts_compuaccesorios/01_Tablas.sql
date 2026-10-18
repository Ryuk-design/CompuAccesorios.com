CREATE TABLE personas(
    cedula VARCHAR(10) NOT NULL,
    email TEmail NOT NULL,
    telefono TTelefono NOT NULL,
    nombre TNombre NOT NULL
);


CREATE TABLE empleados(
    cedula_empleado VARCHAR(10) NOT NULL,
    salario_empleado INT NOT NULL,
    actualmente_trabaja BOOLEAN
);


CREATE TABLE tecnicos(
    cedula_tecnico VARCHAR(10) NOT NULL,
    comision_servicio INT NOT NULL,
    id_especializacion INT NOT NULL
);


CREATE TABLE vendedores(
    cedula_vendedor VARCHAR(10) NOT NULL,
    comision_venta INT NOT NULL
);


CREATE TABLE especializaciones(
    id INT NOT NULL,
    especializacion TEspecializacion NOT NULL
);


CREATE TABLE serviciosTecnicos(
    id INT NOT NULL,
    id_tecnico VARCHAR(10) NOT NULL,
    fecha_inicio_servicio TIMESTAMP NOT NULL,
    fecha_estimada_entrega TIMESTAMP NOT NULL,
    fecha_entrega TIMESTAMP,
    id_estado_servicio INT NOT NULL,
    id_catalogo_servicio INT NOT NULL,
    id_estado_pago INT NOT NULL
);


CREATE TABLE catalogodeServicios(
    id INT NOT NULL,
    descripcion_servicio VARCHAR(200) NOT NULL,
    precio_base INT NOT NULL
);


CREATE TABLE estadosDeServicios(
    id INT NOT NULL,
    nombre_estado TEstado NOT NULL
);


CREATE TABLE estadosDePago(
    id INT NOT NULL,
    nombre_estado_pago TEstadoPago NOT NULL
);


CREATE TABLE clientes(
    cedula_cliente VARCHAR(10) NOT NULL
);


CREATE TABLE ventas(
    id INT NOT NULL,
    fecha_venta TIMESTAMP NOT NULL,
    total_venta INT NOT NULL,
    cedula_cliente VARCHAR(10) NOT NULL,
    cedula_vendedor VARCHAR(10) NOT NULL
);


CREATE TABLE detallesdeVenta(
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario INT NOT NULL
);


CREATE TABLE productos(
    id INT NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    precio_unitario_producto INT NOT NULL,
    cantidad_producto INT NOT NULL,
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    id_inventario INT NOT NULL
);


CREATE TABLE proveedores(
    id INT NOT NULL,
    telefono_proveedor TTelefono NOT NULL,
    email_proveedor TEmail NOT NULL,
    nombre_proveedor VARCHAR(100) NOT NULL,
    actualmente_provee BOOLEAN
);


CREATE TABLE inventarios(
    id INT NOT NULL,
    descripcion_inventario VARCHAR(200) NOT NULL
);


CREATE TABLE categorias(
    id INT NOT NULL,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion_categoria VARCHAR(200) NOT NULL
);