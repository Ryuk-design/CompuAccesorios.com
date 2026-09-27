ALTER TABLE Personas
ADD CONSTRAINT pk_Personas
    PRIMARY KEY (cedula);


ALTER TABLE Empleados
ADD CONSTRAINT pk_Empleados
    PRIMARY KEY (cedula_empleado);


ALTER TABLE Tecnicos
ADD CONSTRAINT pk_Tecnicos
    PRIMARY KEY (cedula_tecnico);


ALTER TABLE Vendedores
ADD CONSTRAINT pk_Vendedores
    PRIMARY KEY (cedula_vendedor);


ALTER TABLE ServiciosTecnicos
ADD CONSTRAINT pk_ServiciosTecnicos
    PRIMARY KEY (id);


ALTER TABLE CatalogodeServicios
ADD CONSTRAINT pk_CatalogodeServicios
    PRIMARY KEY (id);


ALTER TABLE EstadosdeServicios
ADD CONSTRAINT pk_EstadosdeServicios
    PRIMARY KEY (id);


ALTER TABLE EstadosdePago
ADD CONSTRAINT pk_EstadosdePago
    PRIMARY KEY (id);


ALTER TABLE Clientes
ADD CONSTRAINT pk_Clientes
    PRIMARY KEY (cedula_cliente);


ALTER TABLE Ventas
ADD CONSTRAINT pk_Ventas
    PRIMARY KEY (id);


ALTER TABLE DetallesdeVenta
ADD CONSTRAINT pk_DetallesdeVenta
    PRIMARY KEY (id_venta, id_producto);


ALTER TABLE Productos
ADD CONSTRAINT pk_Productos
    PRIMARY KEY (id);


ALTER TABLE Proveedores
ADD CONSTRAINT pk_Proveedores
    PRIMARY KEY (id);


ALTER TABLE Inventarios
ADD CONSTRAINT pk_Inventarios
    PRIMARY KEY (id);


ALTER TABLE Categorias
ADD CONSTRAINT pk_Categorias
    PRIMARY KEY (id);