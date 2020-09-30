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

