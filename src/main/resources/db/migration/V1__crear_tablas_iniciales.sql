IF OBJECT_ID(N'Socio', N'U') IS NOT NULL
    DROP TABLE Socio;
IF OBJECT_ID(N'Usuario', N'U') IS NOT NULL
    DROP TABLE Usuario;

CREATE TABLE Usuario (
    id             BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    username       VARCHAR(50)  NOT NULL,
    password       VARCHAR(100) NOT NULL,
    rol            VARCHAR(20)  NOT NULL DEFAULT 'EMPLEADO',
    activo         BIT          NOT NULL DEFAULT 1,
    fecha_creacion DATETIME2    NULL
);

CREATE UNIQUE INDEX ux_usuario_username ON Usuario (username);

CREATE TABLE Socio (
    id             BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    dni            VARCHAR(8)   NULL,
    nombre         VARCHAR(100) NULL,
    apellido       VARCHAR(100) NULL,
    activo         BIT          NOT NULL DEFAULT 0,
    telefono       VARCHAR(20)  NULL,
    correo         VARCHAR(100) NULL,
    fecha_creacion DATETIME2    NULL,
    usuario_id     BIGINT       NULL,
    CONSTRAINT fk_socio_usuario FOREIGN KEY (usuario_id) REFERENCES Usuario (id)
);

CREATE INDEX ix_socio_usuario ON Socio (usuario_id);