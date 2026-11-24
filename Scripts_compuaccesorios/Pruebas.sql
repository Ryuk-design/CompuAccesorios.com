
-- HISTORIA 1: "EL PORTATIL QUE NO ENCENDIA"
-- Servicios tecnicos. Personajes: Don Ricardo (administrador), Julian
-- (tecnico) y Mariana (clienta).
-- LIMPIEZA PREVIA (deja la base lista para empezar la historia)


-- CAPITULO 1: El nuevo tecnico
-- Don Ricardo, el administrador, crea el servicio "Diagnostico y
-- mantenimiento de portatil" en el catalogo y contrata a Julian,
-- especialista en hardware.

BEGIN;

-- La tienda ya tiene sus estados de servicio y de pago
INSERT INTO estadosDeServicios (id, nombre_estado)
    VALUES (1, 'En proceso'), (2, 'Entregado');

INSERT INTO estadosDePago (id, nombre_estado_pago)
    VALUES (1, 'Pagado'), (2, 'No pagado');

INSERT INTO especializaciones (id, especializacion)
SELECT 972001, 'Mantenimiento de Hardware'
WHERE NOT EXISTS (SELECT 1 FROM especializaciones WHERE especializacion = 'Mantenimiento de Hardware');

DO $$
DECLARE
    v_esp INT;
BEGIN
    SELECT id INTO v_esp
        FROM especializaciones
        WHERE especializacion = 'Mantenimiento de Hardware';

    SET LOCAL ROLE rol_administrador;
    PERFORM SV_ADMINISTRADOR.ad_catalogo(972001, 'Diagnostico y mantenimiento de portatil', 70000);
    PERFORM SV_ADMINISTRADOR.ad_tecnico('9720000001', 'julian.ospina@tienda.com', '3119720001', 'Julian Ospina', 2500000, 8000, v_esp);
    RESET ROLE;
END $$;

COMMIT;

-- Verificacion
SELECT e.cedula_empleado, p.nombre, t.comision_servicio, es.especializacion
FROM empleados e
JOIN personas p ON p.cedula = e.cedula_empleado
JOIN tecnicos t ON t.cedula_tecnico = e.cedula_empleado
JOIN especializaciones es ON es.id = t.id_especializacion
WHERE e.cedula_empleado = '9720000001';

DO $$
BEGIN
    ASSERT EXISTS (SELECT 1 FROM tecnicos WHERE cedula_tecnico = '9720000001'),
        'Capitulo 1: Julian debia quedar registrado como tecnico';
    ASSERT EXISTS (SELECT 1 FROM catalogoDeServicios WHERE id = 972001),
        'Capitulo 1: el servicio debia quedar en el catalogo';
    RAISE NOTICE 'OK Capitulo 1: Julian entra al equipo como tecnico de hardware.';
END $$;



-- CAPITULO 2: Se fue la luz y un portatil apagado
-- Mariana llega con su portatil: se apago solo cuando se fue la luz y no
-- volvio a encender. Julian la registra como clienta y abre el servicio,
-- prometiendo la entrega en tres dias.
BEGIN;

SET LOCAL ROLE rol_tecnico;
SELECT SV_TECNICO.ad_cliente('9720000002', 'mariana.quintero@correo.com', '3129720002', 'Mariana Quintero');
SELECT SV_TECNICO.ad_servicio_tecnico(972001, '9720000001', '9720000002', 972001, LOCALTIMESTAMP + INTERVAL '3 days');
RESET ROLE;

COMMIT;

-- Verificacion
SELECT s.id, es.nombre_estado AS estado, ep.nombre_estado_pago AS pago, s.fecha_estimada_entrega
FROM serviciosTecnicos s
JOIN estadosDeServicios es ON es.id = s.id_estado_servicio
JOIN estadosDePago ep ON ep.id = s.id_estado_pago
WHERE s.id = 972001;

DO $$
BEGIN
    ASSERT (SELECT id_estado_servicio FROM serviciosTecnicos WHERE id = 972001) = 1,
        'Capitulo 2: el servicio debia nacer En proceso';
    ASSERT (SELECT id_estado_pago FROM serviciosTecnicos WHERE id = 972001) = 2,
        'Capitulo 2: el servicio debia nacer No pagado';
    RAISE NOTICE 'OK Capitulo 2: servicio abierto. Estado: En proceso. Pago: No pagado.';
