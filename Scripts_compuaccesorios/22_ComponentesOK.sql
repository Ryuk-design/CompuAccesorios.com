BEGIN;

-- Crear categoria
SELECT SV_CATEGORIA.ad(
    986001, 'Accesorios Prueba', 'Categoria de prueba'
);

-- Crear inventario
SELECT SV_INVENTARIO.ad(
    986001, 'Inventario de prueba'
);

-- Crear proveedor
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


-- CREATE: Crear venta
SELECT SV_VENTA.ad(
    986001, '9860000002', '9860000001'
);

DO $$
DECLARE
    v_venta RECORD;
    v_detalle RECORD;
    v_cursor_venta REFCURSOR := 'cursor_venta_prueba';
    v_cursor_detalle REFCURSOR := 'cursor_detalle_prueba';
    v_rechazado BOOLEAN := FALSE;

BEGIN

    PERFORM SV_VENTA.ad_detalle(986001, 986001, 3);

    -- Verificar inventario y total
    IF (SELECT cantidad_producto FROM productos
        WHERE id = 986001) IS DISTINCT FROM 7 THEN
        RAISE EXCEPTION 'Error al descontar inventario';
    END IF;

    IF (SELECT total_venta FROM ventas
        WHERE id = 986001) IS DISTINCT FROM 75000 THEN
        RAISE EXCEPTION 'Error al calcular total';
    END IF;

    RAISE NOTICE 'OK CREATE: Venta registrada';
    RAISE NOTICE 'Inventario: 7 unidades';
    RAISE NOTICE 'Total venta: 75000';

    -- Consultar encabezado de la venta
    PERFORM SV_VENTA.co(v_cursor_venta, 986001);

    FETCH v_cursor_venta INTO v_venta;

    IF NOT FOUND OR v_venta.id IS DISTINCT FROM 986001 THEN
        RAISE EXCEPTION 'Error al consultar la venta';
    END IF;

    RAISE NOTICE 'OK READ: Venta consultada';
    RAISE NOTICE 'ID venta: %, Total: %',
        v_venta.id, v_venta.total_venta;

    CLOSE v_cursor_venta;

    -- Consultar detalle de la venta
    PERFORM SV_VENTA.co_detalle(
        v_cursor_detalle, 986001
    );

    FETCH v_cursor_detalle INTO v_detalle;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error al consultar el detalle';
    END IF;

    IF v_detalle.id_producto IS DISTINCT FROM 986001
       OR v_detalle.cantidad IS DISTINCT FROM 3
       OR v_detalle.subtotal IS DISTINCT FROM 75000 THEN
        RAISE EXCEPTION 'Datos incorrectos en consulta';
    END IF;

    RAISE NOTICE 'OK READ: Detalle consultado';
    RAISE NOTICE 'Producto: %, Cantidad: %, Subtotal: %',
        v_detalle.nombre_producto,
        v_detalle.cantidad,
        v_detalle.subtotal;

    CLOSE v_cursor_detalle;

    -- Cambiar cantidad de 3 a 5 unidades
    PERFORM SV_VENTA.up_detalle(
        986001, 986001, 5
    );

    -- Verificar inventario
    IF (SELECT cantidad_producto FROM productos
        WHERE id = 986001) IS DISTINCT FROM 5 THEN
        RAISE EXCEPTION 'Error al actualizar inventario';
    END IF;

    -- Verificar total
    IF (SELECT total_venta FROM ventas
        WHERE id = 986001) IS DISTINCT FROM 125000 THEN
        RAISE EXCEPTION 'Error al actualizar total';
    END IF;

    RAISE NOTICE 'OK UPDATE: Cantidad actualizada a 5';
    RAISE NOTICE 'Inventario actualizado: 5 unidades';
    RAISE NOTICE 'Total actualizado: 125000';

    -- Intentar vender 11 unidades teniendo solo 10
    BEGIN
        PERFORM SV_VENTA.up_detalle(
            986001, 986001, 11
        );

    EXCEPTION WHEN OTHERS THEN
        IF SQLERRM NOT ILIKE '%existencias insuficientes%' THEN
            RAISE;
        END IF;

        v_rechazado := TRUE;
    END;

    IF NOT v_rechazado THEN
        RAISE EXCEPTION 'Error: permitio venta sin existencias';
    END IF;

    RAISE NOTICE 'OK TRIGGER: Venta sin stock rechazada';

    PERFORM SV_VENTA.de_detalle(
        986001, 986001
    );

    -- Verificar que el detalle fue eliminado
    IF EXISTS (
        SELECT 1 FROM detallesDeVenta
        WHERE id_venta = 986001
          AND id_producto = 986001
    ) THEN
        RAISE EXCEPTION 'Error al eliminar detalle';
    END IF;

    -- Verificar inventario restaurado
    IF (SELECT cantidad_producto FROM productos
        WHERE id = 986001) IS DISTINCT FROM 10 THEN
        RAISE EXCEPTION 'Error al restaurar inventario';
    END IF;

    -- Verificar total en cero
    IF (SELECT total_venta FROM ventas
        WHERE id = 986001) IS DISTINCT FROM 0 THEN
        RAISE EXCEPTION 'Error al actualizar total final';
    END IF;

    RAISE NOTICE 'OK DELETE: Detalle eliminado';
    RAISE NOTICE 'Inventario restaurado: 10 unidades';
    RAISE NOTICE 'Total final: 0';


    PERFORM SV_VENTA.de(986001);

    IF EXISTS (
        SELECT 1 FROM ventas WHERE id = 986001
    ) THEN
        RAISE EXCEPTION 'Error al eliminar venta';
    END IF;

    RAISE NOTICE 'OK DELETE: Venta eliminada';
    RAISE NOTICE 'CRUD DE VENTAS FINALIZADO';

