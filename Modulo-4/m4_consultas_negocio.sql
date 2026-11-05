--Pre-entrega M4: Consultas de negocio - Mauro Heredia
USE Ventas_Tech_DB;
--CONSULTA 1: RESUMEN EJECUTIVO MENSUAL
SELECT YEAR (fecha_venta) AS anio,
	   MONTH (fecha_venta) AS mes,
	   SUM (cantidad * precio_unitario) AS total_facturado,
	   COUNT (id_venta) AS cantidad_pedidos,
	   CAST (AVG(cantidad * precio_unitario) AS DECIMAL (10,2))
				AS ticket_promedio

	FROM ventas
	GROUP BY YEAR (fecha_venta),MONTH (fecha_venta)
	ORDER BY anio,mes;

	-- CONSULTA 2: RANKING DE PRODUCTOS

	SELECT TOP 5 
	    id_producto,
		SUM (cantidad) AS unidades_vendidas,
		SUM (cantidad*precio_unitario) AS total_facturado
		FROM ventas
		GROUP BY id_producto
		ORDER BY total_facturado DESC;

		-- CONSULTA 3: CLIENTES RECURRENTES
		SELECT id_cliente,
			   COUNT (id_venta) AS cantidad_pedidos,
			   SUM (cantidad*precio_unitario) AS total_facturado
			   FROM ventas
			   GROUP BY id_cliente
			   HAVING COUNT (id_venta) > 1;

		-- CONSULTA 4: PRODUCTOS POR ENCIMA O POR DEBAJO DEL PROMEDIO

			WITH totales_producto AS (            -- paso 1: una tabla temporal
             SELECT id_producto, 
              SUM(cantidad * precio_unitario) AS total_facturado
               FROM ventas
  GROUP BY id_producto
)

SELECT id_producto, total_facturado, -- paso 2: comparar
  CASE WHEN total_facturado >= (SELECT AVG(total_facturado) FROM totales_producto)
       THEN 'Por encima' ELSE 'Por debajo'
	 END AS evaluacion_promedio
	FROM totales_producto
	ORDER BY total_facturado DESC

	-- HALLAZGOS--
-- 1. El producto 1 concentra el 56% de la facturación total ($3.600 de $6.444)
--    con solo 3 unidades vendidas: es el que más impacto tiene en los ingresos.
-- 2. Solo 2 de los 6 productos superan el promedio, y los 4 restantes facturan entre $360 y $390, muy parecidos entre sí. 
-- La facturación depende de muy pocos productos.
-- 3. Los 5 clientes son recurrentes (2 pedidos cada uno), pero el gasto está concentrado: los clientes 1 y 5 suman el 74% de la facturación, porque ambos
--    compraron el producto 1.


