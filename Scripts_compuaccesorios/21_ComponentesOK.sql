-- PRUEBAS DE COMPONENTES

-- REGISTRAR PERSONA
CALL registrarPersona(
    '9000000001',
    'persona9001@correo.com',
    '3009000001',
    'Andres Ramirez'
);

SELECT * FROM Personas WHERE cedula = '9000000001';


-- REGISTRAR CLIENTE
CALL registrarCliente('9000000001');

SELECT * FROM Clientes WHERE cedula_cliente = '9000000001';


-- REGISTRAR EMPLEADO
CALL registrarEmpleado('9000000001', 1800000);

SELECT * FROM Empleados WHERE cedula_empleado = '9000000001';


-- REGISTRAR TECNICO
CALL registrarTecnico('9000000001', 5000, 1);

SELECT * FROM Tecnicos WHERE cedula_tecnico = '9000000001';


-- REGISTRAR VENDEDOR
-- Se usa otra persona para no mezclar tecnico y vendedor
CALL registrarPersona(
    '9000000002',
    'persona9002@correo.com',
    '3009000002',
    'Daniel Torres'
);

CALL registrarEmpleado('9000000002', 1900000);
CALL registrarVendedor('9000000002', 3000);

SELECT * FROM Vendedores WHERE cedula_vendedor = '9000000002';


-- REGISTRAR CATEGORIA
CALL registrarCategoria(900, 'Accesorios nuevos', 'Accesorios para computadores');

SELECT * FROM Categorias WHERE id = 900;


-- REGISTRAR INVENTARIO
CALL registrarInventario(900, 'Inventario de pruebas');

SELECT * FROM Inventarios WHERE id = 900;


-- REGISTRAR PROVEEDOR
CALL registrarProveedor(
    900,
    '3109000001',
    'proveedor900@correo.com',
    'Proveedor de pruebas'
);

SELECT * FROM Proveedores WHERE id = 900;


-- REGISTRAR PRODUCTO
CALL registrarProducto(
    900,
    'Teclado de prueba',
    80000,
    15,
    900,
    900,
    900
);

SELECT * FROM Productos WHERE id = 900;


-- ACTUALIZAR PRODUCTO
CALL actualizarProducto(900, 'Teclado actualizado', 85000, 20);

SELECT * FROM Productos WHERE id = 900;


-- ACTUALIZAR PROVEEDOR
CALL actualizarProveedor(
    900,
    '3109000002',
    'proveedoractualizado@correo.com',
    'Proveedor actualizado',
    TRUE
);

SELECT * FROM Proveedores WHERE id = 900;
