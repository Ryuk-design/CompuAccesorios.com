-- SeguridadNoOK
-- El vendedor intenta usar una consulta del administrador
SET ROLE rol_vendedor;
SELECT SV_ADMINISTRADOR.co_stock_productos('fallo_1');
RESET ROLE;


-- El tecnico intenta registrar una venta
SET ROLE rol_tecnico;
SELECT SV_VENDEDOR.ad_venta(1, '1000000001', '1000000002');
RESET ROLE;


-- El gerente intenta modificar un producto
SET ROLE rol_gerente;
SELECT SV_ADMINISTRADOR.up_producto(1, 'X', 1000, 1, 1, 1, 1);
RESET ROLE;


-- El vendedor intenta saltarse su actor y llamar al componente base
SET ROLE rol_vendedor;
SELECT SV_VENTA.de(1);
RESET ROLE;


-- El tecnico intenta leer una tabla directamente
SET ROLE rol_tecnico;
SELECT * FROM productos;
RESET ROLE;


-- El gerente intenta leer una vista directamente
SET ROLE rol_gerente;
SELECT * FROM vw_stock_productos;
RESET ROLE;