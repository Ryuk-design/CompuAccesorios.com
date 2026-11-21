BEGIN;

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

-- Punto de guardado maestro
SAVEPOINT base_pruebas;

-- VENTAS (SV_VENTA)

-- Registrar venta con un cliente que no existe
SELECT SV_VENTA.ad(987010, '9879999999', '9870000001');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Registrar venta con un vendedor que no existe
SELECT SV_VENTA.ad(987010, '9870000003', '9879999999');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Un tecnico (empleado que no es vendedor) intenta registrar una venta
SELECT SV_VENTA.ad(987010, '9870000003', '9870000002');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Registrar una venta con un id que ya existe
SELECT SV_VENTA.ad(987001, '9870000003', '9870000001');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Agregar un producto a una venta que no existe
SELECT SV_VENTA.ad_detalle(987999, 987002, 1);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Agregar un producto que no existe
SELECT SV_VENTA.ad_detalle(987001, 987999, 1);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Vender 11 unidades de un producto que tiene 10 (trigger de existencias)
SELECT SV_VENTA.ad_detalle(987001, 987002, 11);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cantidad cero en el detalle
SELECT SV_VENTA.ad_detalle(987001, 987002, 0);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cantidad negativa en el detalle
SELECT SV_VENTA.ad_detalle(987001, 987002, -3);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Agregar de nuevo un producto que ya esta en la venta
SELECT SV_VENTA.ad_detalle(987001, 987001, 1);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar la cantidad de un producto que no esta en la venta
SELECT SV_VENTA.up_detalle(987001, 987002, 1);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Subir la cantidad a 11 teniendo 10 en total (2 ya vendidas + 8 en bodega)
SELECT SV_VENTA.up_detalle(987001, 987001, 11);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar la cantidad a cero
SELECT SV_VENTA.up_detalle(987001, 987001, 0);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Quitar un producto que no esta en la venta
SELECT SV_VENTA.de_detalle(987001, 987002);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar una venta que no existe
SELECT SV_VENTA.de(987999);
ROLLBACK TO SAVEPOINT base_pruebas;


-- EMPLEADOS

