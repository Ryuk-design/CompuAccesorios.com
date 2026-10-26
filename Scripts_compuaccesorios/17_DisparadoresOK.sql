-- PREPARACIÓN
INSERT INTO personas (cedula, email, telefono, nombre) VALUES
('1000000001', 'p1@correo.com', '3001000001', 'Carlos Perez'),
('1000000002', 'p2@correo.com', '3001000002', 'Laura Gomez'),
('1000000003', 'p3@correo.com', '3001000003', 'Maria Lopez'),
('1000000004', 'p4@correo.com', '3001000004', 'Pedro Ruiz'),
('1000000006', 'p6@correo.com', '3001000006', 'Luis Mora'),
('1000000007', 'p7@correo.com', '3001000007', 'Sara Diaz');

INSERT INTO empleados (cedula_empleado, salario_empleado) VALUES
('1000000001', 2000000),
('1000000002', 2000000),
('1000000006', 2000000),
('1000000007', 2000000);

INSERT INTO especializaciones (id, especializacion)
VALUES (1, 'Redes y Conectividad');

INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion)
VALUES ('1000000001', 5000, 1);

INSERT INTO vendedores (cedula_vendedor, comision_venta)
VALUES ('1000000002', 3000);

INSERT INTO clientes (cedula_cliente)
VALUES ('1000000003');

INSERT INTO estadosDeServicios (id, nombre_estado) VALUES
(1, 'En proceso'),
(2, 'Entregado');

INSERT INTO estadosDePago (id, nombre_estado_pago)
VALUES (1, 'No pagado');

INSERT INTO catalogoDeServicios (id, descripcion_servicio, precio_base)
VALUES (1, 'Limpieza general de PC', 30000);

INSERT INTO categorias (id, nombre_categoria, descripcion_categoria)
VALUES (1, 'Perifericos', 'Mouse, teclados y similares');

INSERT INTO proveedores (id, telefono_proveedor, email_proveedor, nombre_proveedor)
VALUES (1, '3101111111', 'prov@correo.com', 'Proveedor Uno');

INSERT INTO inventarios (id, descripcion_inventario)
VALUES (1, 'Bodega principal');

INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario) VALUES
(1, 'Mouse optico',  25000, 10, 1, 1, 1),
(3, 'Cable HDMI',    25000, 10, 1, 1, 1),
(4, 'Cargador USB',  25000, 10, 1, 1, 1),
(5, 'Adaptador VGA', 25000, 10, 1, 1, 1),
(6, 'Audifonos',     25000, 10, 1, 1, 1);


-- TRIGGER: la cedula de una persona no se puede modificar

-- se modifica otro dato, no la cedula
UPDATE personas SET telefono = '3009999999' WHERE cedula = '1000000004';


-- TRIGGER: un tecnico no puede ser vendedor

-- un empleado que no es vendedor se registra como tecnico
INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion)
VALUES ('1000000006', 5000, 1);


-- TRIGGER: un vendedor no puede ser tecnico

-- un empleado que no es tecnico se registra como vendedor
INSERT INTO vendedores (cedula_vendedor, comision_venta)
VALUES ('1000000007', 3000);


-- TRIGGER: un servicio Entregado debe tener fecha de entrega

-- estado Entregado con fecha de entrega
INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, fecha_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago)
VALUES (101, '1000000001', '2026-10-18 09:00', '2026-10-19 09:00', '2026-10-19 10:00', 2, 1, 1);


-- TRIGGER: no se elimina un servicio en estado Entregado

-- se elimina un servicio En proceso
INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago)
VALUES (103, '1000000001', '2026-10-18 09:00', '2026-10-19 09:00', 1, 1, 1);

DELETE FROM serviciosTecnicos WHERE id = 103;


-- TRIGGER: no se vende mas de lo disponible

-- se venden 5 unidades del producto 1, que tiene 10
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
VALUES (201, 0, '1000000003', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (201, 1, 5, 25000);


-- TRIGGER: descuenta y devuelve existencias

-- al insertar un detalle el stock baja
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
VALUES (203, 0, '1000000003', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (203, 3, 4, 25000);

SELECT cantidad_producto FROM productos WHERE id = 3;   -- esperado: 6

-- al eliminar un detalle el stock se devuelve
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
VALUES (204, 0, '1000000003', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (204, 4, 4, 25000);

DELETE FROM detallesDeVenta WHERE id_venta = 204 AND id_producto = 4;

SELECT cantidad_producto FROM productos WHERE id = 4;   -- esperado: 10


-- TRIGGER: recalcula el total de la venta

-- al insertar un detalle el total se calcula
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
VALUES (205, 0, '1000000003', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (205, 5, 2, 10000);

SELECT total_venta FROM ventas WHERE id = 205;          -- esperado: 20000

-- al mover un detalle a otra venta se recalculan las dos
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor) VALUES
(206, 0, '1000000003', '1000000002'),
(207, 0, '1000000003', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (206, 6, 2, 10000);

UPDATE detallesDeVenta SET id_venta = 207 WHERE id_venta = 206 AND id_producto = 6;

SELECT id, total_venta FROM ventas WHERE id IN (206, 207) ORDER BY id;   -- esperado: 206 = 0 y 207 = 20000


TRUNCATE TABLE
    personas,
    empleados,
    especializaciones,
    tecnicos,
    vendedores,
    clientes,
    estadosDeServicios,
    estadosDePago,
    catalogoDeServicios,
    serviciosTecnicos,
    categorias,
    proveedores,
    inventarios,
    productos,
    ventas,
    detallesdeventa
CASCADE;