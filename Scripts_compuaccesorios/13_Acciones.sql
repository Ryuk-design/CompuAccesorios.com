-- MANTENER EMPLEADO
-- Al eliminar un empleado se elimina tambien su registro como tecnico o vendedor.
-- Si tiene servicios tecnicos o ventas, la eliminacion se bloquea sola.
ALTER TABLE tecnicos
DROP CONSTRAINT fk_Tecnicos_Empleados;

ALTER TABLE tecnicos
ADD CONSTRAINT fk_Tecnicos_Empleados
    FOREIGN KEY (cedula_tecnico)
        REFERENCES empleados (cedula_empleado)
        ON DELETE CASCADE;


ALTER TABLE vendedores
DROP CONSTRAINT fk_Vendedores_Empleados;

ALTER TABLE vendedores
ADD CONSTRAINT fk_Vendedores_Empleados
    FOREIGN KEY (cedula_vendedor)
        REFERENCES empleados (cedula_empleado)
        ON DELETE CASCADE;


-- REGISTRAR VENTA
-- Al anular una venta se elimina tambien su detalle.
ALTER TABLE detallesDeVenta
DROP CONSTRAINT fk_DetallesdeVenta_Ventas;

ALTER TABLE detallesDeVenta
ADD CONSTRAINT fk_DetallesdeVenta_Ventas
    FOREIGN KEY (id_venta)
        REFERENCES ventas (id)
        ON DELETE CASCADE;
