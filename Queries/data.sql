
USE coffeShopDB;

INSERT INTO stores (store_id,store_location, store_capacity, store_status) VALUES
(5, 'Estepona', 50, TRUE),
(8, 'Torremolinos', 30, TRUE),
(3, 'Noja', 60, FALSE);

INSERT INTO categories (category_name) VALUES
    ('Coffee'),
    ('Tea'),
    ('Drinking Chocolate'),
    ('Bakery'),
    ('Flavours'),
    ('Loose Tea'),
    ('Coffee beans'),
    ('Packaged Chocolate'),
    ('Branded');

INSERT INTO employees (employee_name, employee_hiring_date, employee_position, employee_dni, store_id) VALUES
('Valeria Sánchez', '2022-03-15', 'Cashier', '12345678A', 5),
('Jorge Moreno', '2021-11-08', 'Supervisor', '23456789B', 5),
('Dario Fernández', '2023-01-20', 'Barista', '34567890C', 5),
('Ana Torres', '2021-06-10', 'Barista', '45678901D', 5),
('Marina Jiménez', '2024-02-05', 'Barista', '56789012E', 5),
('David Ruiz', '2022-09-12', 'Barista', '67890123F', 8),
('Lara Lépez', '2021-07-01', 'Supervisor', '78901234G', 8),
('Javier Martín', '2023-05-18', 'Cashier', '89012345I', 8);
