-- MANTENER SERVICIO TECNICO
-- La fecha estimada de entrega debe ser mayor o igual a la fecha de inicio.
ALTER TABLE serviciosTecnicos
ADD CONSTRAINT chk_serviciosTecnicos_fecha_estimada_entrega
    CHECK(fecha_estimada_entrega >= fecha_inicio_servicio);


-- La fecha de entrega, cuando exista, debe ser mayor o igual a la fecha de inicio.
ALTER TABLE serviciosTecnicos
ADD CONSTRAINT chk_serviciosTecnicos_fecha_entrega
    CHECK(fecha_entrega >= fecha_inicio_servicio);