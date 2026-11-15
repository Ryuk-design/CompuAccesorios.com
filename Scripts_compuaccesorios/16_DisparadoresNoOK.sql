-- PREPARACIÓN
INSERT INTO personas (cedula, email, telefono, nombre) VALUES
('1000000001', 'p1@correo.com', '3001000001', 'Carlos Perez'),
('1000000002', 'p2@correo.com', '3001000002', 'Laura Gomez'),
('1000000003', 'p3@correo.com', '3001000003', 'Maria Lopez'),
('1000000005', 'p5@correo.com', '3001000005', 'Ana Torres');

INSERT INTO empleados (cedula_empleado, salario_empleado) VALUES
('1000000001', 2000000),
('1000000002', 2000000);

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
(2, 'Teclado USB', 25000, 10, 1, 1, 1),
(7, 'Parlantes',   25000, 10, 1, 1, 1);


-- TRIGGER: la cedula de una persona no se puede modificar

-- se intenta modificar la cedula
UPDATE personas SET cedula = '1999999999' WHERE cedula = '1000000005';
-- esperado: La cedula de una persona no se puede modificar


-- TRIGGER: un tecnico no puede ser vendedor

-- Laura ya es vendedora y se intenta registrar como tecnica
INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion)
VALUES ('1000000002', 5000, 1);
-- esperado: El empleado 1000000002 ya es vendedor, no puede ser tecnico


-- TRIGGER: un vendedor no puede ser tecnico

-- Carlos ya es tecnico y se intenta registrar como vendedor
INSERT INTO vendedores (cedula_vendedor, comision_venta)
VALUES ('1000000001', 3000);
-- esperado: El empleado 1000000001 ya es tecnico, no puede ser vendedor


-- TRIGGER: un servicio Entregado debe tener fecha de entrega

-- estado Entregado sin fecha de entrega
INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago)
VALUES (102, '1000000001', '2026-10-18 09:00', '2026-10-19 09:00', 2, 1, 1);
-- esperado: Un servicio en estado Entregado debe tener fecha de entrega


-- TRIGGER: no se elimina un servicio en estado Entregado

-- se intenta eliminar un servicio Entregado
INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, fecha_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago)
VALUES (104, '1000000001', '2026-10-18 09:00', '2026-10-19 09:00', '2026-10-19 10:00', 2, 1, 1);

DELETE FROM serviciosTecnicos WHERE id = 104;
-- esperado: No se puede eliminar un servicio en estado Entregado


-- TRIGGER: no se vende mas de lo disponible

-- se intentan vender 11 unidades del producto 2, que tiene 10
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
VALUES (202, 0, '1000000003', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (202, 2, 11, 25000);
-- esperado: Existencias insuficientes del producto 2: disponibles 10, solicitadas 11

-- se modifica un detalle a una cantidad mayor que el stock
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
VALUES (208, 0, '1000000003', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (208, 7, 5, 25000);

UPDATE detallesDeVenta SET cantidad = 20 WHERE id_venta = 208 AND id_producto = 7;
-- esperado: Existencias insuficientes del producto 7: disponibles 10, solicitadas 20


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