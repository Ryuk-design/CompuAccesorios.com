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