END $$;



-- CAPITULO 3: La llamada impaciente
-- Mariana llama dos veces. Julian, apurado por contestarle, marca el
-- servicio como Entregado sin escribir la fecha de entrega y el sistema
-- no se lo permite
DO $$
DECLARE
    v_mensaje VARCHAR(300) := NULL;
BEGIN
    BEGIN
        SET LOCAL ROLE rol_tecnico;
        PERFORM SV_TECNICO.up_estado_servicio_tecnico(972001, 2);
    EXCEPTION WHEN OTHERS THEN
        v_mensaje := SQLERRM;
    END;
    RESET ROLE;

    ASSERT v_mensaje LIKE '%debe tener fecha de entrega%',
        'Capitulo 3: no debia permitirse entregar sin fecha';
    ASSERT (SELECT id_estado_servicio FROM serviciosTecnicos WHERE id = 972001) = 1,
        'Capitulo 3: el servicio debia seguir En proceso';
    RAISE NOTICE 'OK Capitulo 3: el sistema se nego: "%"', v_mensaje;
END $$;



-- CAPITULO 4: El diagnostico
-- Era el cargador y el polvo acumulado. Julian limpia el equipo, lo
-- prueba y esta vez si registra la entrega con su fecha. Mariana paga
-- en el mostrador.
BEGIN;

SET LOCAL ROLE rol_tecnico;
SELECT SV_TECNICO.up_estado_servicio_tecnico(972001, 2, LOCALTIMESTAMP + INTERVAL '2 days');
SELECT SV_TECNICO.up_pago_servicio_tecnico(972001, 1);
RESET ROLE;

COMMIT;

-- Verificacion
SELECT s.id, es.nombre_estado AS estado, ep.nombre_estado_pago AS pago, s.fecha_entrega
FROM serviciosTecnicos s
JOIN estadosDeServicios es ON es.id = s.id_estado_servicio
JOIN estadosDePago ep ON ep.id = s.id_estado_pago
WHERE s.id = 972001;

DO $$
BEGIN
    ASSERT EXISTS (SELECT 1 FROM serviciosTecnicos
                   WHERE id = 972001 AND id_estado_servicio = 2
                     AND fecha_entrega IS NOT NULL AND id_estado_pago = 1),
        'Capitulo 4: el servicio debia quedar Entregado, con fecha y Pagado';
    RAISE NOTICE 'OK Capitulo 4: portatil entregado antes de lo prometido y pagado.';
END $$;



-- CAPITULO 5: Un registro de mas
-- Esa tarde Julian descubre que, por error, abrio un segundo servicio
-- para Mariana. Como aun esta En proceso, puede borrarlo sin problema.

BEGIN;
SET LOCAL ROLE rol_tecnico;
SELECT SV_TECNICO.ad_servicio_tecnico(972002, '9720000001', '9720000002', 972001, LOCALTIMESTAMP + INTERVAL '3 days');
RESET ROLE;
COMMIT;

SELECT id, id_estado_servicio FROM serviciosTecnicos WHERE id IN (972001, 972002) ORDER BY id;   -- esperado: 2 filas

BEGIN;
SET LOCAL ROLE rol_tecnico;
SELECT SV_TECNICO.de_servicio_tecnico(972002);
RESET ROLE;
COMMIT;

SELECT id, id_estado_servicio FROM serviciosTecnicos WHERE id IN (972001, 972002) ORDER BY id;   -- esperado: solo 972001

DO $$
BEGIN
    ASSERT NOT EXISTS (SELECT 1 FROM serviciosTecnicos WHERE id = 972002),
        'Capitulo 5: el servicio duplicado debia poder borrarse';
    RAISE NOTICE 'OK Capitulo 5: el servicio duplicado se borro sin problema.';
END $$;

-- Pero cuando intenta "limpiar" tambien el servicio ya entregado, el
-- historial queda protegido.
DO $$
DECLARE
    v_mensaje VARCHAR(300) := NULL;
