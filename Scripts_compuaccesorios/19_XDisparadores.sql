DROP TRIGGER IF EXISTS tg_cedula_no_modificable ON Personas;


DROP TRIGGER IF EXISTS tg_tecnico_no_es_vendedor ON Tecnicos;


DROP TRIGGER IF EXISTS tg_vendedor_no_es_tecnico ON Vendedores;


DROP TRIGGER IF EXISTS tg_servicio_entregado_con_fecha ON ServiciosTecnicos;


DROP TRIGGER IF EXISTS tg_servicio_entregado_no_eliminable ON ServiciosTecnicos;


DROP TRIGGER IF EXISTS tg_detalle_validar_existencias ON DetallesdeVenta;


DROP TRIGGER IF EXISTS tg_detalle_ajustar_existencias ON DetallesdeVenta;


DROP TRIGGER IF EXISTS tg_detalle_recalcular_total ON DetallesdeVenta;

DROP FUNCTION IF EXISTS fn_cedula_no_modificable();


DROP FUNCTION IF EXISTS fn_tecnico_no_es_vendedor();


DROP FUNCTION IF EXISTS fn_vendedor_no_es_tecnico();


DROP FUNCTION IF EXISTS fn_servicio_entregado_con_fecha();


DROP FUNCTION IF EXISTS fn_servicio_entregado_no_eliminable();


DROP FUNCTION IF EXISTS fn_detalle_validar_existencias();


DROP FUNCTION IF EXISTS fn_detalle_ajustar_existencias();


DROP FUNCTION IF EXISTS fn_detalle_recalcular_total();