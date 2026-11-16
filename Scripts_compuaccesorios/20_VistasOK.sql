-- PREPARACIÓN
-- Datos de referencia (el poblar ya los tiene, por eso ON CONFLICT DO NOTHING)
INSERT INTO especializaciones (id, especializacion) VALUES (5, 'Redes y Conectividad') ON CONFLICT DO NOTHING;
INSERT INTO estadosDeServicios (id, nombre_estado) VALUES (1, 'En proceso'), (2, 'Entregado') ON CONFLICT DO NOTHING;
INSERT INTO estadosDePago (id, nombre_estado_pago) VALUES (1, 'Pagado'), (2, 'No pagado') ON CONFLICT DO NOTHING;

INSERT INTO personas (cedula, email, telefono, nombre) VALUES
('9100000001', 'vt1@vistas.com', '3919100001', 'Carlos Perez'),
('9100000002', 'vt2@vistas.com', '3919100002', 'Laura Gomez'),
('9100000003', 'vt3@vistas.com', '3919100003', 'Pedro Ruiz'),
('9100000004', 'vt4@vistas.com', '3919100004', 'Maria Lopez'),
('9100000005', 'vt5@vistas.com', '3919100005', 'Sara Diaz'),
('9100000006', 'vt6@vistas.com', '3919100006', 'Luis Mora');

INSERT INTO empleados (cedula_empleado, salario_empleado) VALUES
('9100000001', 2000000),
('9100000002', 2000000),
('9100000003', 2000000),
('9100000006', 2000000);

INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion) VALUES
('9100000001', 5000, 5),
('9100000006', 5000, 5);

INSERT INTO vendedores (cedula_vendedor, comision_venta) VALUES
('9100000002', 3000),
('9100000003', 4000);

INSERT INTO clientes (cedula_cliente) VALUES
('9100000004'),
('9100000005');

INSERT INTO catalogoDeServicios (id, descripcion_servicio, precio_base)
VALUES (9101, 'VT Limpieza general de PC', 30000);

INSERT INTO categorias (id, nombre_categoria, descripcion_categoria) VALUES
(9101, 'VT Perifericos', 'Mouse y teclados'),
(9102, 'VT Cables', 'Cables y adaptadores');

INSERT INTO proveedores (id, telefono_proveedor, email_proveedor, nombre_proveedor)
VALUES (9100, '3919200001', 'vt_prov@vistas.com', 'VT Proveedor Uno');

INSERT INTO inventarios (id, descripcion_inventario)
VALUES (9100, 'VT Bodega principal');

INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario) VALUES
(91001, 'VT Mouse optico',  25000,   10, 9101, 9100, 9100),
(91002, 'VT Cable HDMI',    15000, 1020, 9102, 9100, 9100),
(91003, 'VT Cargador USB',  30000,    5, 9102, 9100, 9100),
(91004, 'VT Audifonos',     20000,    8, 9101, 9100, 9100),
(91005, 'VT Parlantes',     35000,    0, 9102, 9100, 9100);

-- 140 productos adicionales del mismo proveedor (con los 5 anteriores suman 145;
-- el poblar tiene como maximo 131 productos por proveedor)
INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario)
SELECT 91100 + g, 'VT Producto bulk ' || g, 1000, 50, 9101, 9100, 9100
FROM generate_series(1, 140) g;

INSERT INTO ventas (id, fecha_venta, total_venta, cedula_cliente, cedula_vendedor) VALUES
(91001, CURRENT_TIMESTAMP - INTERVAL '5 days',  50000, '9100000004', '9100000002'),
(91002, CURRENT_TIMESTAMP - INTERVAL '10 days', 60000, '9100000005', '9100000002'),
(91003, CURRENT_TIMESTAMP - INTERVAL '3 days',  90000, '9100000004', '9100000003'),
(91004, CURRENT_TIMESTAMP - INTERVAL '60 days', 25000, '9100000004', '9100000002'),
(91005, CURRENT_TIMESTAMP - INTERVAL '2 days', 1000000, '9100000004', '9100000002');

-- La venta 91005 vende 1000 unidades del Cable HDMI para que supere al poblar
-- (el poblar vende como maximo 24 unidades por producto y 418 por categoria)
INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(91001, 91001,    2, 25000),
(91002, 91002,    4, 15000),
(91003, 91003,    3, 30000),
(91004, 91001,    1, 25000),
(91005, 91002, 1000,  1000);

INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, fecha_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago, cedula_cliente) VALUES
(91001, '9100000001', CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '18 days', NULL, 1, 9101, 2, '9100000004'),
(91002, '9100000001', CURRENT_TIMESTAMP - INTERVAL '15 days', CURRENT_TIMESTAMP - INTERVAL '13 days', CURRENT_TIMESTAMP - INTERVAL '14 days', 2, 9101, 1, '9100000004'),
(91003, '9100000001', CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '8 days', NULL, 1, 9101, 2, '9100000005'),
(91004, '9100000006', CURRENT_TIMESTAMP - INTERVAL '5 days',  CURRENT_TIMESTAMP - INTERVAL '3 days', NULL, 1, 9101, 2, '9100000005');

-- 150 servicios adicionales del mismo servicio del catalogo (con los 4 anteriores suman 154;
-- el poblar tiene como maximo 122 servicios por catalogo)
INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago, cedula_cliente)
SELECT 91100 + g, '9100000006', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '3 days', 1, 9101, 2, '9100000005'
FROM generate_series(1, 150) g;


-- VISTA: vw_ventas_ultimo_mes
-- la venta de hace 60 dias no aparece
SELECT id_venta, total_venta
FROM vw_ventas_ultimo_mes
WHERE id_venta IN (91001, 91002, 91003, 91004, 91005)
ORDER BY id_venta;
-- esperado: 91001 (50000), 91002 (60000), 91003 (90000), 91005 (1000000)


-- VISTA: vw_ventas_por_vendedor
SELECT cedula_vendedor, cantidad_ventas, total_vendido
FROM vw_ventas_por_vendedor
WHERE cedula_vendedor IN ('9100000002', '9100000003')
ORDER BY cedula_vendedor;
-- esperado: 9100000002 -> 3 ventas, 1110000   y   9100000003 -> 1 venta, 90000


-- VISTA: vw_servicios_por_tecnico
SELECT id_servicio, nombre_tecnico, nombre_cliente, nombre_estado
FROM vw_servicios_por_tecnico
WHERE cedula_tecnico = '9100000001'
ORDER BY id_servicio;
-- esperado: 91001 (Maria, En proceso), 91002 (Maria, Entregado), 91003 (Sara, En proceso)


-- VISTA: vw_categoria_mas_vendida
SELECT nombre_categoria, unidades_vendidas
FROM vw_categoria_mas_vendida;
-- esperado: VT Cables, 1007


-- VISTA: vw_stock_productos
SELECT nombre_producto, stock
FROM vw_stock_productos
WHERE id_producto IN (91004, 91005)
ORDER BY id_producto;
-- esperado: VT Audifonos 8, VT Parlantes 0


-- VISTA: vw_catalogo_productos_disponibles
-- el producto sin existencias no aparece
SELECT nombre_producto, precio, existencias
FROM vw_catalogo_productos_disponibles
WHERE id_producto IN (91004, 91005)
ORDER BY id_producto;
-- esperado: solo VT Audifonos, 20000, 8


-- VISTA: vw_historial_ventas_vendedor
SELECT id_venta, nombre_cliente, total_venta, comision_venta
FROM vw_historial_ventas_vendedor
WHERE cedula_vendedor = '9100000002'
ORDER BY id_venta;
-- esperado: 91001 (Maria), 91002 (Sara), 91004 (Maria), 91005 (Maria), todas con comision 3000


-- VISTA: vw_clientes_atendidos_por_tecnico
SELECT nombre_cliente, servicios_realizados
FROM vw_clientes_atendidos_por_tecnico
WHERE cedula_tecnico = '9100000001'
ORDER BY nombre_cliente;
-- esperado: Maria Lopez 2 servicios, Sara Diaz 1 servicio


-- VISTA: vw_producto_mas_vendido
SELECT nombre_producto, unidades_vendidas
FROM vw_producto_mas_vendido;
-- esperado: VT Cable HDMI, 1004


-- VISTA: vw_servicio_tecnico_mas_comun
SELECT descripcion_servicio, veces_solicitado
FROM vw_servicio_tecnico_mas_comun;
-- esperado: VT Limpieza general de PC, 154


-- VISTA: vw_productos_bajo_inventario
-- se filtra por el proveedor de prueba; los 140 productos adicionales tienen 50 unidades y no aparecen
SELECT nombre_producto, stock
FROM vw_productos_bajo_inventario
WHERE nombre_proveedor = 'VT Proveedor Uno'
ORDER BY stock, nombre_producto;
-- esperado: VT Parlantes 0, VT Cargador USB 2


-- VISTA: vw_proveedor_mas_frecuente
SELECT nombre_proveedor, productos_suministrados
FROM vw_proveedor_mas_frecuente;
-- esperado: VT Proveedor Uno, 145


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