BEGIN
    BEGIN
        SET LOCAL ROLE rol_tecnico;
        PERFORM SV_TECNICO.de_servicio_tecnico(972001);
    EXCEPTION WHEN OTHERS THEN
        v_mensaje := SQLERRM;
    END;
    RESET ROLE;

    ASSERT v_mensaje LIKE '%No se puede eliminar un servicio en estado Entregado%',
        'Capitulo 5: no debia poder borrarse un servicio entregado';
    ASSERT EXISTS (SELECT 1 FROM serviciosTecnicos WHERE id = 972001),
        'Capitulo 5: el servicio entregado debia seguir existiendo';
    RAISE NOTICE 'OK Capitulo 5: el sistema protegio el historial: "%"', v_mensaje;
END $$;



-- CAPITULO 6: Julian quiere turnos extra
-- Julian le pide a Don Ricardo trabajar los sabados como vendedor. Pero
-- en la tienda un empleado es tecnico o vendedor, nunca las dos cosas.
DO $$
DECLARE
    v_mensaje VARCHAR(300) := NULL;
BEGIN
    BEGIN
        SET LOCAL ROLE rol_administrador;
        PERFORM SV_ADMINISTRADOR.ad_vendedor('9720000001', 'julian.sabados@tienda.com', '3119720009', 'Julian Ospina', 1800000, 2500);
    EXCEPTION WHEN OTHERS THEN
        v_mensaje := SQLERRM;
    END;
    RESET ROLE;

    ASSERT v_mensaje LIKE '%9720000001 ya esta registrado%',
        'Capitulo 6: un tecnico no debia poder registrarse tambien como vendedor';
    ASSERT NOT EXISTS (SELECT 1 FROM vendedores WHERE cedula_vendedor = '9720000001'),
        'Capitulo 6: Julian no debia quedar como vendedor';
    RAISE NOTICE 'OK Capitulo 6: el sistema le respondio a Don Ricardo: "%"', v_mensaje;
END $$;


-- Y si Julian, por su cuenta, intenta cobrar una venta en el mostrador,
-- su rol de tecnico no le abre esa puerta.
DO $$
DECLARE
    v_denegado BOOLEAN := FALSE;
    v_mensaje  VARCHAR(300) := NULL;
BEGIN
    BEGIN
        SET LOCAL ROLE rol_tecnico;
        PERFORM SV_VENDEDOR.ad_venta(972001, '9720000002', '9720000001');
    EXCEPTION WHEN insufficient_privilege THEN
        v_denegado := TRUE;
        v_mensaje := SQLERRM;
    END;
    RESET ROLE;

    ASSERT v_denegado, 'Capitulo 6: un tecnico no debia poder registrar ventas';
    ASSERT NOT EXISTS (SELECT 1 FROM ventas WHERE id = 972001),
        'Capitulo 6: no debia quedar ninguna venta';
    RAISE NOTICE 'OK Capitulo 6: tampoco puede vender: "%"', v_mensaje;
END $$;



-- CAPITULO 7: El historial de Julian
-- Al cerrar la semana, Julian revisa a quienes ha atendido. Mariana
-- aparece con un unico servicio, el que quedo Entregado y Pagado.

SELECT nombre_cliente, servicios_realizados
FROM vw_clientes_atendidos_por_tecnico
WHERE cedula_tecnico = '9720000001';

SELECT id_servicio, nombre_cliente, nombre_estado
FROM vw_servicios_por_tecnico
WHERE cedula_tecnico = '9720000001';

DO $$
BEGIN
    ASSERT (SELECT COUNT(*) FROM vw_clientes_atendidos_por_tecnico
            WHERE cedula_tecnico = '9720000001') = 1,
        'Capitulo 7: Julian debia tener un solo cliente atendido';
    ASSERT (SELECT servicios_realizados FROM vw_clientes_atendidos_por_tecnico
            WHERE cedula_tecnico = '9720000001' AND cedula_cliente = '9720000002') = 1,
        'Capitulo 7: Mariana debia figurar con 1 servicio realizado';
    ASSERT (SELECT nombre_estado FROM vw_servicios_por_tecnico
            WHERE cedula_tecnico = '9720000001') = 'Entregado',
        'Capitulo 7: el unico servicio de Julian debia figurar Entregado';
    ASSERT (SELECT id_estado_pago FROM serviciosTecnicos WHERE id = 972001) = 1,
        'Capitulo 7: el servicio debia figurar Pagado';
    RAISE NOTICE 'OK Capitulo 7: Julian atendio a 1 clienta y su unico servicio esta Entregado y Pagado.';
    RAISE NOTICE 'FIN DE LA HISTORIA 1';
