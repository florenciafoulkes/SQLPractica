/*Guía 04*/

USE JurassicPark
/*1*/
SELECT E.nombre, E.calle_escuela, E.altura_escuela, CONCAT(T.codigo_area, '-', T.nro) AS telefono
FROM Escuela AS E LEFT JOIN Telefono_Escuela AS T ON E.idEscuela = T.Escuela_idEscuela
WHERE  T.nro IS NOT NULL;

SELECT E.nombre, CONCAT(E.calle_escuela, ' ', E.altura_escuela) AS domicilio
FROM Escuela AS E LEFT JOIN Telefono_Escuela AS T ON E.idEscuela = T.Escuela_idEscuela
WHERE E.calle_escuela LIKE 'A%' AND T.nro IS NULL;

/*2*/
SELECT R.dia, E.nombre, RTV.Cantidad_alumnos_reservado, G.nombre
FROM ((Escuela AS E INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela) INNER JOIN Reserva_tipo_visita AS RTV ON
R.idReserva = RTV.Reserva_idReserva) INNER JOIN Guia AS G ON RTV.Guia_idGuia = G.idGuia;

/*3*/
SELECT R.dia, R.hora, RTV.cantidad_alumnos_reales, (RTV.cantidad_alumnos_reales*RTV.arancel_por_alumno)*1.21 AS valorTotal
FROM Reserva AS R INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva;

/*4*/
SELECT R.dia, R.hora, TV.descripcion, E.nombre, SUM(RTV.arancel_por_alumno) AS precioFinal
FROM ((Escuela AS E INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela) INNER JOIN Reserva_tipo_visita AS RTV ON
R.idReserva = RTV.Reserva_idReserva) INNER JOIN Tipo_visita AS TV ON TV.idTipo_visitas = RTV.Tipo_visitas_idTipo_visitas
WHERE YEAR(R.dia) = 2024
GROUP BY R.idReserva, E.nombre, TV.descripcion, R.dia, R.hora 
HAVING SUM(RTV.arancel_por_alumno * RTV.Cantidad_alumnos_reservado) > 2500;

/*5*/
SELECT E.nombre
FROM ((Escuela AS E INNER JOIN Reserva AS R ON E.idEscuela = R.idReserva) 
INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva)
INNER JOIN Guia AS G ON RTV.Guia_idGuia = G.idGuia
WHERE G.nombre LIKE '%Cristina%' AND G.apellido_guia LIKE '%Zaluzi%';

/*6*/
SELECT E.nombre, R.dia, COUNT(RTV.Tipo_visitas_idTipo_visitas) AS cantVisitas
FROM Escuela AS E INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela
INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva
WHERE YEAR(R.dia) LIKE '%2024%'
GROUP BY R.idReserva, E.nombre, R.dia
HAVING COUNT(RTV.Tipo_visitas_idTipo_visitas) > 1;

/*7*/
SELECT G.nombre, COUNT(RTV.Tipo_visitas_idTipo_visitas) AS cantVisitas
FROM Guia AS G INNER JOIN Reserva_tipo_visita AS RTV ON G.idGuia = RTV.Guia_idGuia
WHERE RTV.Cantidad_alumnos_reservado > 100
GROUP BY G.nombre
HAVING COUNT(RTV.Tipo_visitas_idTipo_visitas) > 10;

/*8*/
SELECT R.idReserva, R.dia, SUM(RTV.Cantidad_alumnos_reservado) AS alumnosPorVisita, E.nombre, G.nombre
FROM Escuela AS E INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela
INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva
INNER JOIN Guia AS G ON RTV.Guia_idGuia = G.idGuia
GROUP BY R.idReserva, R.dia, RTV.Tipo_visitas_idTipo_visitas, E.nombre, G.nombre;

/*9*/
SELECT TV.idTipo_visitas, TV.descripcion, COUNT(RTV.Tipo_visitas_idTipo_visitas) AS cantidadAsignada
FROM Tipo_visita AS TV INNER JOIN Reserva_tipo_visita AS RTV ON TV.idTipo_visitas = RTV.Tipo_visitas_idTipo_visitas
GROUP BY TV.idTipo_visitas, TV.descripcion
HAVING COUNT(RTV.Tipo_visitas_idTipo_visitas) > 5;

/*10*/
SELECT G.nombre, G.apellido_guia
FROM Guia AS G LEFT JOIN Reserva_tipo_visita AS RTV ON G.idGuia = RTV.Guia_idGuia
WHERE RTV.Guia_idGuia IS NULL;

/*11*/
SELECT G.nombre, G.apellido_guia, E.nombre
FROM Guia AS G INNER JOIN Reserva_tipo_visita AS RTV ON G.idGuia = RTV.Guia_idGuia
INNER JOIN Reserva AS R ON RTV.Reserva_idReserva = R.idReserva
INNER JOIN Escuela AS E ON R.Escuela_idEscuela = E.idEscuela
WHERE E.nombre NOT LIKE 'E%';

/*12*/
SELECT E.nombre, SUM(RTV.cantidad_alumnos_reales) AS reales, SUM(RTV.Cantidad_alumnos_reservado) AS reservados
FROM (Escuela AS E 
INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela)
INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva
GROUP BY E.nombre, R.idReserva
HAVING SUM(RTV.cantidad_alumnos_reales) = SUM(RTV.Cantidad_alumnos_reservado);

/*13*/
SELECT E.nombre
FROM Escuela E INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela
WHERE R.dia = '2024-10-30' AND R.hora < 9
UNION ALL
SELECT G.apellido_guia
FROM Guia AS G
WHERE G.nombre LIKE 'V%'
ORDER BY 1 DESC;

/*14*/
SELECT E.nombre, CONCAT(TE.codigo_area, '-', TE.nro) AS telefono
FROM ((((Escuela AS E INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela)
INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva)
INNER JOIN Tipo_visita AS TV ON RTV.Tipo_visitas_idTipo_visitas = TV.idTipo_visitas)
INNER JOIN Telefono_Escuela AS TE ON E.idEscuela = TE.Escuela_idEscuela)
WHERE TV.descripcion LIKE '%Los Mamuts en Familia%';

/*15*/
SELECT G.idGrado, G.descripcion, MAX(R.dia) AS ultFecha
FROM Grado AS G INNER JOIN Reserva_por_grado AS RPG ON G.idGrado = RPG.Grado_idGrado
INNER JOIN Reserva_tipo_visita AS RTV ON RPG.Reserva_tipo_visita_Reserva_idReserva = RTV.Reserva_idReserva
INNER JOIN Reserva AS R ON RTV.Reserva_idReserva = R.idReserva
GROUP BY G.idGrado, G.descripcion;

/*16*/
CREATE TABLE Guia_Performance(
	idGuia INT CONSTRAINT pkGuiaPerformance PRIMARY KEY,
	nombre VARCHAR(250),
	total_reservado INT,
	total_reales INT)

INSERT INTO Guia_Performance
SELECT G.idGuia, G.nombre, SUM(RTV.Cantidad_alumnos_reservado) AS reservados, SUM(RTV.cantidad_alumnos_reales) AS reales
FROM Reserva AS R INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva
INNER JOIN Guia AS G ON RTV.Guia_idGuia = G.idGuia
WHERE YEAR(R.dia) = 2003
GROUP BY G.idGuia, G.nombre;