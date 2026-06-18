USE coffeshopdb;

/*	
	-------------------------------------------------------------------------------------------
	PRIMEROS CAMBIOS BASICOS PARA EL EDA (cosas que quería hacer mientras hacia lo de python)
    -------------------------------------------------------------------------------------------
*/	

/*
	HACER QUERY PARA ABRIR LA TINEDA DE NOJA Y METER EMPLEADOS NUEVOS
*/
SELECT * FROM stores;

UPDATE stores
SET store_status = TRUE
WHERE store_id = 3;

-- actualizo los datos del 999
UPDATE employees
SET employee_name = 'Carlos Navarro',
	employee_hiring_date = '2023-02-15',
	employee_position = 'Barista',
	employee_dni = '99999999Z'
WHERE employee_id = 999;

-- añado 2 empleadas nuevas
INSERT INTO employees
(employee_name, employee_hiring_date, employee_position, employee_dni, store_id)
VALUES
('Lucía Romero', '2023-04-10', 'Cashier', '11111111A', 3),
('Marta Gómez', '2023-06-22', 'Supervisor', '22222222B', 3);

/*
	HACER UNA QUERY PARA CREAR UNA COLUMNA NUEVA QUE SEA PARA APELLIDOS USANDO LA DE NAME
*/
SET SQL_SAFE_UPDATES = 0; -- daba error si no lo ponia

SELECT * FROM employees;

-- agregar la columna
ALTER TABLE employees
ADD COLUMN employee_lastname VARCHAR(100);

-- coger los apellidos con substring y meterlos a employee_lastname
UPDATE employees
SET employee_lastname = SUBSTRING_INDEX(employee_name, ' ', -1);

-- dejar solo el nombre en employee_name
UPDATE employees
SET employee_name = SUBSTRING_INDEX(employee_name, ' ', 1)
WHERE employee_id > 0;


/*
	AÑADIR A SALE EL TOTAL DE LA COMPRA
*/
ALTER TABLE sales
ADD COLUMN sale_total DECIMAL(10,2);

UPDATE sales s
JOIN products p ON s.product_id = p.product_id
SET s.sale_total = s.sale_quantity * p.unit_price;

/*
	JUNTAR DATE Y TIME DE SALES A  PARA HACER UN DATETIME
*/
ALTER TABLE sales
ADD COLUMN sale_datetime DATETIME;

UPDATE sales		-- no borro las originales por si me sirven de algo
SET sale_datetime = TIMESTAMP(sale_date, sale_time);

SELECT * FROM sales;

SET SQL_SAFE_UPDATES = 1;


/*	--------------------------
	ESTUDIUO DE LOS DATOS
    --------------------------
*/

/*
	RECUENTO DE REGISTROS EN CADA TABLA
*/

SELECT COUNT(*) AS total_sales
FROM sales;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_stores
FROM stores;

SELECT COUNT(*) AS total_employees
FROM employees;

/*
	COMPROBACION DE NULOS
*/

SELECT *
FROM sales
WHERE sale_id IS NULL;

/*
	COMPROBAR DUPLICADOS
*/
-- lo miro en productos ya que es en el que habría mas posibilidad de duplicados
SELECT product_name, COUNT(*) AS total
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1;


/*
	VALORES FUERA DE RANGO (CORREGIDOS CON LOS CHECK EN EL ESQUEMA)
*/

-- ventas con cantidades invalidas
SELECT *
FROM sales
WHERE sale_quantity <= 0;

-- productos con precios invalidos
SELECT *
FROM products
WHERE unit_price <= 0;

/*
	JOINS
*/
-- veces que se ha vendido un producto
SELECT s.sale_id, p.product_name, s.sale_quantity
FROM sales s
JOIN products p ON s.product_id = p.product_id;

-- donde trabaja cada empleado
SELECT st.store_location, e.employee_name
FROM stores st
LEFT JOIN employees e ON st.store_id = e.store_id;


-- ejemplo de CAST redondeando los precios
SELECT product_name, CAST(unit_price AS SIGNED) AS rounded_price
FROM products;


-- ejemplo de case dividiendo los precios en baratos medios y caros
SELECT product_name, unit_price,
CASE
	WHEN unit_price < 5 THEN 'Cheap'
	WHEN unit_price < 20 THEN 'Medium'
ELSE 'Premium'
END AS price_range
FROM products;

/*
	SUBQUERY
*/
SELECT *
FROM products
WHERE unit_price = (
	SELECT MAX(unit_price)
	FROM products);


/*
	TABLAS TEMPORALES
*/
-- ventas por cada tienda
WITH sales_by_store AS (
	SELECT store_id, COUNT(*) as total_sales
	FROM sales
	GROUP BY store_id
)
SELECT *
FROM sales_by_store;

-- sacar las ventas como antes pero ahora encadenando y sacando la location con un join
WITH sales_by_store AS (
	SELECT store_id, COUNT(*) as total_sales
	FROM sales
	GROUP BY store_id
),
store_info AS (
	SELECT s.store_location, sb.total_sales
	FROM stores s JOIN sales_by_store sb ON s.store_id = sb.store_id
)
SELECT *
FROM store_info;

