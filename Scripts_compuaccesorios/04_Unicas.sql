ALTER TABLE Personas
ADD CONSTRAINT uk_Personas_email
    UNIQUE (email);


ALTER TABLE Especializaciones
ADD CONSTRAINT uk_Especializaciones_especializacion
    UNIQUE (especializacion);


ALTER TABLE Categorias
ADD CONSTRAINT uk_Categorias_nombre_categoria
    UNIQUE (nombre_categoria);


ALTER TABLE Productos
ADD CONSTRAINT uk_Productos_nombre_producto
    UNIQUE (nombre_producto);

-- InicioProveedores

ALTER TABLE Proveedores
ADD CONSTRAINT uk_Provedores_telefono_proveedor
    UNIQUE (telefono_proveedor);


ALTER TABLE Proveedores
ADD CONSTRAINT uk_Provedores_email_proveedor
    UNIQUE (email_proveedor);

-- FinalProveedores


-- MANTENER ESTADO SERVICIO
-- El nombre del estado de servicio no se puede repetir.
ALTER TABLE estadosDeServicios
ADD CONSTRAINT uk_estadosDeServicios_nombre_estado
    UNIQUE (nombre_estado);


-- MANTENER ESTADO PAGO
-- El nombre del estado de pago no se puede repetir.
ALTER TABLE estadosDePago
ADD CONSTRAINT uk_estadosDePago_nombre_estado_pago
    UNIQUE (nombre_estado_pago);
