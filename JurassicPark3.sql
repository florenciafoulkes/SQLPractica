USE JurassicPark
GO

INSERT INTO Guia (nombre, apellido_guia)
VALUES ('Carlos', 'Lopez');

DELETE FROM Telefono_Escuela;

INSERT INTO Telefono_Escuela (codigo_area, nro, Escuela_idEscuela)
SELECT 1111, 1111, idEscuela FROM Escuela;

UPDATE Reserva
SET dia = '20181223'
WHERE idReserva = 1;

UPDATE Reserva_tipo_visita
SET Guia_idGuia = 2
WHERE Guia_idGuia = 1;

DELETE FROM Guia
WHERE nombre IS NULL;

SELECT COUNT(*) AS TotalReservas
FROM Reserva
WHERE dia > '20040103';

SELECT *
FROM Reserva_tipo_visita
WHERE Cantidad_alumnos_reservado > 20;

SELECT COUNT(DISTINCT Escuela_idEscuela) AS CantidadEscuelas
FROM Reserva
WHERE dia > '20180630';

INSERT INTO Tipo_visita (idTipo_visitas, descripcion, arancel_por_alumno)
SELECT TOP 1 (idTipo_visitas)+1, 'Visita guiada', 150.00
FROM Tipo_visita
ORDER BY idTipo_visitas DESC;

UPDATE Telefono_Escuela
SET nro = '9' + nro;

SELECT TOP 1 *
FROM Reserva
ORDER BY dia DESC;

SELECT dia, COUNT(*) AS TotalReservas
FROM Reserva
GROUP BY dia;

SELECT nombre, apellido_guia 
FROM Guia
WHERE idGuia = (SELECT Guia_idGuia FROM Reserva_tipo_visita GROUP BY Guia_idGuia HAVING COUNT(Reserva_idReserva)>3);