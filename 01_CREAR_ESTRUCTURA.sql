
DROP TABLE DONACION CASCADE CONSTRAINTS;
DROP TABLE VOLUNTARIO_CAMPANIA CASCADE CONSTRAINTS;
DROP TABLE CAMPANIA CASCADE CONSTRAINTS;
DROP TABLE SEGUIMIENTO CASCADE CONSTRAINTS;
DROP TABLE ADOPCION CASCADE CONSTRAINTS;
DROP TABLE VISITA CASCADE CONSTRAINTS;
DROP TABLE SOLICITUD_ADOPCION CASCADE CONSTRAINTS;
DROP TABLE ANIMAL_VACUNA CASCADE CONSTRAINTS;
DROP TABLE VACUNA CASCADE CONSTRAINTS;
DROP TABLE ANIMAL CASCADE CONSTRAINTS;
DROP TABLE VOLUNTARIO CASCADE CONSTRAINTS;
DROP TABLE ADOPTANTE CASCADE CONSTRAINTS;
DROP TABLE PERSONA CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE REFUGIO CASCADE CONSTRAINTS;
DROP TABLE DIRECCION CASCADE CONSTRAINTS;
DROP TABLE RAZA CASCADE CONSTRAINTS;
DROP TABLE ESPECIE CASCADE CONSTRAINTS;

CREATE TABLE ESPECIE (
    id_especie NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(50) UNIQUE NOT NULL
);

COMMENT ON TABLE ESPECIE IS
    'Tipo de especie de animales manejados en la plataforma';
COMMENT ON COLUMN ESPECIE.id_especie IS
    'Identificador unico de la especie';

CREATE TABLE RAZA (
    id_raza NUMBER(10) PRIMARY KEY,
    id_especie NUMBER(10),
    nombre VARCHAR2(50),
    FOREIGN KEY (id_especie) REFERENCES ESPECIE(id_especie)
);

CREATE INDEX idx_raza_especie
ON RAZA(id_especie);

COMMENT ON TABLE RAZA IS
    'Razas asociadas a cada especie';
COMMENT ON COLUMN RAZA.id_raza IS
    'Identificador unico de la raza';
COMMENT ON COLUMN RAZA.id_especie IS
    'FK a la especie a la que pertenece la raza';

CREATE TABLE DIRECCION (
    id_direccion NUMBER(10) PRIMARY KEY,
    ciudad VARCHAR2(50),
    barrio VARCHAR2(50),
    calle VARCHAR2(50),
    numero VARCHAR2(20)
);


COMMENT ON TABLE DIRECCION IS
    'Direcciones usadas por personas y sucursales';
COMMENT ON COLUMN DIRECCION.id_direccion IS
    'Identificador unico de la direccion';
COMMENT ON COLUMN DIRECCION.ciudad IS
    'Ciudad de la direccion';

CREATE TABLE PERSONA (
    id_persona NUMBER(10) PRIMARY KEY,
    id_direccion NUMBER(10),
    nombres VARCHAR2(100),
    apellidos VARCHAR2(100),
    documento VARCHAR2(50) UNIQUE,
    correo VARCHAR2(100) UNIQUE,
    telefono VARCHAR2(20),
    FOREIGN KEY (id_direccion) REFERENCES DIRECCION(id_direccion)
);

CREATE INDEX idx_persona_direccion
ON PERSONA(id_direccion);

COMMENT ON TABLE PERSONA IS
    'Personas registradas en el sistema';
COMMENT ON COLUMN PERSONA.id_persona IS
    'Identificador unico de la persona';
COMMENT ON COLUMN PERSONA.id_direccion IS
    'FK a la direccion de la persona';

CREATE TABLE ADOPTANTE (
    id_adoptante NUMBER(10) PRIMARY KEY,
    id_persona NUMBER(10) UNIQUE,
    tipo_vivienda VARCHAR2(50),
    FOREIGN KEY (id_persona) REFERENCES PERSONA(id_persona)
);


CREATE INDEX idx_adoptante_persona
ON ADOPTANTE(id_persona);

COMMENT ON TABLE ADOPTANTE IS
    'Personas interesadas en adoptar una mascota';
COMMENT ON COLUMN ADOPTANTE.id_adoptante IS
    'Identificador unico del adoptante';
COMMENT ON COLUMN ADOPTANTE.id_persona IS
    'FK a la persona registrada';
COMMENT ON COLUMN ADOPTANTE.tipo_vivienda IS
    'Tipo de vivienda (Casa, Apartamento, Finca)';

CREATE TABLE VOLUNTARIO (
    id_voluntario NUMBER(10) PRIMARY KEY,
    id_persona NUMBER(10) UNIQUE,
    disponibilidad VARCHAR2(50),
    area_apoyo VARCHAR2(50),
    FOREIGN KEY (id_persona) REFERENCES PERSONA(id_persona)
);

