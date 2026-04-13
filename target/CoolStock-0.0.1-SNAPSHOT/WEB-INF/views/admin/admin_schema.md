-- 1. DROP TABLES (In reverse order of dependency)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- 2. CREATE TABLES
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    flavor VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    pcs_per_box INT NOT NULL DEFAULT 1,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_key VARCHAR(50) UNIQUE NOT NULL,
    shop_name VARCHAR(100) NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(50) NOT NULL,
    area VARCHAR(100),
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_spend DECIMAL(12,2) DEFAULT 0.00
);

CREATE TABLE staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    staff_key VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL, -- 'Manager', 'Cashier', 'Delivery'
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    delivery_boy_id INT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Processing',
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (delivery_boy_id) REFERENCES staff(id)
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 3. SEED SAMPLE DATA
-- Insert Staff (Parents)
INSERT INTO staff (id, staff_key, full_name, role, phone, email, password_hash, is_active) VALUES
(1, 'STAFF-1', 'Amit Sharma', 'Manager', '9800111111', 'amit@coolstock.in', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1),
(2, 'STAFF-2', 'Priya Patel', 'Cashier', '9800133333', 'priya@coolstock.in', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1),
(3, 'STAFF-3', 'Neha Singh', 'Delivery', '9800122222', 'neha@coolstock.in', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1),
(4, 'STAFF-4', 'Rohit Das', 'Delivery', '9800144444', 'rohit@coolstock.in', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1),
(5, 'STAFF-5', 'Arjun Mehta', 'Delivery', '9800155555', 'arjun@coolstock.in', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1);

-- Insert Customers (Parents)
INSERT INTO customers (id, customer_key, shop_name, owner_name, phone, email, city, area, password_hash, is_active) VALUES
(1, 'CUST-1', 'Krishna Dairy', 'Rajesh Bhai', '9900112233', 'krishna@retail.com', 'Rajkot', 'Kalawad Road', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1),
(2, 'CUST-2', 'Shreeji Icecream', 'Suresh Patel', '9900445566', 'shreeji@retail.com', 'Ahmedabad', 'SG Highway', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1),
(3, 'CUST-3', 'Modern Mart', 'Anjali Shah', '9900778899', 'modern@retail.com', 'Surat', 'Adajan', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1),
(4, 'CUST-4', 'Quality Sweets', 'Vijay Mehta', '9900223344', 'quality@retail.com', 'Vadodara', 'Alkapuri', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', 1);

-- Insert Products
INSERT INTO products (id, product_code, name, category, flavor, price, stock, pcs_per_box, description) VALUES
(1, 'PROD-101', 'Vanilla Paradise Tub', 'Tubs', 'Vanilla', 120.00, 450, 6, 'Classic creamy vanilla in wholesale 1kg tubs.'),
(2, 'PROD-102', 'Rich Chocolate Cone', 'Cones', 'Chocolate', 40.00, 1200, 24, 'Dark chocolate cone - bestseller in retail shops.'),
(3, 'PROD-103', 'Mango Magic Stick', 'Sticks', 'Mango', 25.00, 350, 30, 'Seasonal real mango stick, kids favorite.');

-- Insert Orders (Children)
INSERT INTO orders (id, order_number, customer_id, delivery_boy_id, status, total_amount, order_date) VALUES
(1, 'ORD-10001', 1, 3, 'Delivered', 4500.00, '2026-03-01 10:30:00'),
(2, 'ORD-10002', 2, 4, 'Shipped', 1600.00, '2026-03-05 14:15:00'),
(3, 'ORD-10003', 1, 3, 'Processing', 8400.00, '2026-03-08 09:45:00');

-- Insert Order Items (Grandchildren)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 30, 120.00, 3600.00),
(1, 2, 60, 15.00, 900.00),
(2, 2, 40, 40.00, 1600.00),
(3, 1, 24, 120.00, 2880.00),
(3, 2, 50, 40.00, 2000.00);

ALTER TABLE orders ADD COLUMN delivery_priority VARCHAR(50) DEFAULT 'Regular';