-- ============================================================
--  V1 - Creacion de tablas iniciales  (PostgreSQL)
--  Tablas: usuario, socio
--  Nota: en PostgreSQL los nombres sin comillas se pliegan a
--        minusculas, por eso las entidades usan @Table(name="socio")
--        y @Table(name="usuario").
-- ============================================================

-- Primero la tabla hija (socio) porque tiene la FK hacia usuario
DROP TABLE IF EXISTS socio CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;

CREATE TABLE usuario (
    id             BIGSERIAL    NOT NULL PRIMARY KEY,
    username       VARCHAR(50)  NOT NULL,
    password       VARCHAR(100) NOT NULL,
    rol            VARCHAR(20)  NOT NULL DEFAULT 'EMPLEADO',
    activo         BOOLEAN      NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP    NULL
);

CREATE UNIQUE INDEX ux_usuario_username ON usuario (username);

CREATE TABLE socio (
    id             BIGSERIAL    NOT NULL PRIMARY KEY,
    dni            VARCHAR(8)   NULL,
    nombre         VARCHAR(100) NULL,
    apellido       VARCHAR(100) NULL,
    activo         BOOLEAN      NOT NULL DEFAULT FALSE,
    telefono       VARCHAR(20)  NULL,
    correo         VARCHAR(100) NULL,
    fecha_creacion TIMESTAMP    NULL,
    usuario_id     BIGINT       NULL,
    CONSTRAINT fk_socio_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (id)
);

CREATE INDEX ix_socio_usuario ON socio (usuario_id);