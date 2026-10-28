-- Ejecutar 2 veces
-- Falla porque viola la restricción de llave primaria, intentando registrar una cédula que ya fue insertada previamente.
INSERT INTO personas (cedula, email, telefono, nombre) VALUES ('1000000001', 'nuevo_correo@mail.com', '3111111111', 'Ana Gomez');


-- Ejecutar 2 veces
-- Falla porque viola la restricción de unicidad, intentando usar un correo electrónico que ya le pertenece a otro registro
INSERT INTO personas (cedula, email, telefono, nombre) VALUES ('1000000005', 'correo_ya_existente@mail.com', '3222222222', 'Luis Perez');


-- Falla porque viola la restricción de dominio por obligatoriedad, intentando dejar en nulo el nombre del producto.
INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario) VALUES (2, NULL, 15000, 10, 1, 1, 1);


-- Falla porque viola la restricción del dominio del tipo de dato, intentando ingresar una cadena de texto en un campo numerico
INSERT INTO ventas (id, fecha_venta, total_venta, cedula_cliente, cedula_vendedor) VALUES (10, '2026-10-28 15:00:00', 'cien mil', '1000000001', '1000000002');


-- Falla porque viola la restricción de dominio, intentando insertar un precio negativo.
INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario) VALUES (3, 'Cable USB', -5000, 20, 1, 1, 1);


-- Falla porque viola el dominio intentando enviar un formato de fecha inválido.
INSERT INTO ventas (id, fecha_venta, total_venta, cedula_cliente, cedula_vendedor) VALUES (11, 'fecha-invalida', 50000, '1000000001', '1000000002');