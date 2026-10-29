-- INDICE: idx_ventas_fecha_venta
EXPLAIN
SELECT * FROM ventas
WHERE fecha_venta >= CURRENT_TIMESTAMP - INTERVAL '1 month';
-- esperado: Bitmap Index Scan on idx_ventas_fecha_venta


-- INDICE: idx_ventas_cedula_vendedor
EXPLAIN
SELECT * FROM ventas
WHERE cedula_vendedor = '1000000002';
-- esperado: Bitmap Index Scan on idx_ventas_cedula_vendedor


-- INDICE: idx_serviciosTecnicos_id_tecnico
EXPLAIN
SELECT * FROM serviciosTecnicos
WHERE id_tecnico = '1000000001';
-- esperado: Bitmap Index Scan on idx_serviciostecnicos_id_tecnico


-- INDICE: idx_serviciosTecnicos_cedula_cliente
EXPLAIN
SELECT * FROM serviciosTecnicos
WHERE cedula_cliente = '1000000004';
-- esperado: Bitmap Index Scan on idx_serviciostecnicos_cedula_cliente


-- INDICE: idx_detallesDeVenta_id_producto
EXPLAIN
SELECT * FROM detallesDeVenta
WHERE id_producto = 1;
-- esperado: Bitmap Index Scan on idx_detallesdeventa_id_producto


-- INDICE: idx_productos_id_categoria
EXPLAIN
SELECT * FROM productos
WHERE id_categoria = 1;
-- esperado: Bitmap Index Scan on idx_productos_id_categoria