END $$;




-- HISTORIA 2: "ORDEN DE COMPRA CORPORATIVA"
-- Ventas e inventario. La firma Contadores Asociados dota dos puestos de
-- trabajo nuevos. Personajes: Ricardo Mendoza (administrador), Camila
-- Rojas (asesora comercial, rol vendedor), Sergio Navarro (jefe de
-- compras de la firma, cliente) y Laura Prieto (gerente).


-- CAPITULO 1: Abastecimiento
-- El administrador, Ricardo Mendoza, registra el lote de equipos de
-- oficina que acaba de recibir: 5 mouse, 3 teclados y 2 diademas.
-- Tambien vincula a Camila Rojas como asesora comercial.
BEGIN;

SET LOCAL ROLE rol_administrador;
SELECT SV_ADMINISTRADOR.ad_categoria(971001, 'Equipos de oficina', 'Perifericos para puestos de trabajo');
SELECT SV_ADMINISTRADOR.ad_inventario(971001, 'Bodega principal');
SELECT SV_ADMINISTRADOR.ad_proveedor(971001, '3109710001', 'ventas@distritech.com', 'Distribuidora Distritech');
SELECT SV_ADMINISTRADOR.ad_producto(971001, 'Mouse inalambrico Oficina', 45000, 5, 971001, 971001, 971001);
SELECT SV_ADMINISTRADOR.ad_producto(971002, 'Teclado compacto Oficina', 120000, 3, 971001, 971001, 971001);
SELECT SV_ADMINISTRADOR.ad_producto(971003, 'Diadema con microfono Oficina', 80000, 2, 971001, 971001, 971001);
SELECT SV_ADMINISTRADOR.ad_vendedor('9710000001', 'camila.rojas@tienda.com', '3119710001', 'Camila Rojas', 2000000, 3000);
RESET ROLE;

COMMIT;

-- Verificacion
SELECT id, nombre_producto, precio_unitario_producto AS precio,
       cantidad_producto AS stock
FROM productos
WHERE id IN (971001, 971002, 971003)
ORDER BY id;

DO $$
BEGIN
    ASSERT (SELECT COUNT(*) FROM productos WHERE id IN (971001, 971002, 971003)) = 3,
        'Capitulo 1: debian registrarse los 3 productos';
    ASSERT EXISTS (SELECT 1 FROM vendedores WHERE cedula_vendedor = '9710000001'),
        'Capitulo 1: Camila debia quedar como vendedora';
    RAISE NOTICE 'OK Capitulo 1: inventario registrado: 5 mouse, 3 teclados y 2 diademas.';
END $$;



-- CAPITULO 2: Apertura del pedido
-- Sergio Navarro solicita equipos para dos puestos de trabajo: dos mouse
-- y un teclado. Camila lo registra como cliente y abre la venta. El
-- sistema calcula el total y descuenta las existencias.

BEGIN;

SET LOCAL ROLE rol_vendedor;
SELECT SV_VENDEDOR.ad_cliente('9710000002', 'sergio.navarro@contadoresasociados.com', '3129710002', 'Sergio Navarro');
SELECT SV_VENDEDOR.ad_venta(971001, '9710000002', '9710000001');
SELECT SV_VENDEDOR.ad_detalle_venta(971001, 971001, 2);
SELECT SV_VENDEDOR.ad_detalle_venta(971001, 971002, 1);
RESET ROLE;

COMMIT;

-- Verificacion
SELECT v.id AS venta,
       v.total_venta,
       p1.cantidad_producto AS mouse,
       p2.cantidad_producto AS teclados
FROM ventas v, productos p1, productos p2
WHERE v.id = 971001 AND p1.id = 971001 AND p2.id = 971002;

