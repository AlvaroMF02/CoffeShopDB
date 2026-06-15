
CREATE DATABASE IF NOT EXISTS coffeShopDB;
USE coffeShopDB;

CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_type VARCHAR(100) NOT NULL,
    unti_price DECIMAL(10,2) NOT NULL,
    category_id INT NOT NULL,

    FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_location VARCHAR(100) NOT NULL,
    store_capacity INT NOT NULL,
    store_status BOOLEAN NOT NULL
);

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

CREATE TABLE IF NOT EXISTS sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE NOT NULL,
    sale_quantity INT NOT NULL,
    sale_time TIME NOT NULL,
    sale_total DECIMAL(10,2) NOT NULL,
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
