BEGIN;

-- PREPARACION
-- Datos de referencia (el poblar ya los tiene, por eso ON CONFLICT DO NOTHING)
INSERT INTO especializaciones (id, especializacion) VALUES (5, 'Redes y Conectividad') ON CONFLICT DO NOTHING;
INSERT INTO estadosDeServicios (id, nombre_estado) VALUES (1, 'En proceso'), (2, 'Entregado') ON CONFLICT DO NOTHING;
INSERT INTO estadosDePago (id, nombre_estado_pago) VALUES (1, 'Pagado'), (2, 'No pagado') ON CONFLICT DO NOTHING;

SELECT SV_CATEGORIA.ad(986001, 'Accesorios Prueba', 'Categoria de prueba');
SELECT SV_INVENTARIO.ad(986001, 'Inventario de prueba');
SELECT SV_PROVEEDOR.ad(986001, '3109860001', 'proveedor986001@correo.com', 'Proveedor Prueba');

-- Tres productos con 10 unidades cada uno
SELECT SV_PRODUCTO.ad(986001, 'Teclado Prueba', 25000, 10, 986001, 986001, 986001);
SELECT SV_PRODUCTO.ad(986002, 'Mouse Prueba',   15000, 10, 986001, 986001, 986001);
SELECT SV_PRODUCTO.ad(986003, 'Cable Prueba',   10000, 10, 986001, 986001, 986001);

SELECT SV_EMPLEADO.ad_vendedor('9860000001', 'vendedor986001@correo.com', '3119860001', 'Vendedor Prueba', 2000000, 3000);
SELECT SV_EMPLEADO.ad_tecnico('9862000001', 'tecnico986200@correo.com', '3109862001', 'Tecnico Prueba', 2500000, 5000, 5);
SELECT SV_CLIENTE.ad('9860000002', 'cliente986002@correo.com', '3129860002', 'Cliente Prueba');
SELECT SV_CATALOGO.ad(986200, 'Mantenimiento de computador', 50000);


DO $$
DECLARE
    v_p1 INT;
    v_p2 INT;
