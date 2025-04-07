/*Guia 5*/
USE JurassicPark

/*2*/
SELECT E.idEscuela 
FROM Escuela AS E
WHERE (SELECT SUM(RTV.cantidad_alumnos_reales)
		FROM Reserva AS R INNER JOIN Reserva_tipo_visita AS RTV ON R.idReserva = RTV.Reserva_idReserva
		WHERE R.Escuela_idEscuela = E.idEscuela) > 400;

/*4*/
SELECT G.idGuia, G.nombre, G.apellido_guia
FROM Guia AS G
WHERE G.idGuia IN (SELECT RTV.Guia_idGuia
					FROM Reserva_tipo_visita AS RTV
					GROUP BY RTV.Guia_idGuia
					HAVING COUNT(DISTINCT RTV.Tipo_visitas_idTipo_visitas) > 10
					AND SUM(RTV.cantidad_alumnos_reales) > 200)

/*6*/
SELECT G.idGuia, G.nombre, G.apellido_guia
FROM Guia AS G INNER JOIN Reserva_tipo_visita AS RTV ON G.idGuia = RTV.Guia_idGuia
WHERE RTV.cantidad_alumnos_reales >= ANY (SELECT SUM(RTV2.cantidad_alumnos_reales)*0.40
										FROM Reserva_tipo_visita AS RTV2
										WHERE RTV2.Guia_idGuia = G.idGuia
										GROUP BY RTV2.Guia_idGuia)

/*8*/
SELECT E.idEscuela, E.nombre
FROM Escuela AS E INNER JOIN Reserva AS R ON E.idEscuela = R.Escuela_idEscuela
WHERE R.dia IN 
	(SELECT TOP 1 R2.dia
	FROM Reserva AS R2 INNER JOIN Reserva_tipo_visita AS RTV2 ON R2.idReserva = RTV2.Reserva_idReserva
	GROUP BY R2.dia
	ORDER BY SUM(RTV2.cantidad_alumnos_reales) DESC)

/*10*/
SELECT E.nombre 
FROM Escuela E 
WHERE E.idEscuela IN 
	(SELECT R.Escuela_idEscuela 
	FROM Reserva AS R 
	WHERE YEAR(R.dia) LIKE '%2001%' OR YEAR(R.dia) LIKE '%2002%'
	GROUP BY R.Escuela_idEscuela) 

/*12*/
SELECT E.idEscuela, E.nombre
FROM Escuela AS E
WHERE 
	(SELECT SUM(RTV.cantidad_alumnos_reales * RTV.arancel_por_alumno)
	FROM Reserva_tipo_visita AS RTV 
	INNER JOIN Reserva AS R ON RTV.Reserva_idReserva = R.idReserva
	WHERE R.Escuela_idEscuela = E.idEscuela) > 1900