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


-- GERENTE
-- CONSULTAR EL PRODUCTO MAS VENDIDO
-- si hay empate en unidades vendidas, se muestran todos los empatados
SELECT p.id AS id_producto,
       p.nombre_producto,
       c.nombre_categoria,
       SUM(d.cantidad) AS unidades_vendidas
FROM productos p
JOIN categorias c ON c.id = p.id_categoria
JOIN detallesDeVenta d ON d.id_producto = p.id
GROUP BY p.id, p.nombre_producto, c.nombre_categoria
ORDER BY unidades_vendidas DESC
FETCH FIRST 1 ROW WITH TIES;


-- CONSULTAR EL SERVICIO TECNICO MAS COMUN
SELECT cs.id AS id_catalogo_servicio,
       cs.descripcion_servicio,
       COUNT(*) AS veces_solicitado
FROM serviciosTecnicos s
JOIN catalogoDeServicios cs ON cs.id = s.id_catalogo_servicio
GROUP BY cs.id, cs.descripcion_servicio
ORDER BY veces_solicitado DESC
FETCH FIRST 1 ROW WITH TIES;


-- CONSULTAR PRODUCTOS CON BAJO INVENTARIO
-- Se considera bajo inventario 5 unidades o menos
SELECT p.id AS id_producto,
       p.nombre_producto,
       c.nombre_categoria,
       pr.nombre_proveedor,
       p.cantidad_producto AS stock
FROM productos p
JOIN categorias c ON c.id = p.id_categoria
JOIN proveedores pr ON pr.id = p.id_proveedor
WHERE p.cantidad_producto <= 5
ORDER BY p.cantidad_producto, p.nombre_producto;


-- CONSULTAR EL PROVEEDOR MAS FRECUENTE
SELECT pr.id AS id_proveedor,
       pr.nombre_proveedor,
       pr.telefono_proveedor,
       pr.email_proveedor,
       COUNT(p.id) AS productos_suministrados
FROM proveedores pr
JOIN productos p ON p.id_proveedor = pr.id
GROUP BY pr.id, pr.nombre_proveedor, pr.telefono_proveedor, pr.email_proveedor
ORDER BY productos_suministrados DESC
FETCH FIRST 1 ROW WITH TIES;


--Consultas JSON


-- 1. Productos de una marca (->> devuelve la llave como texto)
SELECT id, nombre_producto, especificaciones->>'marca' AS marca
FROM productos
WHERE especificaciones->>'marca' = 'Logitech'
ORDER BY id
LIMIT 3;
-- esperado: ids 8, 16 y 24


-- 2. Contiene (@>): marca HP y color Negro
SELECT COUNT(*) AS productos
FROM productos
WHERE especificaciones @> '{"marca": "HP", "color": "Negro"}';
-- esperado: 250


-- 3. Compatibles con macOS (un elemento dentro del arreglo)
SELECT COUNT(*) AS productos
FROM productos
WHERE especificaciones @> '{"compatibilidad": ["macOS"]}';
-- esperado: 6669


-- 4. Peso de 300 gramos o mas (->> y cast a numero)
SELECT COUNT(*) AS productos
FROM productos
WHERE (especificaciones->>'peso_gramos')::int >= 300;
-- esperado: 5001


-- 5. La misma consulta con jsonpath
SELECT COUNT(*) AS productos
FROM productos
WHERE especificaciones @? '$.peso_gramos ? (@ >= 300)';
-- esperado: 5001


-- 6. Expandir el arreglo: una fila por sistema operativo
SELECT p.id, s AS sistema
FROM productos p, jsonb_array_elements_text(p.especificaciones->'compatibilidad') AS s
WHERE p.id IN (1, 8)
ORDER BY p.id, LOWER(s);
-- esperado: producto 1 -> macOS, Windows
--           producto 8 -> Android, Linux, macOS, Windows


-- 7. Productos y precio promedio por marca
SELECT especificaciones->>'marca' AS marca,
       COUNT(*) AS productos,
       ROUND(AVG(precio_unitario_producto)) AS precio_promedio
FROM productos
GROUP BY especificaciones->>'marca'
ORDER BY especificaciones->>'marca' NULLS LAST;
-- esperado: 9 filas (Genius 1250, HP 1250, Kingston 1251, Lenovo 1251, Logitech 1251,
--           Redragon 1251, Samsung 1251, Sony 1250 y una fila sin marca con 1 producto)


-- 8. Cuantos productos soporta cada sistema operativo
SELECT s AS sistema, COUNT(*) AS productos
FROM productos p, jsonb_array_elements_text(p.especificaciones->'compatibilidad') AS s
GROUP BY s
ORDER BY productos DESC, sistema;
-- esperado: Windows 10003, macOS 6669, Linux 6668, Android 3334


-- 9. Unidades vendidas por marca (JSON + tablas relacionales)
SELECT p.especificaciones->>'marca' AS marca, SUM(d.cantidad) AS unidades
FROM detallesDeVenta d
JOIN productos p ON p.id = d.id_producto
GROUP BY p.especificaciones->>'marca'
ORDER BY unidades DESC, marca
LIMIT 3;
-- esperado: Redragon 3882, Sony 3876, Lenovo 3816