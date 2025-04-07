/*Guía 6*/
USE JurassicPark
GO

/*Procedimientos almacenados*/
/*1*/
CREATE PROC getAlumnosReales
@codigoGuia INT 
AS
BEGIN
SELECT SUM(RTV.cantidad_alumnos_reales) AS TotalAlumnosReales
FROM Reserva_tipo_visita AS RTV
WHERE RTV.Guia_idGuia = @codigoGuia
RETURN @codigoGuia
END;
GO

/*2*/
CREATE PROC ingresoNuevaEscuela
@codigoEscuela INT,
@nombreEscuela VARCHAR(45),
@domicilioEscuela VARCHAR(45)
AS
BEGIN
INSERT INTO Escuela (idEscuela, nombre, calle_escuela)
VALUES (@codigoEscuela, @nombreEscuela, @domicilioEscuela)
END;
GO

/*3*/
CREATE PROC apellidosGuiasFiltro @filtroApellido VARCHAR(45)
AS
BEGIN
SELECT apellido_guia
FROM Guia
WHERE apellido_guia LIKE CONCAT(@filtroApellido, '%')
END;
GO

/*Triggers*/
/*4*/
CREATE TRIGGER borrarEscuela ON Escuela
AFTER DELETE
AS
BEGIN
DELETE FROM Telefono_Escuela
WHERE Escuela_idEscuela IN (SELECT idEscuela 
							FROM deleted)
END;
GO

/*5*/
CREATE TRIGGER actualizarCodigoGuia ON Guia
AFTER UPDATE
AS
BEGIN
IF UPDATE(idGuia)
	BEGIN
	UPDATE Reserva_tipo_visita
	SET Guia_idGuia = (SELECT idGuia 
						FROM inserted)
	WHERE Guia_idGuia = (SELECT idGuia
						FROM deleted)
	END
END;
GO

/*6*/
CREATE TRIGGER verificarExistenciaCodigo ON Telefono_Escuela
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (SELECT idEscuela
				FROM Escuela
				WHERE idEscuela IN(SELECT Escuela_idEscuela
									FROM inserted))
				BEGIN
				INSERT INTO Telefono_Escuela(codigo_area, nro, Escuela_idEscuela)
				SELECT codigo_area, nro, Escuela_idEscuela
				FROM inserted
				END
	ELSE
	BEGIN
	PRINT 'El código de escuela no existe. Intente nuevamente con un código válido'
	END
END;
GO

/*Procedimientos almacenados y triggers*/
/*7*/
CREATE PROC insertarEscuelasSecuencial
AS
BEGIN
DECLARE @i INT = 1;
WHILE @i<=26
BEGIN
	INSERT INTO Escuela(idEscuela, nombre, calle_escuela)
	VALUES (@i, CONCAT('NomEscuela',@i), CONCAT('DirEscuela',@i))
	SET @i = @i+1
	END
END;
GO

/*8*/
CREATE PROC insertGuiaValido
@codigoGuia INT,
@nombre VARCHAR(250),
@apellido VARCHAR(50),
@sueldo FLOAT,
@domicilio VARCHAR(50),
@UserID CHAR(50),
@Password CHAR(50)
AS
BEGIN
	IF EXISTS(SELECT 1 
				FROM USERID 
				WHERE UserID = @UserID
				AND passwordUser = @Password)
	BEGIN 
	INSERT INTO Guia(idGuia, nombre, apellido_guia, Guia_idGuia, sueldo_hora, domicilio_guia)
	VALUES (@codigoGuia, @nombre, @apellido, @codigoGuia, @sueldo, @domicilio)
	END
	ELSE
	BEGIN
	PRINT 'Datos inválidos, intente nuevamente.'
	END
END;
GO

/*9*/
CREATE TRIGGER insertarAuditoria ON Reserva_tipo_visita
AFTER INSERT
AS
BEGIN
	INSERT INTO Auditoria(Reserva_idReserva, cantidad_alumnos_reales, fecha_insercion)
	SELECT Reserva_idReserva, cantidad_alumnos_reales, GETDATE()
	FROM inserted
	WHERE cantidad_alumnos_reales > 50
	END;
GO