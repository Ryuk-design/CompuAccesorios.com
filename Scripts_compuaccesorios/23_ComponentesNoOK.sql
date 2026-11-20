-- COMPONENTES NO OK

BEGIN;

-- PREPARACION
-- Datos de referencia (el poblar ya los tiene, por eso ON CONFLICT DO NOTHING)
INSERT INTO especializaciones (id, especializacion) VALUES (5, 'Redes y Conectividad') ON CONFLICT DO NOTHING;
INSERT INTO estadosDeServicios (id, nombre_estado) VALUES (1, 'En proceso'), (2, 'Entregado') ON CONFLICT DO NOTHING;
INSERT INTO estadosDePago (id, nombre_estado_pago) VALUES (1, 'Pagado'), (2, 'No pagado') ON CONFLICT DO NOTHING;

SELECT SV_CATEGORIA.ad(987001, 'Categoria NoOK', 'Categoria de prueba');
SELECT SV_INVENTARIO.ad(987001, 'Inventario NoOK');
SELECT SV_PROVEEDOR.ad(987001, '3109870001', 'proveedor987001@correo.com', 'Proveedor NoOK');

-- Dos productos con 10 unidades cada uno
SELECT SV_PRODUCTO.ad(987001, 'Teclado NoOK', 25000, 10, 987001, 987001, 987001);
SELECT SV_PRODUCTO.ad(987002, 'Mouse NoOK',   15000, 10, 987001, 987001, 987001);

SELECT SV_EMPLEADO.ad_vendedor('9870000001', 'vendedor987001@correo.com', '3119870001', 'Vendedor NoOK', 2000000, 3000);
SELECT SV_EMPLEADO.ad_tecnico('9870000002', 'tecnico987002@correo.com', '3129870002', 'Tecnico NoOK', 2500000, 5000, 5);
SELECT SV_CLIENTE.ad('9870000003', 'cliente987003@correo.com', '3139870003', 'Cliente NoOK');

SELECT SV_CATALOGO.ad(987001, 'Servicio NoOK', 50000);

-- Una venta con 2 unidades del producto 987001 (queda con 8 unidades)
SELECT SV_VENTA.ad(987001, '9870000003', '9870000001');
SELECT SV_VENTA.ad_detalle(987001, 987001, 2);

