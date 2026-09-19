# Proyecto: Sistema de Gestion de Socios de Gimnasio

Proyecto backend desarrollado con Java 21 y Spring Boot para la gestion basica de socios de un gimnasio. Incluye autenticacion mediante tokens JWT, control de roles de usuario y persistencia de datos en base de datos relacional.

---

## Descripcion del Proyecto

El sistema permite registrar y administrar los socios de un gimnasio, controlando el acceso a las operaciones segun el tipo de usuario (administrador o empleado).

### Funcionalidades principales

- Autenticacion: Inicio de sesion para obtener un token JWT que permite acceder a los endpoints protegidos.
- Registro de usuarios: Creacion de cuentas con roles ADMIN o EMPLEADO (restringido a administradores).
- Gestion de socios:
  - Registrar nuevos socios con sus datos de contacto y estado.
  - Listar los socios registrados.
  - Consultar un socio especifico por su ID.
  - Actualizar los datos de contacto (correo y telefono).
  - Cambiar el estado del socio (activo / inactivo).
  - Eliminar socios (solo administradores).
- Pertenencia de registros: Cada socio esta vinculado al usuario que lo registro. Los empleados solo pueden consultar y modificar sus propios registros, mientras que los administradores tienen acceso general.
- Reporte basico: Conteo general de socios, activos, inactivos y registros del mes actual.

---

## Estructura del Codigo

El proyecto esta organizado en los siguientes paquetes bajo `com.example.demo`:

- `config`: Contiene `DataInitializer` para cargar usuarios iniciales de prueba al arrancar.
- `controller`: `AuthController` (login y registro) y `SocioController` (operaciones de socios).
- `dto`: Clases para recibir y enviar datos en las peticiones HTTP, con sus respectivas validaciones.
- `entity`: Entidades de base de datos `UsuarioEntity` y `SocioEntity`.
- `Model`: `SocioModel` y las interfaces de MapStruct (`SocioMapping`, `UsuarioMapping`).
- `repository`: Repositorios JPA para consultas a la base de datos (`UsuarioRepository`, `SocioRepository`).
- `security`: Clases de seguridad (`SecurityConfig`, `JwtService`, `JwtAuthFilter`).
- `service`: Logica del negocio y validaciones (`AuthService`, `SocioService`, `CustomUserDetailsService`).

---

## Endpoints Disponibles

### Autenticacion (`/auth`)

| Metodo | Endpoint | Rol Requerido | Descripcion |
|---|---|---|---|
| POST | `/auth/login` | Publico | Inicia sesion y devuelve el token JWT |
| POST | `/auth/registrar` | ADMIN | Registra un nuevo usuario en el sistema |

### Socios (`/gimnasio`)

| Metodo | Endpoint | Rol Requerido | Descripcion |
|---|---|---|---|
| GET | `/gimnasio` | Autenticado | Lista los socios (ADMIN ve todos, EMPLEADO ve los suyos) |
| GET | `/gimnasio/{id}` | Autenticado | Busca un socio por ID (valida pertenencia) |
| GET | `/gimnasio/cantidad` | Autenticado | Devuelve el total de socios asignados |
| GET | `/gimnasio/reporte` | ADMIN | Reporte de cantidad de activos, inactivos y nuevos |
| POST | `/gimnasio` | Autenticado | Crea un nuevo socio asignado al usuario actual |
| PUT | `/gimnasio/{id}` | Autenticado | Actualiza datos del socio (valida pertenencia) |
| PATCH | `/gimnasio/{id}/estado` | Autenticado | Cambia el estado activo/inactivo (valida pertenencia) |
| DELETE | `/gimnasio/{id}` | ADMIN | Elimina un socio del sistema |

---

## Usuarios de Prueba Iniciales

Al iniciar por primera vez, el sistema crea dos usuarios por defecto:

- **admin** / contraseña: `123456` (Rol: ADMIN)
- **empleado** / contraseña: `123456` (Rol: EMPLEADO)

---

## Requerimientos Implementados

1. **APIs REST (GET, POST, PUT, DELETE):** Operaciones CRUD completas en `SocioController` y `AuthController`.
2. **Logica de pertenencia:** Implementada en `SocioService.verificarPertenencia()`. Un empleado no puede modificar ni consultar socios creados por otro usuario.
3. **Logica de autorizacion por rol:** En `SecurityConfig`, las acciones de registrar usuario, eliminar socios y ver reportes requieren rol ADMIN.
4. **Codigo SQL en Flyway:** Tablas iniciales gestionadas mediante la migracion `V1__crear_tablas_iniciales.sql`.
5. **Validaciones de formulario:** Anotaciones de Jakarta Validation en los DTOs (`@NotBlank`, `@Pattern`, `@Email`, `@Size`, `@NotNull`).
6. **Validacion de negocio:** Validacion de DNI y correo unicos en base de datos antes de guardar (retorna 409 Conflict), ademas de flujos para cambio de estado y reporte.
7. **MapStruct + Lombok:** Mapeo automatico entre DTOs y entidades mediante `@Mapper`, y uso de anotaciones de Lombok (`@Data`, `@Builder`, etc.) para reducir codigo repetitivo.

---

## Base de Datos y Migracion a PostgreSQL

### Estado actual: SQL Server
El proyecto esta configurado actualmente para funcionar con Microsoft SQL Server en `application.properties`:

```properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=gimprueba;encrypt=true;trustServerCertificate=true
spring.datasource.username=luis
spring.datasource.password=123
```

### Pasos para migrar a PostgreSQL
El proyecto se puede migrar facilmente a PostgreSQL en 3 pasos:

1. En `build.gradle`, cambiar las dependencias de SQL Server por el driver de PostgreSQL:
   ```groovy
   runtimeOnly 'org.postgresql:postgresql'
   ```

2. En `src/main/resources/application.properties`, actualizar la conexion:
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/gimprueba
   spring.datasource.username=postgres
   spring.datasource.password=tu_password
   spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
   ```

3. En `src/main/resources/db/migration/V1__crear_tablas_iniciales.sql`, adaptar la sintaxis de las tablas a PostgreSQL:
   ```sql
   DROP TABLE IF EXISTS socio CASCADE;
   DROP TABLE IF EXISTS usuario CASCADE;

   CREATE TABLE usuario (
       id             BIGSERIAL PRIMARY KEY,
       username       VARCHAR(50)  NOT NULL UNIQUE,
       password       VARCHAR(100) NOT NULL,
       rol            VARCHAR(20)  NOT NULL DEFAULT 'EMPLEADO',
       activo         BOOLEAN      NOT NULL DEFAULT TRUE,
       fecha_creacion TIMESTAMP    NULL
   );

   CREATE TABLE socio (
       id             BIGSERIAL PRIMARY KEY,
       dni            VARCHAR(8)   NULL,
       nombre         VARCHAR(100) NULL,
       apellido       VARCHAR(100) NULL,
       activo         BOOLEAN      NOT NULL DEFAULT FALSE,
       telefono       VARCHAR(20)  NULL,
       correo         VARCHAR(100) NULL,
       fecha_creacion TIMESTAMP    NULL,
       usuario_id     BIGINT       NULL REFERENCES usuario (id)
   );

   CREATE INDEX ix_socio_usuario ON socio (usuario_id);
   ```

El resto del codigo en Java (controladores, servicios, repositorios) no requiere modificaciones.
