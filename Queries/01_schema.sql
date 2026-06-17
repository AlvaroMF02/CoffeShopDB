
DROP DATABASE IF EXISTS coffeShopDB;        -- por si la bd ya estaba creada  
CREATE DATABASE IF NOT EXISTS coffeShopDB;
USE coffeShopDB;

-- CATEGORIES almacena las categorias de productos con su id y nombre
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name varchar(100) NOT NULL
);

/*
    PRODUCTS guarda todos los productos a la venta,
    se relaciona con el category_id para conseguir los nombres de las categorias
    en un futuro
*/
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_type VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    category_id INT NOT NULL,

    FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

/*
    STORES contiene información básica de las tiendas,
    las columnas nuevas son: "capacity" y "status".
    No venian en el dataset y pensé que estaría mejor así
*/
CREATE TABLE IF NOT EXISTS stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_location VARCHAR(100) NOT NULL,
    store_capacity INT NOT NULL,
    store_status BOOLEAN NOT NULL
);

/*
    EMPLOYEES es una tabla creada desde 0, ningun dato venía en el dataset original
    Está relacionada con store_id (la tienda en la que esta cada empleado)
*/
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    employee_hiring_date DATE NOT NULL,
    employee_position VARCHAR(80) NOT NULL,
    employee_dni varchar(10) NOT NULL UNIQUE,
    store_id INT NOT NULL,

    FOREIGN KEY (store_id) REFERENCES stores(store_id)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

/*
    SALES (anteriormente TRANSACTIONS) contiene todas las ventas de las cafeterias,
    está relacionada con store para ver que tienda es en la que se vende,
    product para ver el producto y employee para ver quien lo vende.
    En el dataset un empleado solo puede vender un producto x cantidad,
    obviamente esto no pasa en la vida real pero se me complicaría mucho editarlo

    En MySQL añadiré sale_total y juntaré las columnas de DATE y Time
*/
CREATE TABLE IF NOT EXISTS sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE NOT NULL,
    sale_quantity INT NOT NULL CHECK (sale_quantity > 0),
    sale_time TIME NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    employee_id INT NOT NULL,

    FOREIGN KEY (store_id) REFERENCES stores(store_id)
    ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
    ON DELETE NO ACTION ON UPDATE CASCADE
);
