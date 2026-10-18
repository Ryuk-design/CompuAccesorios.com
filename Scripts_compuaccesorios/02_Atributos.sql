-- MANTENER EMPLEADO
-- Si no se indica, un empleado nuevo queda como activo por defecto.
ALTER TABLE empleados
ALTER COLUMN actualmente_trabaja
    SET DEFAULT FALSE;

ALTER TABLE empleados
ADD CONSTRAINT chk_empleados_salario
    CHECK (salario_empleado > 0);


-- La comision por servicio de un tecnico debe ser mayor que cero.
ALTER TABLE tecnicos
ADD CONSTRAINT chk_tecnicos_comision
    CHECK (comision_servicio > 0);


-- La comision por venta de un vendedor debe ser mayor que cero.
ALTER TABLE vendedores
ADD CONSTRAINT chk_vendedores_comision
    CHECK (comision_venta > 0);


-- MANTENER CATALOGOS
-- El precio base de un servicio debe ser mayor o igual a cero.
ALTER TABLE catalogoDeServicios
ADD CONSTRAINT chk_servicios_precio_base
    CHECK (precio_base >= 0);


-- MANTENER PRODUCTO
-- El precio unitario de un producto debe ser mayor a cero.
ALTER TABLE productos
ADD CONSTRAINT chk_productos_precio_unitario
    CHECK (precio_unitario_producto > 0);


-- La cantidad de un producto debe ser mayor o igual que cero.
ALTER TABLE productos
ADD CONSTRAINT chk_productos_cantidad_producto
    CHECK (cantidad_producto >= 0);


-- MANTENER PROVEEDOR
-- Si no se indica, un proveedor nuevo queda como activo por defecto.
ALTER TABLE proveedores
ALTER COLUMN actualmente_provee
    SET DEFAULT TRUE;


-- REGISTRAR VENTA
-- Si la fecha de venta no se especifica, esta se asigna automaticamente utilizando la hora actual.
ALTER TABLE ventas
ALTER COLUMN fecha_venta
    SET DEFAULT CURRENT_TIMESTAMP;


-- La cantidad de un producto en el detalle de una venta debe ser mayor que cero.
ALTER TABLE detallesDeVenta
ADD CONSTRAINT chk_detallesDeVenta_cantidad
    CHECK (cantidad > 0);


-- El precio unitario en el detalle de una venta debe ser mayor que cero.
ALTER TABLE detallesDeVenta
ADD CONSTRAINT chk_detallesDeVenta_precio_unitario
    CHECK (precio_unitario > 0);


-- El total de ventas debe ser mayor o igual a cero.
ALTER TABLE ventas
ADD CONSTRAINT chk_ventas_total
    CHECK (total_venta >= 0);


-- Si no se indica, el estado del servicio al crearlo se asigna el estado 'En proceso' por defecto.
ALTER TABLE estadosDeServicios
ALTER COLUMN nombre_estado
    SET DEFAULT 'En Proceso';


-- Si no se indica, el estado de pago al crearlo es 'Pendiente' por defecto.
ALTER TABLE estadosDePago
ALTER COLUMN nombre_estado_pago
    SET DEFAULT 'Pendiente';


-- Si no se indica, la fecha de inicio del servicio es la fecha y hora actual por defecto.
ALTER TABLE serviciosTecnicos
ALTER COLUMN fecha_inicio_servicio
    SET DEFAULT CURRENT_TIMESTAMP;