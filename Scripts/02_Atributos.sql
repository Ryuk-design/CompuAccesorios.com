ALTER TABLE Personas
ADD CONSTRAINT chk_cedula_persona
CHECK ( cedula ~ '^[0-9]+$'
    );


ALTER TABLE Personas
ADD CONSTRAINT chk_nombre_persona
CHECK (nombre ~ '^[A-Za-záéíóúÁÉÍÓÚñÑüÜ ''-]+$'
    );


ALTER TABLE Especializaciones
ADD CONSTRAINT chk_especializaciones_permitidas
CHECK ( especializacion IN (
                            'Mantenimiento de Hardware',
                            'Soporte de Software y Sistemas',
                            'Reparación de Periféricos',
                            'Microelectronica',
                            'Redes y Conectividad'
                            )
    );


ALTER TABLE EstadosdeServicios
ADD CONSTRAINT chk_estado_de_servicio_permitido
CHECK ( nombre_estado IN (
                            'En proceso',
                            'Entregado'
                            'Suspendido'
                            )
    );


ALTER TABLE EstadosdePago
ADD CONSTRAINT chk_estado_pago_permitido
CHECK ( nombre_estado_pago IN (
                                'Pagado',
                                'No pagado'
                                )
    );