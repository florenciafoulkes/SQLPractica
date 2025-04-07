USE [JurassicPark]
GO

CREATE NONCLUSTERED INDEX ind_idEsc ON Reserva (Escuela_idEscuela);

DROP INDEX Reserva.ind_idEsc;

CREATE NONCLUSTERED INDEX ind_cantAl ON Reserva_tipo_visita (Cantidad_alumnos_reservado);

ALTER TABLE Reserva_tipo_Visita DROP CONSTRAINT fkRTV1;
ALTER TABLE Guia DROP CONSTRAINT fkGuia;
ALTER TABLE Guia DROP CONSTRAINT pkGuia;

CREATE CLUSTERED INDEX ind_Ap_Nom ON Guia (nombre, apellido_guia);

CREATE NONCLUSTERED INDEX ind_Fecha_Hora ON Reserva (dia, hora) WITH (FILLFACTOR = 80);

CREATE LOGIN jPerez WITH PASSWORD = 'juanperez';
CREATE USER jPerez FOR LOGIN jPerez;

CREATE LOGIN aFernandez WITH PASSWORD = 'aliciafernandez';
CREATE USER aFernandez FOR LOGIN aFernandez;

GRANT INSERT, UPDATE ON Email_Escuela TO jPerez, aFernandez;

REVOKE INSERT, UPDATE ON Email_Escuela FROM jPerez, aFernandez;

GRANT CREATE TABLE TO jPerez;

REVOKE SELECT ON Escuela TO public;

DROP INDEX Guia.ind_Ap_Nom;

CREATE UNIQUE CLUSTERED INDEX ind_ApNom ON Guia (nombre, apellido_Guia);

CREATE ROLE Cordoba;
ALTER AUTHORIZATION ON SCHEMA::db_owner TO [Cordoba];

GRANT SELECT ON Reserva_tipo_visita TO Cordoba;

EXEC sp_addrolemember Cordoba, jPerez;

DENY SELECT ON Reserva_tipo_visita(arancel_por_alumno) TO jPerez;

CREATE ROLE ADM;
GRANT ALL TO ADM;

EXEC sp_addrolemember ADM, aFernandez;
DENY BACKUP DATABASE, BACKUP LOG TO aFernandez;