-- Registrar como vendedor a alguien que ya es empleado
SELECT SV_EMPLEADO.ad_vendedor('9870000001', 'otro987@correo.com', '3119870099', 'Vendedor Repetido', 2000000, 3000);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Un vendedor intenta registrarse tambien como tecnico
SELECT SV_EMPLEADO.ad_tecnico('9870000001', 'otro988@correo.com', '3119870098', 'Vendedor Tecnico', 2000000, 5000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Un tecnico intenta registrarse tambien como vendedor
SELECT SV_EMPLEADO.ad_vendedor('9870000002', 'otro989@correo.com', '3119870097', 'Tecnico Vendedor', 2000000, 3000);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Correo sin arroba (dominio TEmail)
SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'correo-sin-arroba', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Telefono con menos de 10 digitos (dominio TTelefono)
SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '31098', 'Tecnico Nuevo', 2000000, 5000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Nombre con numeros (dominio TNombre)
SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico 123', 2000000, 5000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cedula con letras
SELECT SV_EMPLEADO.ad_tecnico('98ABC00010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cedula de 11 digitos
SELECT SV_EMPLEADO.ad_tecnico('98700000100', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Correo que ya pertenece a otra persona
SELECT SV_EMPLEADO.ad_vendedor('9870000011', 'vendedor987001@correo.com', '3109870011', 'Vendedor Nuevo', 2000000, 3000);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Salario cero
SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 0, 5000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Comision de servicio cero
SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 0, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Comision de venta cero
SELECT SV_EMPLEADO.ad_vendedor('9870000011', 'nuevo987011@correo.com', '3109870011', 'Vendedor Nuevo', 2000000, 0);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Especializacion que no existe
SELECT SV_EMPLEADO.ad_tecnico('9870000010', 'nuevo987010@correo.com', '3109870010', 'Tecnico Nuevo', 2000000, 5000, 987999);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar un empleado que no existe
SELECT SV_EMPLEADO.up('9879999999', 'x987999@correo.com', '3109879999', 'Nadie Existe', 2000000, TRUE);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar como tecnico a alguien que es vendedor
SELECT SV_EMPLEADO.up_tecnico('9870000001', 6000, 5);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar como vendedor a alguien que es tecnico
SELECT SV_EMPLEADO.up_vendedor('9870000002', 4000);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un empleado que no existe
SELECT SV_EMPLEADO.de('9879999999');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un vendedor que ya tiene ventas
SELECT SV_EMPLEADO.de('9870000001');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un tecnico que ya tiene servicios
SELECT SV_EMPLEADO.de('9870000002');
ROLLBACK TO SAVEPOINT base_pruebas;


-- CLIENTES

-- Registrar un cliente que ya existe
SELECT SV_CLIENTE.ad('9870000003', 'otro990@correo.com', '3139870090', 'Cliente Repetido');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar un cliente que no existe
SELECT SV_CLIENTE.up('9879999999', 'x987999@correo.com', '3109879999', 'Nadie Existe');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un cliente que no existe
SELECT SV_CLIENTE.de('9879999999');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un cliente que tiene ventas y servicios
SELECT SV_CLIENTE.de('9870000003');
ROLLBACK TO SAVEPOINT base_pruebas;


-- PRODUCTOS, CATEGORIAS, INVENTARIOS Y PROVEEDORES

-- Producto con precio negativo
SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', -5000, 20, 987001, 987001, 987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Producto con cantidad negativa
SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, -1, 987001, 987001, 987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Producto con un nombre que ya existe
SELECT SV_PRODUCTO.ad(987010, 'Teclado NoOK', 5000, 5, 987001, 987001, 987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Producto con categoria que no existe
SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, 5, 987999, 987001, 987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Producto con proveedor que no existe
SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, 5, 987001, 987999, 987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Producto con inventario que no existe
SELECT SV_PRODUCTO.ad(987010, 'Cable USB NoOK', 5000, 5, 987001, 987001, 987999);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar un producto que no existe
SELECT SV_PRODUCTO.up(987999, 'Fantasma', 5000, 5, 987001, 987001, 987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un producto que no existe
SELECT SV_PRODUCTO.de(987999);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un producto que ya se vendio
SELECT SV_PRODUCTO.de(987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Categoria con nombre repetido
SELECT SV_CATEGORIA.ad(987010, 'Categoria NoOK', 'Otra descripcion');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar una categoria que tiene productos
SELECT SV_CATEGORIA.de(987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un inventario que tiene productos
SELECT SV_INVENTARIO.de(987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un proveedor que tiene productos
SELECT SV_PROVEEDOR.de(987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Proveedor con telefono repetido
SELECT SV_PROVEEDOR.ad(987010, '3109870001', 'otro987010@correo.com', 'Proveedor Nuevo');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Proveedor con correo repetido
SELECT SV_PROVEEDOR.ad(987010, '3109870010', 'proveedor987001@correo.com', 'Proveedor Nuevo');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Proveedor con telefono invalido
SELECT SV_PROVEEDOR.ad(987010, 'telefono', 'otro987010@correo.com', 'Proveedor Nuevo');
ROLLBACK TO SAVEPOINT base_pruebas;


-- CATALOGOS: SERVICIOS, ESTADOS Y ESPECIALIZACIONES

-- Servicio del catalogo con precio negativo
SELECT SV_CATALOGO.ad(987010, 'Servicio invalido', -1);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un servicio del catalogo que ya se uso
SELECT SV_CATALOGO.de(987001);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Estado de servicio fuera de los valores permitidos (dominios)
SELECT SV_ESTADOSERVICIO.ad(987010, 'Cancelado');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Estado de pago fuera de los valores permitidos (dominios)
SELECT SV_ESTADOPAGO.ad(987010, 'Parcial');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Especializacion fuera de los valores permitidos (dominios)
SELECT SV_ESPECIALIZACION.ad(987010, 'Plomeria');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Estado de servicio repetido
SELECT SV_ESTADOSERVICIO.ad(987010, 'En proceso');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar estado de servicio que esta en uso
SELECT SV_ESTADOSERVICIO.de(1);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar estado de pago que esta en uso
SELECT SV_ESTADOPAGO.de(2);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar especializacion que esta en uso
SELECT SV_ESPECIALIZACION.de(5);
ROLLBACK TO SAVEPOINT base_pruebas;


-- SERVICIOS TECNICOS

-- Fecha estimada de entrega anterior a la fecha de inicio
SELECT SV_SERVICIOTECNICO.ad(987010, '9870000002', '9870000003', 987001, LOCALTIMESTAMP - INTERVAL '1 day');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Tecnico que no existe
SELECT SV_SERVICIOTECNICO.ad(987010, '9879999999', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Servicio asignado a un vendedor que no es tecnico
SELECT SV_SERVICIOTECNICO.ad(987010, '9870000001', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cliente que no existe
SELECT SV_SERVICIOTECNICO.ad(987010, '9870000002', '9879999999', 987001, LOCALTIMESTAMP + INTERVAL '3 days');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Servicio de catalogo que no existe
SELECT SV_SERVICIOTECNICO.ad(987010, '9870000002', '9870000003', 987999, LOCALTIMESTAMP + INTERVAL '3 days');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Id de servicio repetido
SELECT SV_SERVICIOTECNICO.ad(987001, '9870000002', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Modificar un servicio que no existe
SELECT SV_SERVICIOTECNICO.up(987999, '9870000002', '9870000003', 987001, LOCALTIMESTAMP + INTERVAL '3 days');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Entregar un servicio sin fecha de entrega (trigger)
SELECT SV_SERVICIOTECNICO.up_estado(987001, 2);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Entregar con una fecha anterior al inicio del servicio
SELECT SV_SERVICIOTECNICO.up_estado(987001, 2, LOCALTIMESTAMP - INTERVAL '1 day');
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cambiar a un estado de servicio que no existe
SELECT SV_SERVICIOTECNICO.up_estado(987001, 987999);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cambiar a un estado de pago que no existe
SELECT SV_SERVICIOTECNICO.up_pago(987001, 987999);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Cambiar el pago de un servicio que no existe
SELECT SV_SERVICIOTECNICO.up_pago(987999, 1);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un servicio entregado (trigger)
SELECT SV_SERVICIOTECNICO.de(987002);
ROLLBACK TO SAVEPOINT base_pruebas;

-- Eliminar un servicio que no existe
SELECT SV_SERVICIOTECNICO.de(987999);
ROLLBACK TO SAVEPOINT base_pruebas;

ROLLBACK;