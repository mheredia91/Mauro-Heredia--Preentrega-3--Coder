-- Pre-entrega M5: Consultas con JOINs - Mauro Heredia
USE Ventas_Tech_DB

-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Propósito: unir las 4 tablas en una vista única por venta, fuente de datos para Power BI.
SELECT
    v.id_venta,
    c.nombre,
    v.cantidad
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente;

SELECT 
v.fecha_venta,
c.nombre, 
c.ciudad,
p.nombre_producto,
cat.nombre_categoria,
v.cantidad,
v.precio_unitario,
v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c     ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria

-- CONSULTA 2:  Clientes sin ventas
-- Propósito: identificar clientes registrados que nunca compraron (para el área de CRM).

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Resultado: 0 filas. Los 5 clientes registrados realizaron al menos una compra,
-- por lo que hoy no hay clientes inactivos para una campaña de reactivación.

--CONSULTA 3: PRODUCTOS SIN VENTAS
-- Propósito: identificar artículos del catálogo sin movimiento (para el área de producto).

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto  = v.id_producto
WHERE v.id_venta IS NULL;

-- Resultado: 0 filas. Los 6 productos del catálogo registraron al menos una venta,
-- por lo que no hay artículos sin movimiento.

--CONSULTA 4
-- Propósito: comparar la facturación entre la primera y la segunda quincena de marzo.
-- Criterio: la base no tiene columna de canal, por eso el origen se separa por período.

SELECT
    fecha_venta,
    cantidad * precio_unitario AS total_venta,
    'Primera quincena' AS periodo
FROM ventas
WHERE fecha_venta <= '2024-03-10'
UNION ALL
SELECT
    fecha_venta,
    cantidad * precio_unitario AS total_venta,
    'Segunda quincena' AS periodo

WITH ventas_por_periodo AS (
    SELECT
    fecha_venta,
    cantidad * precio_unitario AS total_venta,
    'Primera quincena' AS periodo
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'
    UNION ALL
    SELECT
    fecha_venta,
    cantidad * precio_unitario AS total_venta,
    'Segunda quincena' AS periodo
    FROM ventas
    WHERE fecha_venta > '2024-03-10' 
)
SELECT
    periodo,
    SUM(total_venta) AS total_facturado,
    COUNT(*) AS cantidad_ventas
FROM ventas_por_periodo
GROUP BY periodo;

