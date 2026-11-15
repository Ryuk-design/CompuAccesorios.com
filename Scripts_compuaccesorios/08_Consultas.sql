-- ADMINISTRADOR
-- CONSULTAR VENTAS DEL ÚLTIMO MES
SELECT v.id AS id_venta,
       v.fecha_venta,
       v.total_venta,
       v.cedula_cliente,
       v.cedula_vendedor,
       p.nombre AS nombre_vendedor
FROM ventas v
JOIN personas p ON p.cedula = v.cedula_vendedor
WHERE v.fecha_venta >= CURRENT_TIMESTAMP - INTERVAL '1 month';


-- CONSULTAR VENTAS PROCESADAS POR VENDEDOR (ultimo mes)
SELECT v.cedula_vendedor,
       p.nombre AS nombre_vendedor,
       COUNT(*) AS cantidad_ventas,
       SUM(v.total_venta) AS total_vendido
FROM ventas v
JOIN personas p ON p.cedula = v.cedula_vendedor
WHERE v.fecha_venta >= CURRENT_TIMESTAMP - INTERVAL '1 month'
GROUP BY v.cedula_vendedor, p.nombre;


-- CONSULTAR SERVICIOS TECNICOS ASIGNADOS A CADA TECNICO Y SUS CLIENTES
SELECT s.id AS id_servicio,
       s.id_tecnico AS cedula_tecnico,
       pt.nombre AS nombre_tecnico,
       s.cedula_cliente,
       pc.nombre AS nombre_cliente,
       cs.descripcion_servicio,
       es.nombre_estado,
       s.fecha_inicio_servicio,
       s.fecha_estimada_entrega,
       s.fecha_entrega
FROM serviciosTecnicos s
JOIN personas pt ON pt.cedula = s.id_tecnico
JOIN personas pc ON pc.cedula = s.cedula_cliente
JOIN catalogoDeServicios cs ON cs.id = s.id_catalogo_servicio
JOIN estadosDeServicios es ON es.id = s.id_estado_servicio;


-- CONSULTAR LA CATEGORIA CON LOS PRODUCTOS MAS VENDIDOS
SELECT c.id AS id_categoria,
       c.nombre_categoria,
       SUM(d.cantidad) AS unidades_vendidas
FROM categorias c
JOIN productos p ON p.id_categoria = c.id
JOIN detallesDeVenta d ON d.id_producto = p.id
GROUP BY c.id, c.nombre_categoria
ORDER BY unidades_vendidas DESC
LIMIT 1;


-- CONSULTAR CUANTO STOCK TIENE CADA PRODUCTO
SELECT p.id AS id_producto,
       p.nombre_producto,
       c.nombre_categoria,
       i.descripcion_inventario,
       p.cantidad_producto AS stock
FROM productos p
JOIN categorias c ON c.id = p.id_categoria
JOIN inventarios i ON i.id = p.id_inventario;


-- VENDEDOR
-- CONSULTAR CATALOGO DE PRODUCTOS DISPONIBLES Y PRECIOS
SELECT p.id AS id_producto,
       p.nombre_producto,
       c.nombre_categoria,
       p.precio_unitario_producto AS precio,
       p.cantidad_producto AS existencias
FROM productos p
JOIN categorias c ON c.id = p.id_categoria
WHERE p.cantidad_producto > 0;


-- CONSULTAR HISTORIAL DE VENTAS REALIZADAS POR EL VENDEDOR
-- (cambiar la cedula por la del vendedor)
SELECT v.cedula_vendedor,
       v.id AS id_venta,
       v.fecha_venta,
       v.cedula_cliente,
       pc.nombre AS nombre_cliente,
       v.total_venta,
       ve.comision_venta
FROM ventas v
JOIN vendedores ve ON ve.cedula_vendedor = v.cedula_vendedor
JOIN personas pc ON pc.cedula = v.cedula_cliente
WHERE v.cedula_vendedor = '1000001958'
ORDER BY v.fecha_venta DESC;


-- TECNICO
-- CONSULTAR SERVICIOS TECNICOS ASIGNADOS
-- (cambiar la cedula por la del tecnico)
SELECT s.id AS id_servicio,
       s.id_tecnico AS cedula_tecnico,
       s.cedula_cliente,
       pc.nombre AS nombre_cliente,
       cs.descripcion_servicio,
       es.nombre_estado,
       s.fecha_inicio_servicio,
       s.fecha_estimada_entrega,
       s.fecha_entrega
FROM serviciosTecnicos s
JOIN personas pc ON pc.cedula = s.cedula_cliente
JOIN catalogoDeServicios cs ON cs.id = s.id_catalogo_servicio
JOIN estadosDeServicios es ON es.id = s.id_estado_servicio
WHERE s.id_tecnico = '1000000594'
ORDER BY s.fecha_inicio_servicio DESC;


-- CONSULTAR HISTORIAL DE CLIENTES ATENDIDOS
-- (cambiar la cedula por la del tecnico)
SELECT s.id_tecnico AS cedula_tecnico,
       s.cedula_cliente,
       pc.nombre AS nombre_cliente,
       pc.telefono,
       COUNT(*) AS servicios_realizados,
       MAX(s.fecha_inicio_servicio) AS ultimo_servicio
FROM serviciosTecnicos s
JOIN personas pc ON pc.cedula = s.cedula_cliente
WHERE s.id_tecnico = '1000000594'
GROUP BY s.id_tecnico, s.cedula_cliente, pc.nombre, pc.telefono;