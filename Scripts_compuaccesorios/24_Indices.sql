-- Filtrar ventas por fecha (ultimo mes)
CREATE INDEX idx_ventas_fecha_venta
    ON ventas (fecha_venta);

-- Agrupar ventas por vendedor
CREATE INDEX idx_ventas_cedula_vendedor
    ON ventas (cedula_vendedor);

-- Buscar servicios por tecnico y por cliente
CREATE INDEX idx_serviciosTecnicos_id_tecnico
    ON serviciosTecnicos (id_tecnico);

CREATE INDEX idx_serviciosTecnicos_cedula_cliente
    ON serviciosTecnicos (cedula_cliente);

-- Buscar en que ventas aparece un producto (la PK solo cubre buscar por venta)
CREATE INDEX idx_detallesDeVenta_id_producto
    ON detallesDeVenta (id_producto);

-- Buscar los productos de una categoria
CREATE INDEX idx_productos_id_categoria
    ON productos (id_categoria);