-- Un servicio en proceso (987001) y uno entregado (987002)
SELECT SV_SERVICIOTECNICO.ad(987001, '9870000002', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days');
SELECT SV_SERVICIOTECNICO.ad(987002, '9870000002', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days');
SELECT SV_SERVICIOTECNICO.up_estado(987002, 2, LOCALTIMESTAMP + INTERVAL '1 day');


-- Funcion auxiliar temporal (desaparece con el ROLLBACK):
-- ejecuta una sentencia y exige que sea rechazada con el SQLSTATE y el mensaje esperados.
CREATE FUNCTION pg_temp.rechazar(p_caso TEXT, p_sql TEXT, p_sqlstate TEXT, p_mensaje TEXT)
    RETURNS void AS $$
DECLARE
    v_sqlstate TEXT;
    v_mensaje  TEXT;
BEGIN
    BEGIN
        EXECUTE p_sql;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS v_sqlstate = RETURNED_SQLSTATE,
                                v_mensaje  = MESSAGE_TEXT;
        IF v_sqlstate <> p_sqlstate OR v_mensaje NOT ILIKE p_mensaje THEN
            RAISE EXCEPTION 'CASO FALLIDO [%]: se esperaba % (%) y llego % (%)',
                p_caso, p_sqlstate, p_mensaje, v_sqlstate, v_mensaje;
        END IF;
        RAISE NOTICE 'OK [%]: rechazado -> %', p_caso, v_mensaje;
        RETURN;
    END;
    RAISE EXCEPTION 'CASO FALLIDO [%]: la operacion fue ACEPTADA y debia ser rechazada', p_caso;
END;
$$ LANGUAGE plpgsql;


DO $do$
BEGIN

    -- VENTAS (SV_VENTA)

    -- Registrar venta con un cliente que no existe
    PERFORM pg_temp.rechazar('venta con cliente inexistente',
        $q$ SELECT SV_VENTA.ad(987010, '9879999999', '9870000001') $q$,
        '23503', '%fk_ventas_clientes%');

    -- Registrar venta con un vendedor que no existe
    PERFORM pg_temp.rechazar('venta con vendedor inexistente',
        $q$ SELECT SV_VENTA.ad(987010, '9870000003', '9879999999') $q$,
        '23503', '%fk_ventas_vendedores%');

    -- Un tecnico (empleado que no es vendedor) intenta registrar una venta
    PERFORM pg_temp.rechazar('venta registrada por un tecnico',
        $q$ SELECT SV_VENTA.ad(987010, '9870000003', '9870000002') $q$,
        '23503', '%fk_ventas_vendedores%');

    -- Registrar una venta con un id que ya existe
    PERFORM pg_temp.rechazar('venta con id repetido',
        $q$ SELECT SV_VENTA.ad(987001, '9870000003', '9870000001') $q$,
        '23505', '%pk_ventas%');

    -- Agregar un producto a una venta que no existe
    PERFORM pg_temp.rechazar('detalle en venta inexistente',
        $q$ SELECT SV_VENTA.ad_detalle(987999, 987002, 1) $q$,
        'P0001', '%La venta 987999 no existe%');

    -- Agregar un producto que no existe
    PERFORM pg_temp.rechazar('detalle con producto inexistente',
        $q$ SELECT SV_VENTA.ad_detalle(987001, 987999, 1) $q$,
        'P0001', '%El producto 987999 no existe%');

    -- Vender 11 unidades de un producto que tiene 10 (trigger de existencias)
    PERFORM pg_temp.rechazar('detalle con existencias insuficientes',
        $q$ SELECT SV_VENTA.ad_detalle(987001, 987002, 11) $q$,
        'P0001', '%Existencias insuficientes del producto 987002: disponibles 10, solicitadas 11%');

    -- Cantidad cero en el detalle
    PERFORM pg_temp.rechazar('detalle con cantidad cero',
        $q$ SELECT SV_VENTA.ad_detalle(987001, 987002, 0) $q$,
        '23514', '%chk_detallesdeventa_cantidad%');

    -- Cantidad negativa en el detalle
    PERFORM pg_temp.rechazar('detalle con cantidad negativa',
        $q$ SELECT SV_VENTA.ad_detalle(987001, 987002, -3) $q$,
        '23514', '%chk_detallesdeventa_cantidad%');

    -- Agregar de nuevo un producto que ya esta en la venta
    PERFORM pg_temp.rechazar('detalle con producto repetido en la venta',
        $q$ SELECT SV_VENTA.ad_detalle(987001, 987001, 1) $q$,
        '23505', '%pk_detallesdeventa%');

    -- Modificar la cantidad de un producto que no esta en la venta
    PERFORM pg_temp.rechazar('modificar detalle inexistente',
        $q$ SELECT SV_VENTA.up_detalle(987001, 987002, 1) $q$,
        'P0001', '%La venta 987001 no tiene el producto 987002%');

    -- Subir la cantidad a 11 teniendo 10 en total (2 ya vendidas + 8 en bodega)
    PERFORM pg_temp.rechazar('modificar detalle sin existencias',
        $q$ SELECT SV_VENTA.up_detalle(987001, 987001, 11) $q$,
        'P0001', '%Existencias insuficientes del producto 987001: disponibles 10, solicitadas 11%');

    -- Modificar la cantidad a cero
    PERFORM pg_temp.rechazar('modificar detalle a cantidad cero',
        $q$ SELECT SV_VENTA.up_detalle(987001, 987001, 0) $q$,
        '23514', '%chk_detallesdeventa_cantidad%');

    -- Quitar un producto que no esta en la venta
    PERFORM pg_temp.rechazar('quitar detalle inexistente',
        $q$ SELECT SV_VENTA.de_detalle(987001, 987002) $q$,
        'P0001', '%La venta 987001 no tiene el producto 987002%');

    -- Eliminar una venta que no existe
    PERFORM pg_temp.rechazar('eliminar venta inexistente',
        $q$ SELECT SV_VENTA.de(987999) $q$,
        'P0001', '%La venta 987999 no existe%');


    -- EMPLEADOS 

    -- Registrar como vendedor a alguien que ya es empleado
    PERFORM pg_temp.rechazar('vendedor ya registrado',
        $q$ SELECT SV_EMPLEADO.ad_vendedor('9870000001', 'otro987@correo.com', '3119870099', 'Vendedor Repetido', 2000000, 3000) $q$,
        'P0001', '%El empleado 9870000001 ya esta registrado%');

    -- Un vendedor intenta registrarse tambien como tecnico
    PERFORM pg_temp.rechazar('vendedor registrado como tecnico',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('9870000001', 'otro988@correo.com', '3119870098', 'Vendedor Tecnico', 2000000, 5000, 5) $q$,
        'P0001', '%El empleado 9870000001 ya esta registrado%');

    -- Un tecnico intenta registrarse tambien como vendedor
    PERFORM pg_temp.rechazar('tecnico registrado como vendedor',
        $q$ SELECT SV_EMPLEADO.ad_vendedor('9870000002', 'otro989@correo.com', '3119870097', 'Tecnico Vendedor', 2000000, 3000) $q$,
        'P0001', '%El empleado 9870000002 ya esta registrado%');

    -- Correo sin arroba (dominio TEmail)
    PERFORM pg_temp.rechazar('empleado con correo invalido',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'correo-sin-arroba', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 5) $q$,
        '23514', '%chk_emails%');

    -- Telefono con menos de 10 digitos (dominio TTelefono)
    PERFORM pg_temp.rechazar('empleado con telefono invalido',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '31098', 'Tecnico Nuevo', 2000000, 5000, 5) $q$,
        '23514', '%chk_telefonos%');

    -- Nombre con numeros (dominio TNombre)
    PERFORM pg_temp.rechazar('empleado con nombre invalido',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico 123', 2000000, 5000, 5) $q$,
        '23514', '%chk_nombres%');

    -- Cedula con letras
    PERFORM pg_temp.rechazar('empleado con cedula con letras',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('98ABC00010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 5) $q$,
        '23514', '%chk_personas_cedula%');

    -- Cedula de 11 digitos
    PERFORM pg_temp.rechazar('empleado con cedula demasiado larga',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('98700000100', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 5) $q$,
        '22001', '%too long%');

    -- Correo que ya pertenece a otra persona
    PERFORM pg_temp.rechazar('empleado con correo repetido',
        $q$ SELECT SV_EMPLEADO.ad_vendedor('9870000011', 'vendedor987001@correo.com', '3109870011', 'Vendedor Nuevo', 2000000, 3000) $q$,
        '23505', '%uk_personas_email%');

    -- Salario cero
    PERFORM pg_temp.rechazar('empleado con salario cero',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 0, 5000, 5) $q$,
        '23514', '%chk_empleados_salario%');

    -- Comision de servicio cero
    PERFORM pg_temp.rechazar('tecnico con comision cero',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 0, 5) $q$,
        '23514', '%chk_tecnicos_comision%');

    -- Comision de venta cero
    PERFORM pg_temp.rechazar('vendedor con comision cero',
        $q$ SELECT SV_EMPLEADO.ad_vendedor('9870000011', 'nuevo987011@correo.com', '3109870011', 'Vendedor Nuevo', 2000000, 0) $q$,
        '23514', '%chk_vendedores_comision%');

    -- Especializacion que no existe
    PERFORM pg_temp.rechazar('tecnico con especializacion inexistente',
        $q$ SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 987999) $q$,
        '23503', '%fk_tecnicos_especializaciones%');

    -- Modificar un empleado que no existe
    PERFORM pg_temp.rechazar('modificar empleado inexistente',
        $q$ SELECT SV_EMPLEADO.up('9879999999', 'x987999@correo.com', '3109879999', 'Nadie Existe', 2000000, TRUE) $q$,
        'P0001', '%El empleado 9879999999 no existe%');

    -- Modificar como tecnico a alguien que es vendedor
    PERFORM pg_temp.rechazar('modificar como tecnico a un vendedor',
        $q$ SELECT SV_EMPLEADO.up_tecnico('9870000001', 6000, 5) $q$,
        'P0001', '%El tecnico 9870000001 no existe%');

    -- Modificar como vendedor a alguien que es tecnico
    PERFORM pg_temp.rechazar('modificar como vendedor a un tecnico',
        $q$ SELECT SV_EMPLEADO.up_vendedor('9870000002', 4000) $q$,
        'P0001', '%El vendedor 9870000002 no existe%');

    -- Eliminar un empleado que no existe
    PERFORM pg_temp.rechazar('eliminar empleado inexistente',
        $q$ SELECT SV_EMPLEADO.de('9879999999') $q$,
        'P0001', '%El empleado 9879999999 no existe%');

    -- Eliminar un vendedor que ya tiene ventas
    PERFORM pg_temp.rechazar('eliminar vendedor con ventas',
        $q$ SELECT SV_EMPLEADO.de('9870000001') $q$,
        '23503', '%No se puede eliminar el empleado 9870000001%');

    -- Eliminar un tecnico que ya tiene servicios
    PERFORM pg_temp.rechazar('eliminar tecnico con servicios',
        $q$ SELECT SV_EMPLEADO.de('9870000002') $q$,
        '23503', '%No se puede eliminar el empleado 9870000002%');


    -- CLIENTES 

    -- Registrar un cliente que ya existe
    PERFORM pg_temp.rechazar('cliente ya registrado',
        $q$ SELECT SV_CLIENTE.ad('9870000003', 'otro990@correo.com', '3139870090', 'Cliente Repetido') $q$,
        'P0001', '%El cliente 9870000003 ya esta registrado%');

    -- Modificar un cliente que no existe
    PERFORM pg_temp.rechazar('modificar cliente inexistente',
        $q$ SELECT SV_CLIENTE.up('9879999999', 'x987999@correo.com', '3109879999', 'Nadie Existe') $q$,
        'P0001', '%El cliente 9879999999 no existe%');

    -- Eliminar un cliente que no existe
    PERFORM pg_temp.rechazar('eliminar cliente inexistente',
        $q$ SELECT SV_CLIENTE.de('9879999999') $q$,
        'P0001', '%El cliente 9879999999 no existe%');

    -- Eliminar un cliente que tiene ventas y servicios
    PERFORM pg_temp.rechazar('eliminar cliente con ventas',
        $q$ SELECT SV_CLIENTE.de('9870000003') $q$,
        '23503', '%No se puede eliminar el cliente 9870000003%');


    -- PRODUCTOS, CATEGORIAS, INVENTARIOS Y PROVEEDORES


    -- Producto con precio negativo
    PERFORM pg_temp.rechazar('producto con precio negativo',
        $q$ SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', -5000, 20, 987001, 987001, 987001) $q$,
        '23514', '%chk_productos_precio_unitario%');

    -- Producto con cantidad negativa
    PERFORM pg_temp.rechazar('producto con cantidad negativa',
        $q$ SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, -1, 987001, 987001, 987001) $q$,
        '23514', '%chk_productos_cantidad_producto%');

    -- Producto con un nombre que ya existe
    PERFORM pg_temp.rechazar('producto con nombre repetido',
        $q$ SELECT SV_PRODUCTO.ad(987010, 'Teclado NoOK', 5000, 5, 987001, 987001, 987001) $q$,
        '23505', '%uk_productos_nombre_producto%');

    -- Producto con categoria, proveedor e inventario que no existen
    PERFORM pg_temp.rechazar('producto con categoria inexistente',
        $q$ SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, 5, 987999, 987001, 987001) $q$,
        '23503', '%fk_productos_categoria%');

    PERFORM pg_temp.rechazar('producto con proveedor inexistente',
        $q$ SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, 5, 987001, 987999, 987001) $q$,
        '23503', '%fk_productos_proveedor%');

    PERFORM pg_temp.rechazar('producto con inventario inexistente',
        $q$ SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, 5, 987001, 987001, 987999) $q$,
        '23503', '%fk_productos_inventarios%');

    -- Modificar y eliminar un producto que no existe
    PERFORM pg_temp.rechazar('modificar producto inexistente',
        $q$ SELECT SV_PRODUCTO.up(987999, 'Fantasma', 5000, 5, 987001, 987001, 987001) $q$,
        'P0001', '%El producto 987999 no existe%');

    PERFORM pg_temp.rechazar('eliminar producto inexistente',
        $q$ SELECT SV_PRODUCTO.de(987999) $q$,
        'P0001', '%El producto 987999 no existe%');

    -- Eliminar un producto que ya se vendio
    PERFORM pg_temp.rechazar('eliminar producto vendido',
        $q$ SELECT SV_PRODUCTO.de(987001) $q$,
        '23503', '%No se puede eliminar el producto 987001%');

    -- Categoria con nombre repetido
    PERFORM pg_temp.rechazar('categoria con nombre repetido',
        $q$ SELECT SV_CATEGORIA.ad(987010, 'Categoria NoOK', 'Otra descripcion') $q$,
        '23505', '%uk_categorias_nombre_categoria%');

    -- Eliminar una categoria, un inventario y un proveedor que tienen productos
    PERFORM pg_temp.rechazar('eliminar categoria con productos',
        $q$ SELECT SV_CATEGORIA.de(987001) $q$,
        '23503', '%No se puede eliminar la categoria 987001%');

    PERFORM pg_temp.rechazar('eliminar inventario con productos',
        $q$ SELECT SV_INVENTARIO.de(987001) $q$,
        '23503', '%No se puede eliminar el inventario 987001%');

    PERFORM pg_temp.rechazar('eliminar proveedor con productos',
        $q$ SELECT SV_PROVEEDOR.de(987001) $q$,
        '23503', '%tiene productos asociados%');

    -- Proveedor con telefono o correo repetidos
    PERFORM pg_temp.rechazar('proveedor con telefono repetido',
        $q$ SELECT SV_PROVEEDOR.ad(987010, '3109870001', 'otro987010@correo.com', 'Proveedor Nuevo') $q$,
        '23505', '%telefono_proveedor%');

    PERFORM pg_temp.rechazar('proveedor con correo repetido',
        $q$ SELECT SV_PROVEEDOR.ad(987010, '3109870010', 'proveedor987001@correo.com', 'Proveedor Nuevo') $q$,
        '23505', '%email_proveedor%');

    -- Proveedor con telefono invalido
    PERFORM pg_temp.rechazar('proveedor con telefono invalido',
        $q$ SELECT SV_PROVEEDOR.ad(987010, 'telefono', 'otro987010@correo.com', 'Proveedor Nuevo') $q$,
        '23514', '%chk_telefonos%');


    -- CATALOGOS: SERVICIOS, ESTADOS Y ESPECIALIZACIONES


    -- Servicio del catalogo con precio negativo
    PERFORM pg_temp.rechazar('catalogo con precio negativo',
        $q$ SELECT SV_CATALOGO.ad(987010, 'Servicio invalido', -1) $q$,
        '23514', '%chk_servicios_precio_base%');

    -- Eliminar un servicio del catalogo que ya se uso
    PERFORM pg_temp.rechazar('eliminar servicio del catalogo en uso',
        $q$ SELECT SV_CATALOGO.de(987001) $q$,
        '23503', '%No se puede eliminar el servicio del catalogo 987001%');

    -- Estados fuera de los valores permitidos (dominios)
    PERFORM pg_temp.rechazar('estado de servicio invalido',
        $q$ SELECT SV_ESTADOSERVICIO.ad(987010, 'Cancelado') $q$,
        '23514', '%chk_estados%');

    PERFORM pg_temp.rechazar('estado de pago invalido',
        $q$ SELECT SV_ESTADOPAGO.ad(987010, 'Parcial') $q$,
        '23514', '%chk_estadospago%');

    PERFORM pg_temp.rechazar('especializacion invalida',
        $q$ SELECT SV_ESPECIALIZACION.ad(987010, 'Plomeria') $q$,
        '23514', '%chk_especializaciones%');

    -- Estado de servicio repetido
    PERFORM pg_temp.rechazar('estado de servicio repetido',
        $q$ SELECT SV_ESTADOSERVICIO.ad(987010, 'En proceso') $q$,
        '23505', '%uk_estadosdeservicios_nombre_estado%');

    -- Eliminar estados y especializaciones que estan en uso
    PERFORM pg_temp.rechazar('eliminar estado de servicio en uso',
        $q$ SELECT SV_ESTADOSERVICIO.de(1) $q$,
        '23503', '%No se puede eliminar el estado de servicio 1%');

    PERFORM pg_temp.rechazar('eliminar estado de pago en uso',
        $q$ SELECT SV_ESTADOPAGO.de(2) $q$,
        '23503', '%No se puede eliminar el estado de pago 2%');

    PERFORM pg_temp.rechazar('eliminar especializacion en uso',
        $q$ SELECT SV_ESPECIALIZACION.de(5) $q$,
        '23503', '%No se puede eliminar la especializacion 5%');



    -- SERVICIOS TECNICOS


    -- Fecha estimada de entrega anterior a la fecha de inicio
    PERFORM pg_temp.rechazar('servicio con fecha estimada anterior al inicio',
        $q$ SELECT SV_SERVICIOTECNICO.ad(987010, '9870000002', '9870000003', 987001, LOCALTIMESTAMP - INTERVAL '1 day') $q$,
        '23514', '%chk_serviciostecnicos_fecha_estimada_entrega%');

    -- Tecnico que no existe, y un vendedor que no es tecnico
    PERFORM pg_temp.rechazar('servicio con tecnico inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.ad(987010, '9879999999', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days') $q$,
        '23503', '%fk_serviciostecnicos_tecnicos%');

    PERFORM pg_temp.rechazar('servicio asignado a un vendedor',
        $q$ SELECT SV_SERVICIOTECNICO.ad(987010, '9870000001', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days') $q$,
        '23503', '%fk_serviciostecnicos_tecnicos%');

    -- Cliente y servicio de catalogo que no existen
    PERFORM pg_temp.rechazar('servicio con cliente inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.ad(987010, '9870000002', '9879999999', 987001, LOCALTIMESTAMP + INTERVAL '3 days') $q$,
        '23503', '%fk_serviciostecnicos_clientes%');

    PERFORM pg_temp.rechazar('servicio con catalogo inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.ad(987010, '9870000002', '9870000003', 987999, LOCALTIMESTAMP + INTERVAL '3 days') $q$,
        '23503', '%fk_serviciostecnicos_catalogodeservicios%');

    -- Id de servicio repetido
    PERFORM pg_temp.rechazar('servicio con id repetido',
        $q$ SELECT SV_SERVICIOTECNICO.ad(987001, '9870000002', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days') $q$,
        '23505', '%pk_serviciostecnicos%');

    -- Modificar un servicio que no existe
    PERFORM pg_temp.rechazar('modificar servicio inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.up(987999, '9870000002', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days') $q$,
        'P0001', '%El servicio tecnico 987999 no existe%');

    -- Entregar un servicio sin fecha de entrega (trigger)
    PERFORM pg_temp.rechazar('entregar sin fecha de entrega',
        $q$ SELECT SV_SERVICIOTECNICO.up_estado(987001, 2) $q$,
        'P0001', '%debe tener fecha de entrega%');

    -- Entregar con una fecha anterior al inicio del servicio
    PERFORM pg_temp.rechazar('entregar con fecha anterior al inicio',
        $q$ SELECT SV_SERVICIOTECNICO.up_estado(987001, 2, LOCALTIMESTAMP - INTERVAL '1 day') $q$,
        '23514', '%chk_serviciostecnicos_fecha_entrega%');

    -- Cambiar a un estado de servicio y a un estado de pago que no existen
    PERFORM pg_temp.rechazar('estado de servicio inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.up_estado(987001, 987999) $q$,
        '23503', '%fk_serviciostecnicos_estadosdeservicios%');

    PERFORM pg_temp.rechazar('estado de pago inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.up_pago(987001, 987999) $q$,
        '23503', '%fk_serviciostecnicos_estadosdepago%');

    -- Cambiar el pago de un servicio que no existe
    PERFORM pg_temp.rechazar('pago de servicio inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.up_pago(987999, 1) $q$,
        'P0001', '%El servicio tecnico 987999 no existe%');

    -- Eliminar un servicio entregado (trigger)
    PERFORM pg_temp.rechazar('eliminar servicio entregado',
        $q$ SELECT SV_SERVICIOTECNICO.de(987002) $q$,
        'P0001', '%No se puede eliminar un servicio en estado Entregado%');

    -- Eliminar un servicio que no existe
    PERFORM pg_temp.rechazar('eliminar servicio inexistente',
        $q$ SELECT SV_SERVICIOTECNICO.de(987999) $q$,
        'P0001', '%El servicio tecnico 987999 no existe%');


    RAISE NOTICE 'TODOS LOS CASOS NO OK FUERON RECHAZADOS';

END $do$;

-- Deshacer los datos de prueba y la funcion auxiliar
ROLLBACK;