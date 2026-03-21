CREATE DATABASE IF NOT EXISTS shop_db;
USE shop_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 10,
    img_url VARCHAR(255)
);

INSERT INTO users (username, password, email)
VALUES ('admin', '$2b$12$dQz.Xv.S.V0B.f8e.Y8u.OeH.gK/L1vP.f8e.f8e.f8e.f8e.f8e', 'admin@example.com');

INSERT INTO products (name, price, stock, img_url) VALUES
('Laptop Dell XPS', 1500, 5, 'https://via.placeholder.com/150'),
('iPhone 15 Pro', 1200, 8, 'https://via.placeholder.com/150'),
('Mechanical Keyboard', 100, 20, 'https://via.placeholder.com/150');