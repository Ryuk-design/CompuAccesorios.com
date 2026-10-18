CREATE DOMAIN TEmail AS VARCHAR(254)
CONSTRAINT chk_emails
    CHECK (VALUE LIKE '%@%');


CREATE DOMAIN TEspecializacion AS VARCHAR(40)
CONSTRAINT chk_especializaciones
    CHECK (VALUE IN('Mantenimiento de Hardware',
                   'Soporte de Software y Sistemas',
                   'Reparación de Periféricos',
                   'Microelectronica',
                   'Redes y Conectividad'));


CREATE DOMAIN TEstado AS VARCHAR(10)
CONSTRAINT chk_estados
    CHECK (VALUE IN('En proceso',
                   'Entregado',
                   'Suspendido'));


CREATE DOMAIN TEstadoPago AS VARCHAR(10)
CONSTRAINT chk_estadospago
    CHECK (VALUE IN('Pagado',
                    'No pagado'));


CREATE DOMAIN TNombre AS VARCHAR(100)
CONSTRAINT chk_nombres
    CHECK (VALUE ~ '^[A-Za-záéíóúÁÉÍÓÚñÑüÜ ''-]+$');


CREATE DOMAIN TTelefono AS VARCHAR(10)
CONSTRAINT chk_telefonos
    CHECK (VALUE ~ '^[0-9]{10}$');