BEGIN

    -- 1. VENTA CON VARIOS PRODUCTOS
    -- Triggers: existencias (descuenta / devuelve), total de la venta (recalcula)
    -- y validacion de stock (permite vender justo lo disponible)
    PERFORM SV_VENTA.ad(986001, '9860000002', '9860000001');

    PERFORM SV_VENTA.ad_detalle(986001, 986001, 3);
    PERFORM SV_VENTA.ad_detalle(986001, 986002, 4);

    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986001) = 7,
        'Agregar detalle: el producto 1 debia quedar en 7';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986002) = 6,
        'Agregar detalle: el producto 2 debia quedar en 6';
    ASSERT (SELECT total_venta FROM ventas WHERE id = 986001) = 135000,
        'Agregar detalle: el total debia ser 3*25000 + 4*15000 = 135000';

    PERFORM SV_VENTA.up_detalle(986001, 986001, 5);
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986001) = 5,
        'Subir cantidad: el producto 1 debia quedar en 5';
    ASSERT (SELECT total_venta FROM ventas WHERE id = 986001) = 185000,
        'Subir cantidad: el total debia ser 5*25000 + 60000 = 185000';

    -- Limite: vender las 10 unidades del producto (3 de las cuales ya estaban en esta venta)
    PERFORM SV_VENTA.up_detalle(986001, 986001, 10);
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986001) = 0,
        'Limite: vender las 10 unidades debia dejar el producto en 0';
    ASSERT (SELECT total_venta FROM ventas WHERE id = 986001) = 310000,
        'Limite: el total debia ser 10*25000 + 60000 = 310000';

    PERFORM SV_VENTA.up_detalle(986001, 986001, 2);
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986001) = 8,
        'Bajar cantidad: las unidades sobrantes debian volver al producto 1 (8)';

    PERFORM SV_VENTA.de_detalle(986001, 986002);
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986002) = 10,
        'Quitar detalle: el producto 2 debia volver a 10';
    ASSERT (SELECT total_venta FROM ventas WHERE id = 986001) = 50000,
        'Quitar detalle: el total debia quedar en 2*25000 = 50000';

    RAISE NOTICE 'OK [1] Venta con varios productos: existencias y total siempre coherentes';


    -- 2. DOS VENTAS QUE COMPARTEN EL MISMO PRODUCTO
    -- Trigger de validacion: el stock disponible es el de todas las ventas, no el de una sola
    PERFORM SV_VENTA.ad(986002, '9860000002', '9860000001');
    PERFORM SV_VENTA.ad(986003, '9860000002', '9860000001');

    PERFORM SV_VENTA.ad_detalle(986002, 986003, 4);
    PERFORM SV_VENTA.ad_detalle(986003, 986003, 6);      -- justo las 6 que quedaban
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986003) = 0,
        'Dos ventas: el producto 3 debia quedar en 0';

    PERFORM SV_VENTA.de_detalle(986002, 986003);
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986003) = 4,
        'Dos ventas: al quitar las 4 de la primera venta, el producto 3 debia quedar en 4';

    RAISE NOTICE 'OK [2] Dos ventas comparten stock: el limite se calcula sobre el total';


    -- 3. ANULAR UNA VENTA CON DETALLES
    -- La eliminacion borra el detalle en cascada y el trigger devuelve las existencias
    SELECT cantidad_producto INTO v_p1 FROM productos WHERE id = 986001;
    SELECT cantidad_producto INTO v_p2 FROM productos WHERE id = 986002;

    PERFORM SV_VENTA.ad(986004, '9860000002', '9860000001');
    PERFORM SV_VENTA.ad_detalle(986004, 986001, 2);
    PERFORM SV_VENTA.ad_detalle(986004, 986002, 3);

    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986001) = v_p1 - 2,
        'Anular venta: el producto 1 debia bajar 2 antes de anular';

    PERFORM SV_VENTA.de(986004);

    ASSERT NOT EXISTS (SELECT 1 FROM detallesDeVenta WHERE id_venta = 986004),
        'Anular venta: el detalle debia eliminarse en cascada';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986001) = v_p1,
        'Anular venta: el producto 1 debia volver a su cantidad inicial';
    ASSERT (SELECT cantidad_producto FROM productos WHERE id = 986002) = v_p2,
        'Anular venta: el producto 2 debia volver a su cantidad inicial';

    RAISE NOTICE 'OK [3] Anular venta: el detalle se elimina y el stock se devuelve';


    -- 4. SERVICIO TECNICO ENTREGADO
    -- Trigger: un servicio Entregado exige fecha de entrega (aqui se envia y se acepta)
    PERFORM SV_SERVICIOTECNICO.ad(986200, '9862000001', '9860000002', 986200,
                                  LOCALTIMESTAMP + INTERVAL '3 days');

    ASSERT (SELECT id_estado_servicio FROM serviciosTecnicos WHERE id = 986200) = 1
       AND (SELECT id_estado_pago FROM serviciosTecnicos WHERE id = 986200) = 2,
        'Servicio nuevo: debia quedar En proceso y No pagado por defecto';

    PERFORM SV_SERVICIOTECNICO.up_estado(986200, 2, LOCALTIMESTAMP + INTERVAL '1 day');

    ASSERT EXISTS (SELECT 1 FROM serviciosTecnicos
                   WHERE id = 986200 AND id_estado_servicio = 2 AND fecha_entrega IS NOT NULL),
        'Servicio entregado: debia quedar en estado 2 con fecha de entrega';

    RAISE NOTICE 'OK [4] Servicio entregado con fecha de entrega';


    -- 5. ELIMINAR UN SERVICIO QUE NO ESTA ENTREGADO
    -- Trigger: solo se bloquea la eliminacion de los Entregados
    PERFORM SV_SERVICIOTECNICO.ad(986201, '9862000001', '9860000002', 986200,
                                  LOCALTIMESTAMP + INTERVAL '3 days');
    PERFORM SV_SERVICIOTECNICO.de(986201);

    ASSERT NOT EXISTS (SELECT 1 FROM serviciosTecnicos WHERE id = 986201),
        'Servicio En proceso: debia poder eliminarse';
    ASSERT EXISTS (SELECT 1 FROM serviciosTecnicos WHERE id = 986200),
        'Servicio Entregado: debia seguir existiendo';

    RAISE NOTICE 'OK [5] Se elimina un servicio En proceso y el Entregado se conserva';


    -- 6. TECNICO Y VENDEDOR
    -- Triggers: un empleado no puede ser tecnico y vendedor a la vez
    -- (aqui, dos empleados distintos se registran y se modifican sin problema)
    PERFORM SV_EMPLEADO.ad_tecnico('9863000001', 'tecnico986300@correo.com', '3109863001',
                                   'Tecnico Dos', 2500000, 5000, 5);
    PERFORM SV_EMPLEADO.ad_vendedor('9863000002', 'vendedor986300@correo.com', '3119863002',
                                    'Vendedor Dos', 2000000, 3000);

    PERFORM SV_EMPLEADO.up_tecnico('9863000001', 7000, 5);
    PERFORM SV_EMPLEADO.up_vendedor('9863000002', 4500);

    ASSERT (SELECT comision_servicio FROM tecnicos WHERE cedula_tecnico = '9863000001') = 7000,
        'Tecnico: la comision debia quedar en 7000';
    ASSERT (SELECT comision_venta FROM vendedores WHERE cedula_vendedor = '9863000002') = 4500,
        'Vendedor: la comision debia quedar en 4500';

    RAISE NOTICE 'OK [6] Tecnico y vendedor se registran y modifican';


    -- 7. MODIFICAR DATOS DE UNA PERSONA
    -- Trigger: la cedula no se puede modificar (aqui se cambian los demas datos)
    PERFORM SV_CLIENTE.up('9860000002', 'cliente986002@correo.com', '3129860099', 'Cliente Modificado');
    PERFORM SV_EMPLEADO.up('9860000001', 'vendedor986001@correo.com', '3119860099',
                           'Vendedor Modificado', 2200000, TRUE);

    ASSERT (SELECT nombre FROM personas WHERE cedula = '9860000002') = 'Cliente Modificado',
        'Cliente: el nombre debia cambiar';
    ASSERT (SELECT telefono FROM personas WHERE cedula = '9860000001') = '3119860099',
        'Empleado: el telefono debia cambiar';

    RAISE NOTICE 'OK [7] Se modifican los datos de la persona sin tocar la cedula';

    RAISE NOTICE 'PRUEBAS OK DE COMPONENTES Y TRIGGERS FINALIZADAS';

END $$;


ROLLBACK;