DO $$
BEGIN
    ASSERT (SELECT total_venta FROM ventas WHERE id = 971001) = 210000,
        'Capitulo 2: el total debia ser 2*45000 + 120000 = 210000';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 971001) = 3,
        'Capitulo 2: debian quedar 3 mouse';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 971002) = 2,
        'Capitulo 2: debian quedar 2 teclados';
    RAISE NOTICE 'OK Capitulo 2: total calculado automaticamente ($210.000). Existencias: 3 mouse y 2 teclados.';
END $$;



-- CAPITULO 3: Ampliacion del pedido
-- La firma pide tres diademas. En bodega solo hay dos, asi que el
-- sistema rechaza esa cantidad. Camila ajusta el pedido a dos.

DO $$
DECLARE
    v_mensaje VARCHAR(300) := NULL;
BEGIN
    BEGIN
        SET LOCAL ROLE rol_vendedor;
        PERFORM SV_VENDEDOR.ad_detalle_venta(971001, 971003, 3);
    EXCEPTION WHEN OTHERS THEN
        v_mensaje := SQLERRM;
    END;
    RESET ROLE;

    ASSERT v_mensaje LIKE '%Existencias insuficientes del producto 971003%',
        'Capitulo 3: debia rechazarse la venta de 3 diademas teniendo 2';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 971003) = 2,
        'Capitulo 3: el stock de diademas no debia cambiar';
    RAISE NOTICE 'OK Capitulo 3: solicitud rechazada: "%"', v_mensaje;
END $$;

-- El cliente acepta las dos unidades disponibles
BEGIN;
SET LOCAL ROLE rol_vendedor;
SELECT SV_VENDEDOR.ad_detalle_venta(971001, 971003, 2);
RESET ROLE;
COMMIT;

-- Verificacion
SELECT v.total_venta, p.cantidad_producto AS diademas
FROM ventas v, productos p
WHERE v.id = 971001 AND p.id = 971003;   -- esperado: 370000, 0

DO $$
BEGIN
    ASSERT (SELECT total_venta FROM ventas WHERE id = 971001) = 370000,
        'Capitulo 3: el total debia ser 210000 + 2*80000 = 370000';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 971003) = 0,
        'Capitulo 3: las diademas debian quedar agotadas';
    RAISE NOTICE 'OK Capitulo 3: pedido ajustado a 2 diademas. Total: $370.000. Diademas agotadas.';
END $$;


-- ---------------------------------------------------------------------
-- CAPITULO 4: Disponibilidad en catalogo
-- Con las diademas agotadas, el catalogo de productos disponibles que
-- usa el equipo comercial no debe ofrecerlas.
-- ---------------------------------------------------------------------
SELECT id_producto, nombre_producto, existencias
FROM vw_catalogo_productos_disponibles
WHERE id_producto IN (971001, 971002, 971003)
ORDER BY id_producto;   -- esperado: mouse y teclado, sin diademas

DO $$
BEGIN
    ASSERT NOT EXISTS (SELECT 1 FROM vw_catalogo_productos_disponibles WHERE id_producto = 971003),
        'Capitulo 4: las diademas agotadas no debian aparecer en el catalogo';
    ASSERT EXISTS (SELECT 1 FROM vw_catalogo_productos_disponibles WHERE id_producto = 971001),
        'Capitulo 4: el mouse (3 en bodega) si debia seguir en el catalogo';
    RAISE NOTICE 'OK Capitulo 4: las diademas agotadas ya no aparecen en el catalogo de ventas.';
END $$;


-- ---------------------------------------------------------------------
-- CAPITULO 5: Recorte del presupuesto
-- El area financiera pospone la compra del teclado. Camila retira ese
-- producto de la venta.
-- ---------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE rol_vendedor;
SELECT SV_VENDEDOR.de_detalle_venta(971001, 971002);
RESET ROLE;
COMMIT;

-- Verificacion
SELECT v.total_venta, p.cantidad_producto AS teclados
FROM ventas v, productos p
WHERE v.id = 971001 AND p.id = 971002;   -- esperado: 250000, 3

DO $$
BEGIN
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 971002) = 3,
        'Capitulo 5: el teclado debia volver a la bodega (3)';
    ASSERT (SELECT total_venta FROM ventas WHERE id = 971001) = 250000,
        'Capitulo 5: el total debia bajar a 2*45000 + 2*80000 = 250000';
    RAISE NOTICE 'OK Capitulo 5: teclado retirado. Existencias restituidas y total actualizado a $250.000.';