/*
	VIEW
*/

CREATE VIEW vw_sales_revenue AS
SELECT s.sale_id, p.product_name, s.sale_quantity, s.sale_total
FROM sales s JOIN products p ON s.product_id = p.product_id;

-- comprobar que la vista se ha creado y va
SELECT *
FROM vw_sales_revenue
LIMIT 10;

/*
	FUNCION PARA AÑADIR EL IVA AL PRECIO
*/

DELIMITER &&

CREATE FUNCTION fn_vat(price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
RETURN price * 1.21;
END&&

DELIMITER ;

SELECT product_name, unit_price, fn_vat(unit_price) AS price_with_vat
FROM products;

/*
------------------------------------------------------------------------
------------------------- CONSULTAS DE NEGOCIO -------------------------
------------------------------------------------------------------------
*/

-- hay que comprobar la tienda con mas ventas
SELECT st.store_location, COUNT(*) AS total_sales
FROM sales s JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_location
ORDER BY total_sales DESC;
-- SE PUEDE COMPROBAR QUE TORREMOLINOS ES LA TIENDA CON MAS COMPRAS

-- ------------------------------------------------------------------------

-- ingresos totales generados por cada tienda
SELECT st.store_location, ROUND(SUM(s.sale_total),2) AS ingresos
FROM sales s JOIN stores st ON s.store_id = st.store_id
GROUP BY st.store_location
ORDER BY ingresos DESC;
-- LA TIENDA CON MAS INGRESOS (Y VENTAS) ES TORREMOLINOS

-- ------------------------------------------------------------------------

-- top de los productos mas vendidos y ciudades donde se venden
SELECT p.product_name, SUM(s.sale_quantity) AS units_sold, st.store_location AS location
FROM sales s JOIN products p ON s.product_id = p.product_id
	JOIN stores st ON st.store_id = s.store_id
GROUP BY p.product_name, st.store_location
ORDER BY units_sold DESC
LIMIT 10;

-- ------------------------------------------------------------------------

-- categorias mas vendidas en todas las tiendas
SELECT c.category_name, SUM(s.sale_quantity) AS units_sold
FROM sales s JOIN products p ON s.product_id = p.product_id
	JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY units_sold DESC;
-- LAS CATEGORIAS MAS VENDIDAS SON EL CAFE Y EL TE CON DIFERENCIA

-- ------------------------------------------------------------------------

-- ingresos que genera cada categoria
SELECT c.category_name, ROUND(SUM(s.sale_quantity * p.unit_price),2) AS ingresos
FROM sales s JOIN products p ON s.product_id = p.product_id
	JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY ingresos DESC;
-- AL IGUAL QUE ANTES EL CAFE Y EL TE SON LOS QUE GENERAN MAS INGRESOS Y VENTAS

-- ------------------------------------------------------------------------

-- empleado con mas ventas
SELECT e.employee_name, SUM(s.sale_quantity) AS units_sold
FROM sales s JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_name
ORDER BY units_sold DESC;
-- CARLOS AL SER EL EMPLEADO DE NOJA ES EL QUE MAS VENTAS TIENE

-- ------------------------------------------------------------------------

-- ranking de empleados usando window function
SELECT e.employee_name, SUM(s.sale_quantity) AS units_sold,
	RANK() OVER(ORDER BY SUM(s.sale_quantity) DESC) AS ranking
FROM sales s JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_name;

-- ------------------------------------------------------------------------

-- ventas por horas
SELECT HOUR(sale_time) AS sale_hour, COUNT(*) AS total_sales
FROM sales
GROUP BY sale_hour
ORDER BY sale_hour;
-- SE PUEDE APRECIAR QUE LAS HORAS CON MAS VENTAS SON DE LAS 8 A LAS 12

-- ------------------------------------------------------------------------

-- ventas por meses 
SELECT MONTH(sale_date) AS month, COUNT(*) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;
-- LOS MESES CON MAS VENTAS SON MAYO Y JUNIO, HACERCANDOSE EL VERANO

-- ------------------------------------------------------------------------

-- ventas por dia utilizando la nueva columna datetime
SELECT DATE(sale_datetime) AS sale_day, COUNT(*) AS total_sales
FROM sales
GROUP BY sale_day
ORDER BY sale_day;
-- ------------------------------------------------------------------------

-- cuanto suele ser la media de los pedidos
SELECT ROUND(AVG(s.sale_quantity * p.unit_price),2) AS average_ticket
FROM sales s JOIN products p ON s.product_id = p.product_id;
-- LA MEDIA DE PEDIDOS RONDA LOS 5€
-- ------------------------------------------------------------------------

-- media de unidades vendidas por producto
SELECT p.product_name, ROUND(AVG(s.sale_quantity),2) AS average_units_sold
FROM sales s JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY average_units_sold DESC;
