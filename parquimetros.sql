# Creo la base de datos

CREATE DATABASE parquimetros;

# Selecciono la base de datos

USE parquimetros;

# ----------------------------------------------------------------------------
# Creación de tablas para las Entidades

CREATE TABLE conductores (
    dni INT UNSIGNED NOT NULL, 
    nombre VARCHAR(45) NOT NULL, 
    apellido VARCHAR(45) NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    registro VARCHAR(45) NOT NULL,
 
    CONSTRAINT pk_conductores 
    PRIMARY KEY (dni)

)ENGINE=InnoDB;


CREATE TABLE automoviles (
    patente VARCHAR(6) NOT NULL, 
    marca VARCHAR(45) NOT NULL, 
    modelo VARCHAR(45) NOT NULL,
    color VARCHAR(45) NOT NULL,
    dni INT UNSIGNED NOT NULL,
 
    CONSTRAINT pk_automoviles 
    PRIMARY KEY (patente),

    CONSTRAINT fk_automoviles_conductores
    FOREIGN KEY (dni) REFERENCES conductores(dni)
        ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE tarjeta (
    id_tarjeta INT UNSIGNED NOT NULL AUTO_INCREMENT,
    saldo FLOAT (5,2) NOT NULL;
    tipo VARCHAR (20) NOT NULL,
    patente VARCHAR(6) NOT NULL,

    CONSTRAINT pk_tarjeta
    PRIMARY KEY (id_tarjeta),

    CONSTRAINT fk_tarjeta_Automoviles
    FOREIGN KEY (patente) REFERENCES automoviles(patente)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_tarjeta_tipos_tarjeta
    FOREIGN KEY (tipo) REFERENCES tipos_tarjeta(tipo)
        ON DELETE RESTRICT ON UPDATE CASCADE 
) Engine=InnoDB;


CREATE TABLE tipos_tarjeta (
    tipo VARCHAR (25) NOT NULL,
    descuento FLOAT(3,2) NOT NULL,

    CONSTRAINT chk_descuento CHECK (descuento >= 0 AND descuento <= 1),

    CONSTRAINT pk_tipos_tarjeta
    PRIMARY KEY (tipo)
) ENGINE=InnoDB;

CREATE TABLE inspectores(
    legajo INT UNSIGNED NOT NULL,
    dni INT UNSIGNED NOT NULL,
    nombre VARCHAR(20) UNSIGNED NOT NULL,
    apellido VARCHAR(20) UNSIGNED NOT NULL,
    password VARCHAR(32) NOT NULL,

    
)


# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# Creación de tablas para las relaciones

CREATE TABLE asociado_con (
    id_asociado_con INT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    legajo INT UNSIGNED NOT NULL,
    calle  VARCHAR(45) NOT NULL,
    altura INT UNSIGNED NOT NULL,
    # dia ENUM ('do','lu','ma','mi','ju','vi','sa')
    dia VARCHAR(2) NOT NULL,
    turno VARCHAR(1) NOT NULL,

    CONSTRAINT chk_turno CHECK (turno = 'M' OR turno = 'T'),

    CONSTRAINT pk_asociado_con
    PRIMARY KEY (id_asociado_con),

    CONSTRAINT fk_asociado_con_inspectores
    FOREIGN KEY (legajo) REFERENCES inspectores(legajo)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_asociado_con_ubicaciones
    FOREIGN KEY (calle, altura) REFERENCES ubicaciones(calle, altura)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

# /* OJO! ver pluralidad (multa o multas?) */
CREATE TABLE multas (
    numero INT UNSIGNED NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    patente VARCHAR(6) NOT NULL,
    # /* id_asociado_con, VA SIN AUTOINCREMENT */
    id_asociado_con INT(20) UNSIGNED NOT NULL, 

    CONSTRAINT pk_multas
    PRIMARY KEY (numero),

    CONSTRAINT fk_multas_automoviles 
    FOREIGN KEY (patente) REFERENCES automoviles(patente) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
  
 
    CONSTRAINT fk_multas_asociado_con 
    FOREIGN KEY (id_asociado_con) REFERENCES asociado_con(id_asociado_con)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;


# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# Creación de Vistas

CREATE VIEW estacionados AS 
   SELECT L.calle, L.altura, P.patente
   FROM (Pertenece P NATURAL JOIN Estacionamientos E) NATURAL JOIN Localizado_en L
   WHERE Fecha_ent < Hora_ent AND Fecha_sal = NULL AND Hora_sal = NULL;

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

# Creación de usuarios y otorgamiento de privilegios


CREATE USER 'admin'@'localhost'  IDENTIFIED BY 'admin';

# El usuario admin solamente podrá conectarse desde la computadora que corre el servidor (localhost).

GRANT ALL PRIVILEGES ON parquimetros.* TO 'admin'@'localhost' WITH GRANT OPTION;

# El usuario 'admin' tiene acceso total a todas las tablas de 
# la B.D. parquimetros y puede crear nuevos usuarios y otorgar privilegios.

#--

CREATE USER 'venta'@% IDENTIFIED by 'venta';

# El usuario venta podrá conectarse desde cualquiera computadora.

GRANT SELECT,INSERT ON parquimetros.tarjeta TO 'venta'@%;

# El usuario venta solamente puede acceder a la tabla tarjeta con permiso para seleccionar e insertar

#-- 

CREATE USER 'inspector'@% IDENTIFIED BY 'inspector';

# El usuario inspector podrá conectarse desde cualquier computadora.

GRANT SELECT ON parquimetros.estacionados, parquimetros.Parquimetros TO 'inspector'@%;
GRANT INSERT ON Multas TO 'inspector'@%; 
# /* COMPLETAR */
