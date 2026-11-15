-- PREPARACIÓN
INSERT INTO personas (cedula, email, telefono, nombre) VALUES
('1000000001', 'p1@correo.com', '3001000001', 'Carlos Perez'),
('1000000002', 'p2@correo.com', '3001000002', 'Laura Gomez'),
('1000000003', 'p3@correo.com', '3001000003', 'Maria Lopez'),
('1000000004', 'p4@correo.com', '3001000004', 'Pedro Ruiz');

INSERT INTO empleados (cedula_empleado, salario_empleado) VALUES
('1000000001', 2000000),
('1000000002', 2000000),
('1000000004', 2000000);

INSERT INTO especializaciones (id, especializacion)
VALUES (1, 'Redes y Conectividad');

INSERT INTO tecnicos (cedula_tecnico, comision_servicio, id_especializacion)
VALUES ('1000000001', 5000, 1);

INSERT INTO vendedores (cedula_vendedor, comision_venta) VALUES
('1000000002', 3000),
('1000000004', 3000);

INSERT INTO clientes (cedula_cliente)
VALUES ('1000000003');

INSERT INTO categorias (id, nombre_categoria, descripcion_categoria)
VALUES (1, 'Perifericos', 'Mouse, teclados y similares');

INSERT INTO proveedores (id, telefono_proveedor, email_proveedor, nombre_proveedor)
VALUES (1, '3101111111', 'prov@correo.com', 'Proveedor Uno');

INSERT INTO inventarios (id, descripcion_inventario)
VALUES (1, 'Bodega principal');

INSERT INTO productos (id, nombre_producto, precio_unitario_producto, cantidad_producto, id_categoria, id_proveedor, id_inventario)
VALUES (1, 'Mouse optico', 25000, 10, 1, 1, 1);


-- ACCION DE REFERENCIA: al eliminar un empleado se elimina su registro como tecnico

-- se elimina un empleado tecnico que no tiene servicios tecnicos
DELETE FROM empleados WHERE cedula_empleado = '1000000001';

SELECT COUNT(*) FROM tecnicos WHERE cedula_tecnico = '1000000001';   -- esperado: 0


-- ACCION DE REFERENCIA: al eliminar un empleado se elimina su registro como vendedor

-- se elimina un empleado vendedor que no tiene ventas
DELETE FROM empleados WHERE cedula_empleado = '1000000002';

SELECT COUNT(*) FROM vendedores WHERE cedula_vendedor = '1000000002';   -- esperado: 0


-- ACCION DE REFERENCIA: al anular una venta se elimina tambien su detalle

-- se elimina una venta con detalles
INSERT INTO ventas (id, total_venta, cedula_cliente, cedula_vendedor)
VALUES (201, 0, '1000000003', '1000000004');

INSERT INTO detallesDeVenta (id_venta, id_producto, cantidad, precio_unitario)
VALUES (201, 1, 4, 25000);

SELECT cantidad_producto FROM productos WHERE id = 1;   -- esperado: 6

DELETE FROM ventas WHERE id = 201;

SELECT COUNT(*) FROM detallesDeVenta WHERE id_venta = 201;   -- esperado: 0

SELECT cantidad_producto FROM productos WHERE id = 1;   -- esperado: 10 (el trigger devolvio las existencias)


TRUNCATE TABLE
    personas,
    empleados,
    especializaciones,
    tecnicos,
    vendedores,
    clientes,
    categorias,
    proveedores,
    inventarios,
    productos,
    ventas,
    detallesdeventa
CASCADE;