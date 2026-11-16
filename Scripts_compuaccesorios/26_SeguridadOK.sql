-- SeguridadOk
-- 1. El administrador consulta las ventas del ultimo mes
SET ROLE rol_administrador;
BEGIN;
SELECT SV_ADMINISTRADOR.co_ventas_ultimo_mes('ref_admin');
FETCH ALL IN "ref_admin";
COMMIT;
RESET ROLE;

-- 2. El vendedor consulta el catalogo de productos disponibles
SET ROLE rol_vendedor;
BEGIN;
SELECT SV_VENDEDOR.co_catalogo_productos('ref_vendedor');
FETCH ALL IN "ref_vendedor";
COMMIT;
RESET ROLE;

-- 3. El tecnico consulta el historial de clientes atendidos (cambiar la cedula por la de un tecnico)
SET ROLE rol_tecnico;
BEGIN;
SELECT SV_TECNICO.co_historial_clientes_atendidos('ref_tecnico', '1000000594');
FETCH ALL IN "ref_tecnico";
COMMIT;
RESET ROLE;

-- 4. El gerente consulta el producto mas vendido
SET ROLE rol_gerente;
BEGIN;
SELECT SV_GERENTE.co_producto_mas_vendido('ref_gerente');
FETCH ALL IN "ref_gerente";
COMMIT;
RESET ROLE;