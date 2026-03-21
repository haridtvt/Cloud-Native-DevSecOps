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
('MacBook Pro M3', 2499.00, 10, 'https://picsum.photos/id/0/400/400'),
('iPhone 15 Pro Max', 1199.00, 15, 'https://picsum.photos/id/160/400/400'),
('Keychron Q1 Mechanical Keyboard', 180.00, 5, 'https://picsum.photos/id/20/400/400'),
('Sony WH-1000XM5 Headphones', 399.00, 12, 'https://picsum.photos/id/48/400/400'),
('Logitech MX Master 3S Mouse', 99.00, 25, 'https://picsum.photos/id/7/400/400'),
('Dell UltraSharp 27" Monitor', 650.00, 8, 'https://picsum.photos/id/488/400/400'),
('PlayStation 5 Slim Console', 499.00, 7, 'https://picsum.photos/id/96/400/400'),
('Nintendo Switch OLED Model', 349.00, 20, 'https://picsum.photos/id/367/400/400');