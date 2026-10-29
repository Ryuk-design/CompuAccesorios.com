-- PREPARACIÓN
INSERT INTO personas (cedula, email, telefono, nombre) VALUES
('1000000001', 'p1@correo.com', '3001000001', 'Carlos Perez'),
('1000000002', 'p2@correo.com', '3001000002', 'Laura Gomez'),
('1000000003', 'p3@correo.com', '3001000003', 'Pedro Ruiz'),
('1000000004', 'p4@correo.com', '3001000004', 'Maria Lopez'),
('1000000005', 'p5@correo.com', '3001000005', 'Sara Diaz'),
('1000000006', 'p6@correo.com', '3001000006', 'Luis Mora');

INSERT INTO empleados (cedula_empleado, salario_empleado) VALUES
('1000000001', 2000000),
('1000000002', 2000000),
('1000000003', 2000000),
('1000000006', 2000000);

INSERT INTO especializaciones (id, especializacion)
VALUES (1, 'Redes y Conectividad');

INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion) VALUES
('1000000001', 5000, 1),
('1000000006', 5000, 1);

INSERT INTO vendedores (cedula_vendedor, comision_venta) VALUES
('1000000002', 3000),
('1000000003', 4000);

INSERT INTO clientes (cedula_cliente) VALUES
('1000000004'),
('1000000005');

INSERT INTO estadosDeServicios (id, nombre_estado) VALUES
(1, 'En proceso'),
(2, 'Entregado');

INSERT INTO estadosDePago (id, nombre_estado_pago) VALUES
(1, 'Pagado'),
(2, 'No pagado');

INSERT INTO catalogoDeServicios (id, descripcion_servicio, precio_base)
VALUES (1, 'Limpieza general de PC', 30000);

INSERT INTO categorias (id, nombre_categoria, descripcion_categoria) VALUES
(1, 'Perifericos', 'Mouse y teclados'),
(2, 'Cables', 'Cables y adaptadores');

INSERT INTO proveedores (id, telefono_proveedor, email_proveedor, nombre_proveedor)
VALUES (1, '3101111111', 'prov@correo.com', 'Proveedor Uno');

INSERT INTO inventarios (id, descripcion_inventario)
VALUES (1, 'Bodega principal');

INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario) VALUES
(1, 'Mouse optico',  25000, 10, 1, 1, 1),
(2, 'Cable HDMI',    15000, 20, 2, 1, 1),
(3, 'Cargador USB',  30000,  5, 2, 1, 1),
(4, 'Audifonos',     20000,  8, 1, 1, 1),
(5, 'Parlantes',     35000,  0, 2, 1, 1);

INSERT INTO ventas (id, fecha_venta, total_venta, cedula_cliente, cedula_vendedor) VALUES
(201, CURRENT_TIMESTAMP - INTERVAL '5 days',  50000, '1000000004', '1000000002'),
(202, CURRENT_TIMESTAMP - INTERVAL '10 days', 60000, '1000000005', '1000000002'),
(203, CURRENT_TIMESTAMP - INTERVAL '3 days',  90000, '1000000004', '1000000003'),
(204, CURRENT_TIMESTAMP - INTERVAL '60 days', 25000, '1000000004', '1000000002');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(201, 1, 2, 25000),
(202, 2, 4, 15000),
(203, 3, 3, 30000),
(204, 1, 1, 25000);

INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, fecha_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago, cedula_cliente) VALUES
(101, '1000000001', CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '18 days', NULL, 1, 1, 2, '1000000004'),
(102, '1000000001', CURRENT_TIMESTAMP - INTERVAL '15 days', CURRENT_TIMESTAMP - INTERVAL '13 days', CURRENT_TIMESTAMP - INTERVAL '14 days', 2, 1, 1, '1000000004'),
(103, '1000000001', CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '8 days', NULL, 1, 1, 2, '1000000005'),
(104, '1000000006', CURRENT_TIMESTAMP - INTERVAL '5 days',  CURRENT_TIMESTAMP - INTERVAL '3 days', NULL, 1, 1, 2, '1000000005');


-- VISTA: vw_ventas_ultimo_mes
-- la venta de hace 60 dias no aparece
SELECT id_venta, total_venta
FROM vw_ventas_ultimo_mes
WHERE id_venta IN (201, 202, 203, 204)
ORDER BY id_venta;
-- esperado: 201 (50000), 202 (60000), 203 (90000)


-- VISTA: vw_ventas_por_vendedor
SELECT cedula_vendedor, cantidad_ventas, total_vendido
FROM vw_ventas_por_vendedor
WHERE cedula_vendedor IN ('1000000002', '1000000003')
ORDER BY cedula_vendedor;
-- esperado: 1000000002 -> 2 ventas, 110000   y   1000000003 -> 1 venta, 90000


-- VISTA: vw_servicios_por_tecnico
SELECT id_servicio, nombre_tecnico, nombre_cliente, nombre_estado
FROM vw_servicios_por_tecnico
WHERE cedula_tecnico = '1000000001'
ORDER BY id_servicio;
-- esperado: 101 (Maria, En proceso), 102 (Maria, Entregado), 103 (Sara, En proceso)


-- VISTA: vw_categoria_mas_vendida
SELECT nombre_categoria, unidades_vendidas
FROM vw_categoria_mas_vendida;
-- esperado: Cables, 7


-- VISTA: vw_stock_productos
SELECT nombre_producto, stock
FROM vw_stock_productos
WHERE id_producto IN (4, 5)
ORDER BY id_producto;
-- esperado: Audifonos 8, Parlantes 0


-- VISTA: vw_catalogo_productos_disponibles
-- el producto sin existencias no aparece
SELECT nombre_producto, precio, existencias
FROM vw_catalogo_productos_disponibles
WHERE id_producto IN (4, 5)
ORDER BY id_producto;
-- esperado: solo Audifonos, 20000, 8


-- VISTA: vw_historial_ventas_vendedor
SELECT id_venta, nombre_cliente, total_venta, comision_venta
FROM vw_historial_ventas_vendedor
WHERE cedula_vendedor = '1000000002'
ORDER BY id_venta;
-- esperado: 201 (Maria), 202 (Sara), 204 (Maria), todas con comision 3000


-- VISTA: vw_clientes_atendidos_por_tecnico
SELECT nombre_cliente, servicios_realizados
FROM vw_clientes_atendidos_por_tecnico
WHERE cedula_tecnico = '1000000001'
ORDER BY nombre_cliente;
-- esperado: Maria Lopez 2 servicios, Sara Diaz 1 servicio