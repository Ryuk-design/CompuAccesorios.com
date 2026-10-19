ALTER TABLE personas
ADD CONSTRAINT pk_Personas
    PRIMARY KEY (cedula);


ALTER TABLE empleados
ADD CONSTRAINT pk_Empleados
    PRIMARY KEY (cedula_empleado);


ALTER TABLE tecnicos
ADD CONSTRAINT pk_Tecnicos
    PRIMARY KEY (cedula_tecnico);


ALTER TABLE vendedores
ADD CONSTRAINT pk_Vendedores
    PRIMARY KEY (cedula_vendedor);


ALTER TABLE especializaciones
ADD CONSTRAINT pk_especializaciones
    PRIMARY KEY (id);


ALTER TABLE serviciosTecnicos
ADD CONSTRAINT pk_serviciosTecnicos
    PRIMARY KEY (id);


ALTER TABLE catalogoDeServicios
ADD CONSTRAINT pk_catalogodeServicios
    PRIMARY KEY (id);


ALTER TABLE estadosDeServicios
ADD CONSTRAINT pk_estadosDeServicios
    PRIMARY KEY (id);


ALTER TABLE estadosDePago
ADD CONSTRAINT pk_estadosDePago
    PRIMARY KEY (id);


ALTER TABLE clientes
ADD CONSTRAINT pk_clientes
    PRIMARY KEY (cedula_cliente);


ALTER TABLE ventas
ADD CONSTRAINT pk_ventas
    PRIMARY KEY (id);


ALTER TABLE detallesDeVenta
ADD CONSTRAINT pk_detallesDeVenta
    PRIMARY KEY (id_venta, id_producto);


ALTER TABLE productos
ADD CONSTRAINT pk_productos
    PRIMARY KEY (id);


ALTER TABLE proveedores
ADD CONSTRAINT pk_proveedores
    PRIMARY KEY (id);

ALTER TABLE inventarios
ADD CONSTRAINT pk_inventarios
    PRIMARY KEY (id);

ALTER TABLE categorias
ADD CONSTRAINT pk_categorias
    PRIMARY KEY (id);
