# Creo la base de datos

CREATE DATABASE parquimetros;

# Selecciono la base de datos

USE parquimetros;

#-------------------------------------------------
# Creación de tablas para las Entidades

CREATE TABLE conductores (
 dni INT(8) UNSIGNED NOT NULL, 
 nombre VARCHAR(45) NOT NULL, 
 apellido VARCHAR(45) NOT NULL,
 direccion VARCHAR(45) NOT NULL,
 telefono VARCHAR(45) NOT NULL,
 registro VARCHAR(45) NOT NULL,
 
 CONSTRAINT pk_conductores 
 PRIMARY KEY (dni)

) ENGINE=InnoDB;

CREATE TABLE automoviles (
 patente VARCHAR(6) NOT NULL, 
 marca VARCHAR(45) NOT NULL, 
 modelo VARCHAR(45) NOT NULL,
 color VARCHAR(45) NOT NULL,
 dni INT(8) UNSIGNED NOT NULL,
 
 
 CONSTRAINT pk_automoviles 
 PRIMARY KEY (patente),

 CONSTRAINT fk_automoviles_conductores
 FOREIGN KEY (dni) REFERENCES conductores(dni)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE tipos_tarjeta(
    tipo VARCHAR (25) NOT NULL,
    descuento FLOAT(3,2) NOT NULL,

    CONSTRAINT chk_descuento CHECK (descuento >= 0 AND descuento <= 1),

    CONSTRAINT pk_tipos_tarjeta
    PRIMARY KEY (tipo)

) ENGINE=InnoDB;

#-------------------------------------------------
# Creación de tablas para las relaciones

CREATE TABLE asociado_con(
    # /* id_asociado_con, con o sin autoincrement??? */
    id_asociado_con INT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    legajo INT(8) UNSIGNED NOT NULL,
    calle  VARCHAR(45) NOT NULL,
    altura INT(5) UNSIGNED NOT NULL,
    dia VARCHAR(2) NOT NULL,
    # /* habría que restringir que SÓLO tomen los valores M o T? */
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
    numero INT(20) UNSIGNED NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    patente VARCHAR(6) NOT NULL,
    # /* id_asociado_con, con o sin autoincrement??? */
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
