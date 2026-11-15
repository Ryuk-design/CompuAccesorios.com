-- PREPARACIÓN
INSERT INTO personas (cedula, email, telefono, nombre)
VALUES ('1000000001', 'tecnico@correo.com', '3001234567', 'Carlos Perez');

INSERT INTO empleados (cedula_empleado, salario_empleado)
VALUES ('1000000001', 2000000);

INSERT INTO especializaciones (id, especializacion)
VALUES (1, 'Redes y Conectividad');

INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion)
VALUES ('1000000001', 5000, 1);

INSERT INTO estadosDeServicios (id, nombre_estado)
VALUES (1, 'En proceso');

INSERT INTO estadosDePago (id, nombre_estado_pago)
VALUES (1, 'No pagado');

INSERT INTO catalogoDeServicios (id, descripcion_servicio, precio_base)
VALUES (1, 'Limpieza general de PC', 30000);


-- RESTRICCIÓN 1: fecha_estimada_entrega >= fecha_inicio_servicio

-- fecha estimada anterior a la fecha de inicio
INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago)
VALUES (2, '1000000001', '2026-10-18 09:00', '2026-10-17 09:00', 1, 1, 1);


-- RESTRICCIÓN 2: fecha_entrega >= fecha_inicio_servicio

-- fecha de entrega anterior a la fecha de inicio
INSERT INTO serviciosTecnicos (id, id_tecnico, fecha_inicio_servicio, fecha_estimada_entrega, fecha_entrega, id_estado_servicio, id_catalogo_servicio, id_estado_pago)
VALUES (4, '1000000001', '2026-10-18 09:00', '2026-10-19 09:00', '2026-10-17 09:00', 1, 1, 1);