END $$;


-- ---------------------------------------------------------------------
-- CAPITULO 6: Politica de precios
-- Camila intenta aplicar un precio especial modificando el valor del
-- mouse. La politica de precios es exclusiva del administrador: su rol
-- no tiene acceso a esa operacion.
-- ---------------------------------------------------------------------
DO $$
DECLARE
    v_denegado BOOLEAN := FALSE;
    v_mensaje  VARCHAR(300) := NULL;
BEGIN
    BEGIN
        SET LOCAL ROLE rol_vendedor;
        PERFORM SV_ADMINISTRADOR.up_producto(971001, 'Mouse inalambrico Oficina', 1000, 3, 971001, 971001, 971001);
    EXCEPTION WHEN insufficient_privilege THEN
        v_denegado := TRUE;
        v_mensaje := SQLERRM;
    END;
    RESET ROLE;

    ASSERT v_denegado, 'Capitulo 6: la vendedora no debia poder modificar productos';
    ASSERT (SELECT precio_unitario_producto FROM productos WHERE id = 971001) = 45000,
        'Capitulo 6: el precio del mouse no debia cambiar';
    RAISE NOTICE 'OK Capitulo 6: operacion denegada por el rol: "%"', v_mensaje;
END $$;


-- ---------------------------------------------------------------------
-- CAPITULO 7: Reposicion de inventario
-- Laura Prieto, gerente, revisa el reporte de productos con bajo
-- inventario. Las diademas, con stock en cero, deben figurar.
-- ---------------------------------------------------------------------
SELECT id_producto, nombre_producto, stock
FROM vw_productos_bajo_inventario
WHERE id_producto = 971003;   -- esperado: diademas, stock 0

DO $$
BEGIN
    ASSERT EXISTS (SELECT 1 FROM vw_productos_bajo_inventario
                   WHERE id_producto = 971003 AND stock = 0),
        'Capitulo 7: las diademas (stock 0) debian aparecer en bajo inventario';
    RAISE NOTICE 'OK Capitulo 7: el reporte de bajo inventario incluye las diademas (stock 0).';
END $$;


-- ---------------------------------------------------------------------
-- CAPITULO 8: Anulacion de la orden
-- El comite de compras no aprueba la orden. Camila anula la venta
-- completa y el inventario regresa a su estado inicial.
--
-- Primero Camila la anula "a prueba": ve el resultado dentro de la
-- transaccion y luego se arrepiente (ROLLBACK). Despues la anula de verdad.
-- ---------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE rol_vendedor;
SELECT SV_VENDEDOR.de_venta(971001);
RESET ROLE;
SELECT COUNT(*) AS ventas_dentro_de_la_transaccion FROM ventas WHERE id = 971001;   -- esperado: 0
ROLLBACK;

SELECT COUNT(*) AS ventas_despues_del_rollback FROM ventas WHERE id = 971001;        -- esperado: 1

-- Ahora si, la anulacion definitiva
BEGIN;
SET LOCAL ROLE rol_vendedor;
SELECT SV_VENDEDOR.de_venta(971001);
RESET ROLE;
COMMIT;

-- Verificacion
SELECT id, nombre_producto, cantidad_producto AS stock
FROM productos WHERE id IN (971001, 971002, 971003) ORDER BY id;   -- esperado: 5, 3, 2

DO $$
BEGIN
    ASSERT NOT EXISTS (SELECT 1 FROM ventas WHERE id = 971001),
        'Capitulo 8: la venta debia desaparecer';
    ASSERT NOT EXISTS (SELECT 1 FROM detallesDeVenta WHERE id_venta = 971001),
        'Capitulo 8: el detalle debia desaparecer con la venta';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 971001) = 5
       AND (SELECT cantidad_producto FROM productos WHERE id = 971002) = 3
       AND (SELECT cantidad_producto FROM productos WHERE id = 971003) = 2,
        'Capitulo 8: el inventario debia volver a 5 mouse, 3 teclados y 2 diademas';
    RAISE NOTICE 'OK Capitulo 8: venta anulada. Inventario restituido: 5 mouse, 3 teclados y 2 diademas.';
    RAISE NOTICE 'FIN DE LA HISTORIA 2';
END $$;