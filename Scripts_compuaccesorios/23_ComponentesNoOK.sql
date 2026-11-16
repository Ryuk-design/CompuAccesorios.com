-- PRUEBAS DE COMPONENTES NO OK

-- PERSONA CON CORREO INCORRECTO
DO $$
BEGIN
    CALL registrarPersona(
        '9000000010',
        'correoinvalido',
        '3009000010',
        'Persona Prueba'
    );
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se permitio registrar el correo incorrecto';
END;
$$;


-- EMPLEADO CON SALARIO NEGATIVO
DO $$
BEGIN
    CALL registrarEmpleado('9000000011', -1000);
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se permitio el salario negativo';
END;
$$;


-- TECNICO CON COMISION EN CERO
DO $$
BEGIN
    CALL registrarTecnico('9000000012', 0, 1);
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se permitio la comision en cero';
END;
$$;


-- VENDEDOR CON COMISION NEGATIVA
DO $$
BEGIN
    CALL registrarVendedor('9000000013', -500);
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se permitio la comision negativa';
END;
$$;


-- PRODUCTO CON PRECIO EN CERO
DO $$
BEGIN
    CALL registrarProducto(
        910,
        'Producto incorrecto',
        0,
        10,
        1,
        1,
        1
    );
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se permitio el precio en cero';
END;
$$;


-- PRODUCTO CON CANTIDAD NEGATIVA
DO $$
BEGIN
    CALL registrarProducto(
        911,
        'Producto incorrecto',
        50000,
        -5,
        1,
        1,
        1
    );
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se permitio la cantidad negativa';
END;
$$;


-- PRODUCTO CON CATEGORIA QUE NO EXISTE
DO $$
BEGIN
    CALL registrarProducto(
        912,
        'Producto sin categoria',
        50000,
        10,
        99999,
        1,
        1
    );
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se permitio una categoria inexistente';
END;
$$;


-- ACTUALIZAR UN PRODUCTO QUE NO EXISTE
DO $$
BEGIN
    CALL actualizarProducto(
        99999,
        'Producto inexistente',
        50000,
        10
    );
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se pudo actualizar un producto inexistente';
END;
$$;


-- ACTUALIZAR UN PROVEEDOR QUE NO EXISTE
DO $$
BEGIN
    CALL actualizarProveedor(
        99999,
        '3109000099',
        'proveedorinexistente@correo.com',
        'Proveedor inexistente',
        TRUE
    );
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Prueba correcta: no se pudo actualizar un proveedor inexistente';
END;
$$;

