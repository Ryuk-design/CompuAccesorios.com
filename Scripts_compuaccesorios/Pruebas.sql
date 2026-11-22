
-- HISTORIA 1. VENTA DE UN SSD
-- Integrante: Andrés Felipe Rubio Galeano
-- ==========================================================
-- Un cliente compra un SSD. Después pide una segunda unidad,
-- pero cambia de opinión y se queda con la compra original.

BEGIN;

-- Preparamos un SSD de $180.000 con 6 unidades disponibles.
-- El 1 corresponde a la categoría, proveedor e inventario
-- que ya existen en los datos iniciales del proyecto.

SELECT SV_ADMINISTRADOR.ad_producto(
    987701, 'SSD de prueba', 180000, 6, 1, 1, 1
);

SELECT SV_ADMINISTRADOR.ad_vendedor(
    '9877000001', 'ventas9877@example.com', '3119877001',
    'Vendedor Prueba', 2000000, 3000
);

SELECT SV_VENDEDOR.ad_cliente(
    '9877000003', 'cliente9877@example.com',
    '3119877003', 'Cliente Prueba'
);

-- Registramos la venta de un SSD y la confirmamos.
SELECT SV_VENDEDOR.ad_venta(
    987701, '9877000003', '9877000001'
);

SELECT SV_VENDEDOR.ad_detalle_venta(987701, 987701, 1);

COMMIT;

-- El cliente pide una segunda unidad.
BEGIN;

SELECT SV_VENDEDOR.up_detalle_venta(987701, 987701, 2);

-- Antes del ROLLBACK deben aparecer 2 SSD, $360.000 y 4 disponibles.
SELECT d.cantidad AS unidades_vendidas,
       v.total_venta,
       p.cantidad_producto AS stock
FROM ventas v
JOIN detallesDeVenta d ON d.id_venta = v.id
JOIN productos p ON p.id = d.id_producto
WHERE v.id = 987701 AND p.id = 987701;

-- El cliente desiste de la segunda unidad.
ROLLBACK;

-- Verificamos que se recuperaron el detalle, el total y el stock.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM ventas v
        JOIN detallesDeVenta d ON d.id_venta = v.id
        JOIN productos p ON p.id = d.id_producto
        WHERE v.id = 987701
          AND p.id = 987701
          AND d.cantidad = 1
          AND v.total_venta = 180000
          AND p.cantidad_producto = 5
    ) THEN
        RAISE EXCEPTION 'Historia 1: la venta o el inventario quedaron incorrectos.';
    END IF;

    RAISE NOTICE 'OK historia 1: venta confirmada por $180.000. Quedan 5 SSD.';
END $$;


-- ==========================================================
-- HISTORIA 2. INSTALACIÓN DEL SSD PARA EL MISMO CLIENTE
-- Integrante: Samuel Ahumada Flores
-- ==========================================================
-- El comprador pide instalar el SSD. El técnico marca el pago
-- y la entrega por error, los revierte y después registra
-- la entrega real cuando el cliente recoge el equipo.

BEGIN;

-- Registramos al técnico y el servicio que ofrece.
SELECT SV_ADMINISTRADOR.ad_tecnico(
    '9877000002', 'soporte9877@example.com', '3119877002',
    'Tecnico Prueba', 2500000, 5000, 1
);

SELECT SV_ADMINISTRADOR.ad_catalogo(
    987702, 'Instalación de SSD de prueba', 50000
);

-- Tomamos la cédula directamente de la venta de la historia 1.
SELECT SV_TECNICO.ad_servicio_tecnico(
    987702,
    '9877000002',
    (SELECT cedula_cliente FROM ventas WHERE id = 987701),
    987702,
    LOCALTIMESTAMP + INTERVAL '1 day'
);

-- La solicitud queda guardada en proceso y sin pagar.
COMMIT;

-- El técnico registra por error el pago y la entrega anticipada.
BEGIN;

SELECT SV_TECNICO.up_pago_servicio_tecnico(987702, 1);
SELECT SV_TECNICO.up_estado_servicio_tecnico(
    987702, 2, LOCALTIMESTAMP
);

-- Antes del ROLLBACK se ve Entregado, Pagado y una fecha de entrega.
SELECT e.nombre_estado AS estado_servicio,
       p.nombre_estado_pago AS estado_pago,
       s.fecha_entrega
FROM serviciosTecnicos s
JOIN estadosDeServicios e ON e.id = s.id_estado_servicio
JOIN estadosDePago p ON p.id = s.id_estado_pago
WHERE s.id = 987702;

-- Se deshacen juntos el pago y la entrega anticipada.
ROLLBACK;

-- Verificamos que la solicitud sigue existiendo y está pendiente.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM serviciosTecnicos
        WHERE id = 987702
          AND id_estado_servicio = 1  -- En proceso
          AND id_estado_pago = 2      -- No pagado
          AND fecha_entrega IS NULL
    ) THEN
        RAISE EXCEPTION 'Historia 2: el pago o la entrega no se revirtieron.';
    END IF;

    RAISE NOTICE 'ROLLBACK correcto: servicio en proceso, sin pagar y sin fecha de entrega.';
END $$;

-- Ahora sí llega el cliente, paga y recibe su equipo.
BEGIN;

SELECT SV_TECNICO.up_pago_servicio_tecnico(987702, 1);
SELECT SV_TECNICO.up_estado_servicio_tecnico(
    987702, 2, LOCALTIMESTAMP
);

COMMIT;

-- Comprobamos que el pago y la entrega quedaron guardados.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM serviciosTecnicos
        WHERE id = 987702
          AND cedula_cliente = (SELECT cedula_cliente FROM ventas WHERE id = 987701)
          AND id_estado_servicio = 2  -- Entregado
          AND id_estado_pago = 1      -- Pagado
          AND fecha_entrega IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Historia 2: el pago o la entrega final quedaron incorrectos.';
    END IF;

    RAISE NOTICE 'OK historia 2: instalación pagada y entregada al comprador del SSD.';
END $$;

-- RESULTADO FINAL
SELECT v.id AS venta,
       v.cedula_cliente AS cliente,
       v.total_venta,
       p.cantidad_producto AS stock_final,
       s.id AS instalacion,
       e.nombre_estado AS estado_servicio,
       ep.nombre_estado_pago AS estado_pago
FROM ventas v
JOIN detallesDeVenta d ON d.id_venta = v.id
JOIN productos p ON p.id = d.id_producto
JOIN serviciosTecnicos s ON s.cedula_cliente = v.cedula_cliente
JOIN estadosDeServicios e ON e.id = s.id_estado_servicio
JOIN estadosDePago ep ON ep.id = s.id_estado_pago
WHERE v.id = 987701 AND p.id = 987701 AND s.id = 987702;