CREATE INDEX idx_voluntario_persona
ON VOLUNTARIO(id_persona);

COMMENT ON COLUMN VOLUNTARIO.disponibilidad IS
    'Horario de disponibilidad';
COMMENT ON COLUMN VOLUNTARIO.area_apoyo IS
    'Area en la que da apoyo y que se especializa';

CREATE TABLE REFUGIO (
    id_refugio NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(100),
    telefono VARCHAR2(20)
);

COMMENT ON TABLE REFUGIO IS
    'Organizaciones de bienestar animal';

CREATE TABLE SUCURSAL (
    id_sucursal NUMBER(10) PRIMARY KEY,
    id_refugio NUMBER(10),
    id_direccion NUMBER(10),
    nombre VARCHAR2(100),
    FOREIGN KEY (id_refugio) REFERENCES REFUGIO(id_refugio),
    FOREIGN KEY (id_direccion) REFERENCES DIRECCION(id_direccion)
);

CREATE INDEX idx_sucursal_direccion
ON SUCURSAL(id_direccion);
CREATE INDEX idx_sucursal_refugio
ON SUCURSAL(id_refugio);


COMMENT ON COLUMN SUCURSAL.id_refugio IS
    'FK al refugio al que pertenece';
COMMENT ON COLUMN SUCURSAL.id_direccion IS
    'FK a la direccion de la sucursal';
COMMENT ON COLUMN SUCURSAL.nombre IS
    'Nombre de la sucursal';

CREATE TABLE ANIMAL (
    id_animal NUMBER(10) PRIMARY KEY,
    id_raza NUMBER(10),
    id_sucursal NUMBER(10),
    nombre VARCHAR2(100),
    estado VARCHAR2(50) CHECK (estado IN ('Disponible','No disponible')),
    FOREIGN KEY (id_raza) REFERENCES RAZA(id_raza),
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSAL(id_sucursal)
);

CREATE INDEX idx_animal_raza
ON ANIMAL(id_raza);
CREATE INDEX idx_animal_sucursal
ON ANIMAL(id_sucursal);

COMMENT ON TABLE ANIMAL IS
    'Animales registrados en la plataforma para adopcion';
COMMENT ON COLUMN ANIMAL.id_animal IS
    'Identificador unico del animal';
COMMENT ON COLUMN ANIMAL.id_raza IS
    'FK a la raza del animal';

CREATE TABLE VACUNA (
    id_vacuna NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(50)
);


COMMENT ON TABLE VACUNA IS
    'Vacunas disponibles para los animales';
COMMENT ON COLUMN VACUNA.id_vacuna IS
    'Identificador unico de la vacuna';
COMMENT ON COLUMN VACUNA.nombre IS
    'Nombre de la vacuna';

CREATE TABLE ANIMAL_VACUNA (
    id_animal NUMBER(10),
    id_vacuna NUMBER(10),
    FECHA_APLICACION DATE,
    PRIMARY KEY (id_animal, id_vacuna),
    FOREIGN KEY (id_animal) REFERENCES ANIMAL(id_animal),
    FOREIGN KEY (id_vacuna) REFERENCES VACUNA(id_vacuna)
);

CREATE INDEX idx_animal_vacuna_animal
ON ANIMAL_VACUNA(id_animal);
CREATE INDEX idx_animal_vacuna_vacuna
ON ANIMAL_VACUNA(id_vacuna);

COMMENT ON TABLE ANIMAL_VACUNA IS
    'Registro de vacunas aplicadas a cada animal';
COMMENT ON COLUMN ANIMAL_VACUNA.id_animal IS
    'FK al animal vacunado';
COMMENT ON COLUMN ANIMAL_VACUNA.id_vacuna IS
    'FK a la vacuna aplicada';

CREATE TABLE SOLICITUD_ADOPCION (
    id_solicitud NUMBER(10) PRIMARY KEY,
    id_adoptante NUMBER(10),
    id_animal NUMBER(10),
    estado VARCHAR2(50) CHECK (estado IN ('Pendiente','Aprobada','Rechazada')),
    FOREIGN KEY (id_adoptante) REFERENCES ADOPTANTE(id_adoptante),
    FOREIGN KEY (id_animal) REFERENCES ANIMAL(id_animal)
);

CREATE INDEX idx_solicitud_adoptante
ON SOLICITUD_ADOPCION(id_adoptante);
CREATE INDEX idx_solicitud_animal
ON SOLICITUD_ADOPCION(id_animal);

COMMENT ON COLUMN SOLICITUD_ADOPCION.id_adoptante IS
    'FK al adoptante que solicita';
COMMENT ON COLUMN SOLICITUD_ADOPCION.id_animal IS
    'FK al animal solicitado';
COMMENT ON COLUMN SOLICITUD_ADOPCION.estado IS
    'Estado: Pendiente, Aprobada o Rechazada';

