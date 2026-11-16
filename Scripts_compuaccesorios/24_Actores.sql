-- Actores

-- 1. ACTOR: ADMINISTRADOR
CREATE SCHEMA IF NOT EXISTS SV_ADMINISTRADOR;

-- Mantener Estado Pago
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_estado_pago(p_id INT, p_nombre_estado_pago TEstadoPago)
RETURNS void AS $$ BEGIN PERFORM SV_ESTADOPAGO.ad(p_id, p_nombre_estado_pago); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_estado_pago(p_id INT, p_nombre_estado_pago TEstadoPago)
RETURNS void AS $$ BEGIN PERFORM SV_ESTADOPAGO.up(p_id, p_nombre_estado_pago); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_estado_pago(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_ESTADOPAGO.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_estado_pago(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_ESTADOPAGO.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Estado Servicio
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_estado_servicio(p_id INT, p_nombre_estado TEstado)
RETURNS void AS $$ BEGIN PERFORM SV_ESTADOSERVICIO.ad(p_id, p_nombre_estado); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_estado_servicio(p_id INT, p_nombre_estado TEstado)
RETURNS void AS $$ BEGIN PERFORM SV_ESTADOSERVICIO.up(p_id, p_nombre_estado); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_estado_servicio(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_ESTADOSERVICIO.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_estado_servicio(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_ESTADOSERVICIO.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Especializacion
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_especializacion(p_id INT, p_especializacion TEspecializacion)
RETURNS void AS $$ BEGIN PERFORM SV_ESPECIALIZACION.ad(p_id, p_especializacion); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_especializacion(p_id INT, p_especializacion TEspecializacion)
RETURNS void AS $$ BEGIN PERFORM SV_ESPECIALIZACION.up(p_id, p_especializacion); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_especializacion(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_ESPECIALIZACION.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_especializacion(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_ESPECIALIZACION.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Catalogos
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_catalogo(p_id INT, p_descripcion_servicio VARCHAR(200), p_precio_base INT)
RETURNS void AS $$ BEGIN PERFORM SV_CATALOGO.ad(p_id, p_descripcion_servicio, p_precio_base); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_catalogo(p_id INT, p_descripcion_servicio VARCHAR(200), p_precio_base INT)
RETURNS void AS $$ BEGIN PERFORM SV_CATALOGO.up(p_id, p_descripcion_servicio, p_precio_base); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_catalogo(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_CATALOGO.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_catalogo(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_CATALOGO.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Categoria
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_categoria(p_id INT, p_nombre_categoria VARCHAR(100), p_descripcion_categoria VARCHAR(200))
RETURNS void AS $$ BEGIN PERFORM SV_CATEGORIA.ad(p_id, p_nombre_categoria, p_descripcion_categoria); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_categoria(p_id INT, p_nombre_categoria VARCHAR(100), p_descripcion_categoria VARCHAR(200))
RETURNS void AS $$ BEGIN PERFORM SV_CATEGORIA.up(p_id, p_nombre_categoria, p_descripcion_categoria); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_categoria(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_CATEGORIA.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_categoria(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_CATEGORIA.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- Mantener Inventario
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_inventario(p_id INT, p_descripcion_inventario VARCHAR(200))
RETURNS void AS $$ BEGIN PERFORM SV_INVENTARIO.ad(p_id, p_descripcion_inventario); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_inventario(p_id INT, p_descripcion_inventario VARCHAR(200))
RETURNS void AS $$ BEGIN PERFORM SV_INVENTARIO.up(p_id, p_descripcion_inventario); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_inventario(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_INVENTARIO.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_inventario(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_INVENTARIO.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Producto
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_producto(p_id INT, p_nombre_producto VARCHAR(100), p_precio_unitario_producto INT, p_cantidad_producto INT, p_id_categoria INT, p_id_proveedor INT, p_id_inventario INT)
RETURNS void AS $$ BEGIN PERFORM SV_PRODUCTO.ad(p_id, p_nombre_producto, p_precio_unitario_producto, p_cantidad_producto, p_id_categoria, p_id_proveedor, p_id_inventario); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_producto(p_id INT, p_nombre_producto VARCHAR(100), p_precio_unitario_producto INT, p_cantidad_producto INT, p_id_categoria INT, p_id_proveedor INT, p_id_inventario INT)
RETURNS void AS $$ BEGIN PERFORM SV_PRODUCTO.up(p_id, p_nombre_producto, p_precio_unitario_producto, p_cantidad_producto, p_id_categoria, p_id_proveedor, p_id_inventario); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_producto(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_PRODUCTO.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_producto(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_PRODUCTO.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Proveedor
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_proveedor(p_id INT, p_telefono_proveedor TTelefono, p_email_proveedor TEmail, p_nombre_proveedor VARCHAR)
RETURNS void AS $$ BEGIN PERFORM SV_PROVEEDOR.ad(p_id, p_telefono_proveedor, p_email_proveedor, p_nombre_proveedor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_proveedor(p_id INT, p_telefono_proveedor TTelefono, p_email_proveedor TEmail, p_nombre_proveedor VARCHAR, p_actualmente_provee BOOLEAN)
RETURNS void AS $$ BEGIN PERFORM SV_PROVEEDOR.up(p_id, p_telefono_proveedor, p_email_proveedor, p_nombre_proveedor, p_actualmente_provee); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_proveedor(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_PROVEEDOR.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_proveedor(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_PROVEEDOR.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Empleado
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_tecnico(p_cedula VARCHAR, p_email TEmail, p_telefono TTelefono, p_nombre TNombre, p_salario_empleado INT, p_comision_servicio INT, p_id_especializacion INT)
RETURNS void AS $$ BEGIN PERFORM SV_EMPLEADO.ad_tecnico(p_cedula, p_email, p_telefono, p_nombre, p_salario_empleado, p_comision_servicio, p_id_especializacion); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.ad_vendedor(p_cedula VARCHAR, p_email TEmail, p_telefono TTelefono, p_nombre TNombre, p_salario_empleado INT, p_comision_venta INT)
RETURNS void AS $$ BEGIN PERFORM SV_EMPLEADO.ad_vendedor(p_cedula, p_email, p_telefono, p_nombre, p_salario_empleado, p_comision_venta); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_empleado(p_cedula VARCHAR, p_email TEmail, p_telefono TTelefono, p_nombre TNombre, p_salario_empleado INT, p_actualmente_trabaja BOOLEAN)
RETURNS void AS $$ BEGIN PERFORM SV_EMPLEADO.up(p_cedula, p_email, p_telefono, p_nombre, p_salario_empleado, p_actualmente_trabaja); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_tecnico(p_cedula VARCHAR, p_comision_servicio INT, p_id_especializacion INT)
RETURNS void AS $$ BEGIN PERFORM SV_EMPLEADO.up_tecnico(p_cedula, p_comision_servicio, p_id_especializacion); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.up_vendedor(p_cedula VARCHAR, p_comision_venta INT)
RETURNS void AS $$ BEGIN PERFORM SV_EMPLEADO.up_vendedor(p_cedula, p_comision_venta); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.de_empleado(p_cedula VARCHAR)
RETURNS void AS $$ BEGIN PERFORM SV_EMPLEADO.de(p_cedula); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_empleado(p_cursor REFCURSOR, p_cedula VARCHAR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_EMPLEADO.co(p_cursor, p_cedula); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



-- 2. ACTOR: VENDEDOR
CREATE SCHEMA IF NOT EXISTS SV_VENDEDOR;


-- Mantener Cliente
CREATE OR REPLACE FUNCTION SV_VENDEDOR.ad_cliente(p_cedula VARCHAR, p_email TEmail, p_telefono TTelefono, p_nombre TNombre)
RETURNS void AS $$ BEGIN PERFORM SV_CLIENTE.ad(p_cedula, p_email, p_telefono, p_nombre); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.up_cliente(p_cedula VARCHAR, p_email TEmail, p_telefono TTelefono, p_nombre TNombre)
RETURNS void AS $$ BEGIN PERFORM SV_CLIENTE.up(p_cedula, p_email, p_telefono, p_nombre); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.de_cliente(p_cedula VARCHAR)
RETURNS void AS $$ BEGIN PERFORM SV_CLIENTE.de(p_cedula); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.co_cliente(p_cursor REFCURSOR, p_cedula VARCHAR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_CLIENTE.co(p_cursor, p_cedula); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Registrar Venta
CREATE OR REPLACE FUNCTION SV_VENDEDOR.ad_venta(p_id INT, p_cedula_cliente VARCHAR, p_cedula_vendedor VARCHAR)
RETURNS void AS $$ BEGIN PERFORM SV_VENTA.ad(p_id, p_cedula_cliente, p_cedula_vendedor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.ad_detalle_venta(p_id_venta INT, p_id_producto INT, p_cantidad INT)
RETURNS void AS $$ BEGIN PERFORM SV_VENTA.ad_detalle(p_id_venta, p_id_producto, p_cantidad); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.up_detalle_venta(p_id_venta INT, p_id_producto INT, p_cantidad INT)
RETURNS void AS $$ BEGIN PERFORM SV_VENTA.up_detalle(p_id_venta, p_id_producto, p_cantidad); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.de_detalle_venta(p_id_venta INT, p_id_producto INT)
RETURNS void AS $$ BEGIN PERFORM SV_VENTA.de_detalle(p_id_venta, p_id_producto); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.de_venta(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_VENTA.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.co_venta(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_VENTA.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.co_detalle_venta(p_cursor REFCURSOR, p_id_venta INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_VENTA.co_detalle(p_cursor, p_id_venta); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



-- 3. ACTOR: TECNICO
CREATE SCHEMA IF NOT EXISTS SV_TECNICO;


-- Mantener Cliente
CREATE OR REPLACE FUNCTION SV_TECNICO.ad_cliente(p_cedula VARCHAR, p_email TEmail, p_telefono TTelefono, p_nombre TNombre)
RETURNS void AS $$ BEGIN PERFORM SV_CLIENTE.ad(p_cedula, p_email, p_telefono, p_nombre); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_cliente(p_cedula VARCHAR, p_email TEmail, p_telefono TTelefono, p_nombre TNombre)
RETURNS void AS $$ BEGIN PERFORM SV_CLIENTE.up(p_cedula, p_email, p_telefono, p_nombre); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.de_cliente(p_cedula VARCHAR)
RETURNS void AS $$ BEGIN PERFORM SV_CLIENTE.de(p_cedula); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_cliente(p_cursor REFCURSOR, p_cedula VARCHAR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_CLIENTE.co(p_cursor, p_cedula); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- Mantener Servicio Tecnico
CREATE OR REPLACE FUNCTION SV_TECNICO.ad_servicio_tecnico(p_id INT, p_id_tecnico VARCHAR, p_cedula_cliente VARCHAR, p_id_catalogo_servicio INT, p_fecha_estimada_entrega TIMESTAMP)
RETURNS void AS $$ BEGIN PERFORM SV_SERVICIOTECNICO.ad(p_id, p_id_tecnico, p_cedula_cliente, p_id_catalogo_servicio, p_fecha_estimada_entrega); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_servicio_tecnico(p_id INT, p_id_tecnico VARCHAR, p_cedula_cliente VARCHAR, p_id_catalogo_servicio INT, p_fecha_estimada_entrega TIMESTAMP)
RETURNS void AS $$ BEGIN PERFORM SV_SERVICIOTECNICO.up(p_id, p_id_tecnico, p_cedula_cliente, p_id_catalogo_servicio, p_fecha_estimada_entrega); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_estado_servicio_tecnico(p_id INT, p_id_estado_servicio INT, p_fecha_entrega TIMESTAMP DEFAULT NULL)
RETURNS void AS $$ BEGIN PERFORM SV_SERVICIOTECNICO.up_estado(p_id, p_id_estado_servicio, p_fecha_entrega); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.up_pago_servicio_tecnico(p_id INT, p_id_estado_pago INT)
RETURNS void AS $$ BEGIN PERFORM SV_SERVICIOTECNICO.up_pago(p_id, p_id_estado_pago); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.de_servicio_tecnico(p_id INT)
RETURNS void AS $$ BEGIN PERFORM SV_SERVICIOTECNICO.de(p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_servicio_tecnico(p_cursor REFCURSOR, p_id INT)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_SERVICIOTECNICO.co(p_cursor, p_id); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_TECNICO.co_servicios_por_tecnico(p_cursor REFCURSOR, p_cedula_tecnico VARCHAR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_SERVICIOTECNICO.co_tecnico(p_cursor, p_cedula_tecnico); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



-- CONSULTAS OPERATIVAS

-- ADMINISTRADOR
CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_servicios_por_tecnico_y_clientes(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_SERVICIOTECNICO.co_por_tecnico_y_cliente(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_ventas_ultimo_mes(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_VENTA.co_ultimo_mes(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_ventas_por_vendedor(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_VENTA.co_por_vendedor(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_categoria_mas_vendida(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_CATEGORIA.co_mas_vendida(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_ADMINISTRADOR.co_stock_productos(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_PRODUCTO.co_stock(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- VENDEDOR
CREATE OR REPLACE FUNCTION SV_VENDEDOR.co_catalogo_productos(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_PRODUCTO.co_catalogo_disponibles(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_VENDEDOR.co_historial_ventas(p_cursor REFCURSOR, p_cedula_vendedor VARCHAR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_VENTA.co_historial_vendedor(p_cursor, p_cedula_vendedor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


-- TECNICO
CREATE OR REPLACE FUNCTION SV_TECNICO.co_historial_clientes_atendidos(p_cursor REFCURSOR, p_cedula_tecnico VARCHAR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_SERVICIOTECNICO.co_clientes_atendidos(p_cursor, p_cedula_tecnico); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;



-- 4. ACTOR: GERENTE
CREATE SCHEMA IF NOT EXISTS SV_GERENTE;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_producto_mas_vendido(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_PRODUCTO.co_mas_vendido(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_servicio_tecnico_mas_comun(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_SERVICIOTECNICO.co_mas_comun(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_productos_bajo_inventario(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_PRODUCTO.co_bajo_inventario(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;


CREATE OR REPLACE FUNCTION SV_GERENTE.co_proveedor_mas_frecuente(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$ BEGIN RETURN SV_PROVEEDOR.co_mas_frecuente(p_cursor); END; $$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;