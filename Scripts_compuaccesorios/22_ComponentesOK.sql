BEGIN;

-- Crear datos necesarios para la prueba
SELECT SV_CATEGORIA.ad(
    986001, 'Accesorios Prueba', 'Categoria de prueba'
);

SELECT SV_INVENTARIO.ad(
    986001, 'Inventario de prueba'
);

SELECT SV_PROVEEDOR.ad(
    986001, '3109860001',
    'proveedor986001@correo.com', 'Proveedor Prueba'
);

-- Crear producto con 10 unidades
SELECT SV_PRODUCTO.ad(
    986001, 'Teclado Prueba',
    25000, 10, 986001, 986001, 986001
);

-- Crear vendedor
SELECT SV_EMPLEADO.ad_vendedor(
    '9860000001', 'vendedor986001@correo.com',
    '3119860001', 'Vendedor Prueba',
    2000000, 3000
);

-- Crear cliente
SELECT SV_CLIENTE.ad(
    '9860000002', 'cliente986002@correo.com',
    '3129860002', 'Cliente Prueba'
);

-- Registrar venta
SELECT SV_VENTA.ad(
    986001, '9860000002', '9860000001'
);

-- Probar los componentes y sus triggers
DO $$
BEGIN

    -- Agregar 3 unidades a la venta
    PERFORM SV_VENTA.ad_detalle(986001, 986001, 3);

    IF (SELECT cantidad_producto FROM productos
        WHERE id = 986001) IS DISTINCT FROM 7 THEN
        RAISE EXCEPTION 'Error al descontar inventario';
    END IF;

    IF (SELECT total_venta FROM ventas
        WHERE id = 986001) IS DISTINCT FROM 75000 THEN
        RAISE EXCEPTION 'Error al calcular total';
    END IF;

    RAISE NOTICE 'OK: Venta registrada correctamente';
    RAISE NOTICE 'OK: Inventario descontado a 7 unidades';
    RAISE NOTICE 'OK: Total de venta = 75000';

    -- Modificar cantidad vendida a 5
    PERFORM SV_VENTA.up_detalle(986001, 986001, 5);

    IF (SELECT cantidad_producto FROM productos
        WHERE id = 986001) IS DISTINCT FROM 5 THEN
        RAISE EXCEPTION 'Error al actualizar inventario';
    END IF;

    IF (SELECT total_venta FROM ventas
        WHERE id = 986001) IS DISTINCT FROM 125000 THEN
        RAISE EXCEPTION 'Error al actualizar total';
    END IF;

    RAISE NOTICE 'OK: Cantidad actualizada a 5';
    RAISE NOTICE 'OK: Inventario actualizado a 5';
    RAISE NOTICE 'OK: Total actualizado a 125000';

    -- Eliminar detalle de venta
    PERFORM SV_VENTA.de_detalle(986001, 986001);

    IF (SELECT cantidad_producto FROM productos
        WHERE id = 986001) IS DISTINCT FROM 10 THEN
        RAISE EXCEPTION 'Error al devolver inventario';
    END IF;

    RAISE NOTICE 'OK: Inventario restaurado a 10';

END $$;

-- Deshacer los cambios de la prueba
ROLLBACK;