CREATE TABLE VISITA (
    id_visita NUMBER(10) PRIMARY KEY,
    id_solicitud NUMBER(10),
    fecha DATE,
    FOREIGN KEY (id_solicitud) REFERENCES SOLICITUD_ADOPCION(id_solicitud)
);

CREATE INDEX idx_visita_solicitud
ON VISITA(id_solicitud);

COMMENT ON COLUMN VISITA.id_solicitud IS
    'FK a la solicitud relacionada';
COMMENT ON COLUMN VISITA.fecha IS
    'Fecha de la visita';


CREATE TABLE ADOPCION (
    id_adopcion NUMBER(10) PRIMARY KEY,
    id_solicitud NUMBER(10) UNIQUE,
    estado VARCHAR2(50),
    FOREIGN KEY (id_solicitud) REFERENCES SOLICITUD_ADOPCION(id_solicitud)
);

CREATE INDEX idx_adopcion_solicitud
ON ADOPCION(id_solicitud);

COMMENT ON COLUMN ADOPCION.id_solicitud IS
    'FK unica a la solicitud aprobada';
COMMENT ON COLUMN ADOPCION.estado IS
    'Estado de la adopcion';

CREATE TABLE SEGUIMIENTO (
    id_seguimiento NUMBER(10) PRIMARY KEY,
    id_adopcion NUMBER(10),
    observaciones VARCHAR2(200),
    FOREIGN KEY (id_adopcion) REFERENCES ADOPCION(id_adopcion)
);

CREATE INDEX idx_seguimiento_adopcion
ON SEGUIMIENTO(id_adopcion);

COMMENT ON TABLE SEGUIMIENTO IS
    'Seguimientos post-adopcion de las mascotas adoptadas';
COMMENT ON COLUMN SEGUIMIENTO.id_seguimiento IS
    'Identificador unico del seguimiento';
COMMENT ON COLUMN SEGUIMIENTO.id_adopcion IS
    'FK a la adopcion asociada';
COMMENT ON COLUMN SEGUIMIENTO.observaciones IS
    'Observaciones del seguimiento';

CREATE TABLE CAMPANIA (
    id_campania NUMBER(10) PRIMARY KEY,
    id_refugio NUMBER(10),
    nombre VARCHAR2(100),
    meta_recaudo NUMBER(10),
    FOREIGN KEY (id_refugio) REFERENCES REFUGIO(id_refugio)
);

CREATE INDEX idx_campania_refugio
ON CAMPANIA(id_refugio);

COMMENT ON TABLE CAMPANIA IS
    'Campanas organizadas por los refugios';
COMMENT ON COLUMN CAMPANIA.id_campania IS
    'Identificador unico de la campana';
COMMENT ON COLUMN CAMPANIA.id_refugio IS
    'FK al refugio que organiza la campana';

CREATE TABLE VOLUNTARIO_CAMPANIA (
    id_voluntario NUMBER(10),
    id_campania NUMBER(10),
    rol VARCHAR2(50),
    horas_aportadas NUMBER(10),
    PRIMARY KEY (id_voluntario, id_campania),
    FOREIGN KEY (id_voluntario) REFERENCES VOLUNTARIO(id_voluntario),
    FOREIGN KEY (id_campania) REFERENCES CAMPANIA(id_campania)
);

CREATE INDEX idx_voluntario_campania_voluntario
ON VOLUNTARIO_CAMPANIA(id_voluntario);
CREATE INDEX idx_voluntario_campania_campania
ON VOLUNTARIO_CAMPANIA(id_campania);


COMMENT ON COLUMN VOLUNTARIO_CAMPANIA.id_voluntario IS
    'FK al voluntario participante';
COMMENT ON COLUMN VOLUNTARIO_CAMPANIA.id_campania IS
    'FK a la campana en la que participa';
COMMENT ON COLUMN VOLUNTARIO_CAMPANIA.rol IS
    'Lo que va a hacer el voluntario en la campana';

CREATE TABLE DONACION (
    id_donacion NUMBER(10) PRIMARY KEY,
    id_persona NUMBER(10),
    id_refugio NUMBER(10),
    monto NUMBER(10) CHECK (monto > 0),
    FOREIGN KEY (id_persona) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (id_refugio) REFERENCES REFUGIO(id_refugio)
);

CREATE INDEX idx_donacion_persona
ON DONACION(id_persona);
CREATE INDEX idx_donacion_refugio
ON DONACION(id_refugio);

COMMENT ON TABLE DONACION IS
    'Donaciones realizadas por personas a refugios';
COMMENT ON COLUMN DONACION.id_donacion IS
    'Identificador unico de la donacion';
COMMENT ON COLUMN DONACION.id_persona IS
    'FK a la persona donante';
COMMENT ON COLUMN DONACION.id_refugio IS
    'FK al refugio beneficiado';
COMMENT ON COLUMN DONACION.monto IS
    'Monto de la donacion (mayor a 0)';