END $$;

-- Deshacer datos de prueba
ROLLBACK;





BEGIN;



-- Crear tecnico
SELECT SV_EMPLEADO.ad_tecnico(
    '9862000001',
    'tecnico986200@correo.com',
    '3109862001',
    'Tecnico Prueba',
    2500000,
    5000,
    1
);

-- Crear cliente
SELECT SV_CLIENTE.ad(
    '9862000002',
    'cliente986200@correo.com',
    '3119862002',
    'Cliente Prueba'
);

-- Crear servicio en el catalogo
SELECT SV_CATALOGO.ad(
    986200,
    'Mantenimiento de computador',
    50000
);



DO $$
DECLARE
    v_cursor REFCURSOR := 'cursor_servicio';
    v_servicio RECORD;
    v_rechazado BOOLEAN;
    v_error TEXT;

BEGIN


    PERFORM SV_SERVICIOTECNICO.ad(
        986200,
        '9862000001',
        '9862000002',
        986200,
        LOCALTIMESTAMP + INTERVAL '3 days'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM serviciosTecnicos
        WHERE id = 986200
          AND id_estado_servicio = 1
          AND id_estado_pago = 2
    ) THEN
        RAISE EXCEPTION 'Error al registrar servicio';
    END IF;

    RAISE NOTICE 'OK CREATE: Servicio creado';
    RAISE NOTICE 'Estado inicial: En proceso';
    RAISE NOTICE 'Estado de pago: No pagado';


    PERFORM SV_SERVICIOTECNICO.co(
        v_cursor, 986200
    );

    FETCH v_cursor INTO v_servicio;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error al consultar servicio';
    END IF;

    IF v_servicio.id IS DISTINCT FROM 986200 THEN
        RAISE EXCEPTION 'Servicio incorrecto';
    END IF;

    RAISE NOTICE 'OK READ: Servicio consultado';
    RAISE NOTICE 'ID: %', v_servicio.id;
    RAISE NOTICE 'Tecnico: %', v_servicio.nombre_tecnico;
    RAISE NOTICE 'Cliente: %', v_servicio.nombre_cliente;
    RAISE NOTICE 'Servicio: %', v_servicio.descripcion_servicio;
    RAISE NOTICE 'Estado: %', v_servicio.nombre_estado;

    CLOSE v_cursor;

    -- Modificar fecha estimada de entrega
    PERFORM SV_SERVICIOTECNICO.up(
        986200,
        '9862000001',
        '9862000002',
        986200,
        LOCALTIMESTAMP + INTERVAL '5 days'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM serviciosTecnicos
        WHERE id = 986200
          AND fecha_estimada_entrega =
              LOCALTIMESTAMP + INTERVAL '5 days'
    ) THEN
        RAISE EXCEPTION 'Error al actualizar servicio';
    END IF;

    RAISE NOTICE 'OK UPDATE: Fecha estimada actualizada';

    -- Actualizar estado de pago
    PERFORM SV_SERVICIOTECNICO.up_pago(
        986200, 1
    );

    IF NOT EXISTS (
        SELECT 1
        FROM serviciosTecnicos
        WHERE id = 986200
          AND id_estado_pago = 1
    ) THEN
        RAISE EXCEPTION 'Error al actualizar pago';
    END IF;

    RAISE NOTICE 'OK UPDATE: Servicio pagado';

    PERFORM SV_SERVICIOTECNICO.de(986200);

    IF EXISTS (
        SELECT 1
        FROM serviciosTecnicos
        WHERE id = 986200
    ) THEN
        RAISE EXCEPTION 'Error al eliminar servicio';
    END IF;

    RAISE NOTICE 'OK DELETE: Servicio eliminado';


    -- Crear otro servicio para probar triggers
    PERFORM SV_SERVICIOTECNICO.ad(
        986201,
        '9862000001',
        '9862000002',
        986200,
        LOCALTIMESTAMP + INTERVAL '3 days'
    );

    v_rechazado := FALSE;

    BEGIN
        -- Intentar entregar sin fecha
        PERFORM SV_SERVICIOTECNICO.up_estado(
            986201, 2
        );

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS v_error = MESSAGE_TEXT;

        IF v_error NOT ILIKE
           '%debe tener fecha de entrega%' THEN
            RAISE;
        END IF;

        v_rechazado := TRUE;
    END;

    IF NOT v_rechazado THEN
        RAISE EXCEPTION
            'Error: permitio entregar sin fecha';
    END IF;

    RAISE NOTICE
        'OK TRIGGER: Entrega sin fecha rechazada';

    -- Entregar correctamente con fecha
    PERFORM SV_SERVICIOTECNICO.up_estado(
        986201,
        2,
        LOCALTIMESTAMP + INTERVAL '1 day'
    );

    IF NOT EXISTS (
        SELECT 1
        FROM serviciosTecnicos
        WHERE id = 986201
          AND id_estado_servicio = 2
          AND fecha_entrega IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Error al entregar servicio';
    END IF;

    RAISE NOTICE
        'OK TRIGGER: Servicio entregado con fecha';

    v_rechazado := FALSE;

    BEGIN
        PERFORM SV_SERVICIOTECNICO.de(986201);

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS v_error = MESSAGE_TEXT;

        IF v_error NOT ILIKE
           '%no se puede eliminar un servicio en estado entregado%' THEN
            RAISE;
        END IF;

        v_rechazado := TRUE;
    END;

    IF NOT v_rechazado THEN
        RAISE EXCEPTION
            'Error: permitio eliminar servicio entregado';
    END IF;

    RAISE NOTICE
        'OK TRIGGER: Eliminacion rechazada';

    RAISE NOTICE
        'CRUD SERVICIO TECNICO FINALIZADO';

END $$;

-- Deshacer los registros de prueba
ROLLBACK;
