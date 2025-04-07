USE JurassicPark
GO

CREATE TABLE Escuela (
	idEscuela INT IDENTITY(1,1) CONSTRAINT pkEscuela PRIMARY KEY,
	domicilio VARCHAR(45) NOT NULL,
	nombre VARCHAR(45) NOT NULL,
	email VARCHAR(250) NOT NULL
);

CREATE TABLE Guia (
	idGuia INT IDENTITY (1,1) CONSTRAINT pkGuia PRIMARY KEY,
	nombre VARCHAR(250),
	Guia_idGuia INT CONSTRAINT fkGuia FOREIGN KEY REFERENCES Guia
);

CREATE TABLE Reserva (
	idReserva INT IDENTITY (1,1) CONSTRAINT pkReserva PRIMARY KEY,
	dia DATE NOT NULL,
	hora INT NOT NULL,
	Escuela_idEscuela INT CONSTRAINT fkReserva FOREIGN KEY REFERENCES Escuela
);

CREATE TABLE Tipo_visita (
	idTipo_visitas INT IDENTITY (1,1) CONSTRAINT pkTipoVisitas PRIMARY KEY,
	descripcion VARCHAR(250) NOT NULL,
	arancel_por_alumno FLOAT NOT NULL
);

CREATE TABLE Telefono_Escuela (
	codigo_area INT,
	nro INT,
	Escuela_idEscuela INT CONSTRAINT fkTel FOREIGN KEY REFERENCES Escuela,
	CONSTRAINT pkTel PRIMARY KEY (codigo_area, nro),
);

CREATE TABLE Grado(
	idGrado INT IDENTITY (1,1) CONSTRAINT pkGrado PRIMARY KEY,
	descripcion VARCHAR(45) NOT NULL,
);

CREATE TABLE Reserva_por_grado (
	Grado_idGrado INT CONSTRAINT fkReservaPorGrado FOREIGN KEY REFERENCES Grado,
	Reserva_tipo_visita_Reserva_idReserva INT,
	Reserva_tipo_visita_Tipo_visitas_idTipo_visitas INT,
);

CREATE TABLE Reserva_tipo_visita (
	Reserva_idReserva INT NOT NULL,
	Tipo_visitas_idTipo_visitas INT NOT NULL,
	Cantidad_alumnos_reservado INT NOT NULL,
	arancel_por_alumno FLOAT NOT NULL,
	cantidad_alumnos_reales INT NOT NULL,
	Guia_idGuia INT NOT NULL
);

ALTER TABLE Reserva_tipo_visita ADD CONSTRAINT pkRTV PRIMARY KEY (Reserva_idReserva,Tipo_visitas_idTipo_visitas);
ALTER TABLE Reserva_tipo_visita ADD CONSTRAINT fkRTV1 FOREIGN KEY (Guia_idGuia) REFERENCES Guia;
ALTER TABLE Reserva_tipo_visita ADD CONSTRAINT fkRTV2 FOREIGN KEY (Reserva_idReserva) REFERENCES Reserva;
ALTER TABLE Reserva_tipo_visita ADD CONSTRAINT fkRTV3 FOREIGN KEY (Tipo_visitas_idTipo_visitas) REFERENCES Tipo_visita;

ALTER TABLE Guia ADD sueldo_hora FLOAT;

ALTER TABLE Escuela ADD CONSTRAINT unique_nombre UNIQUE (nombre);

CREATE TABLE Distrito_Escolar (
	idDistrito_escolar INT CONSTRAINT pkDistritoEscolar PRIMARY KEY,
	nombre VARCHAR(45),
)

ALTER TABLE Escuela ADD codigo_distrito_escolar INT CONSTRAINT fkEscuela FOREIGN KEY REFERENCES Distrito_Escolar;

ALTER TABLE Escuela DROP COLUMN domicilio;

ALTER TABLE Escuela ADD calle_escuela VARCHAR(45), altura_escuela INT;

ALTER TABLE Guia ADD domicilio_guia VARCHAR(45);

DROP TABLE Telefono_Escuela;

CREATE TABLE Email_Escuela (
	idEmail INT NOT NULL,
	Escuela_idEscuela INT NOT NULL,
	fecha_creacion DATE NOT NULL,
	tipo_email VARCHAR(45) NOT NULL
)

ALTER TABLE Email_Escuela ADD CONSTRAINT pkEmailEscuela PRIMARY KEY (idEmail);

ALTER TABLE Guia ALTER COLUMN nombre VARCHAR(45) NOT NULL;

ALTER TABLE Escuela ADD CONSTRAINT unique_calle_escuela UNIQUE (calle_escuela), CONSTRAINT unique_altura_escuela UNIQUE (altura_escuela);

