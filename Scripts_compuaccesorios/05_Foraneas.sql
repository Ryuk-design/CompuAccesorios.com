ALTER TABLE Empleados
ADD CONSTRAINT fk_empleados_persona
    FOREIGN KEY (cedula_empleado)
        REFERENCES Personas (cedula);


ALTER TABLE Tecnicos
ADD CONSTRAINT fk_Tecnicos_Empleados
    FOREIGN KEY (cedula_tecnico)
        REFERENCES Empleados (cedula_empleado);


ALTER TABLE Vendedores
ADD CONSTRAINT fk_Vendedores_Empleados
    FOREIGN KEY (cedula_vendedor)
        REFERENCES Empleados (cedula_empleado);


-- InicioServiciosTecnicos


ALTER TABLE ServiciosTecnicos
ADD CONSTRAINT fk_ServiciosTecnicos_Tecnicos
    FOREIGN KEY (id_tecnico)
        REFERENCES Tecnicos (cedula_tecnico);


ALTER TABLE ServiciosTecnicos
ADD CONSTRAINT fk_ServiciosTecnicos_EstadosdeServicios
    FOREIGN KEY (id_estado_servicio)
        REFERENCES EstadosdeServicios (id);


ALTER TABLE ServiciosTecnicos
ADD CONSTRAINT fk_ServiciosTecnicos_CatalogodeServicios
    FOREIGN KEY (id_catalogo_servicio)
        REFERENCES CatalogodeServicios (id);


ALTER TABLE ServiciosTecnicos
ADD CONSTRAINT fk_ServiciosTecnicos_EstadosdePago
    FOREIGN KEY (id_estado_pago)
        REFERENCES EstadosdePago (id);


--FinServiciosTecnicos


ALTER TABLE Clientes
ADD CONSTRAINT fk_Clientes_Personas
    FOREIGN KEY (cedula_cliente)
        REFERENCES Personas (cedula);


--InicioVentas


ALTER TABLE Ventas
ADD CONSTRAINT fk_Ventas_Clientes
    FOREIGN KEY (cedula_cliente)
        REFERENCES Clientes (cedula_cliente);


ALTER TABLE Ventas
ADD CONSTRAINT fk_Ventas_Vendedores
    FOREIGN KEY (cedula_vendedor)
        REFERENCES Vendedores (cedula_vendedor);


--FinalVentas


--InicioDetallesdeVenta


ALTER TABLE DetallesdeVenta
ADD CONSTRAINT fk_DetallesdeVenta_Ventas
    FOREIGN KEY (id_venta)
        REFERENCES Ventas (id);


ALTER TABLE DetallesdeVenta
ADD CONSTRAINT fk_DetallesdeVenta_Productos
    FOREIGN KEY (id_producto)
        REFERENCES Productos (id);


--FinalDetallesdeVenta


--InicioProductos


ALTER TABLE Productos
ADD CONSTRAINT fk_Productos_Categoria
    FOREIGN KEY (id_categoria)
        REFERENCES Categorias (id);


ALTER TABLE Productos
ADD CONSTRAINT fk_Productos_Proveedor
    FOREIGN KEY (id_proveedor)
        REFERENCES Proveedores (id);


ALTER TABLE Productos
ADD CONSTRAINT fk_Productos_Inventarios
    FOREIGN KEY (id_inventario)
        REFERENCES Inventarios (id);


--FinalProductos