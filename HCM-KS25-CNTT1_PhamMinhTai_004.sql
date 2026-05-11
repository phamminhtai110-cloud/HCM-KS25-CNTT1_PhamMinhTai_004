-- XOA DATABASE NEU DA TON TAI

DROP DATABASE IF EXISTS HackathonDB;

-- TAO DATABASE

CREATE DATABASE HackathonDB;
USE HackathonDB;

-- TAO BANG CUSTOMER

CREATE TABLE Customer (
    customer_id VARCHAR(5) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) UNIQUE,
    customer_phone VARCHAR(15),
    customer_address VARCHAR(255)
);

-- TAO BANG PRODUCT

CREATE TABLE Product (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    product_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

-- TAO BANG ORDERS

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(5),
    product_id VARCHAR(5),
    order_date DATE,
    order_quantity INT,
    total_amount DECIMAL(10,2),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
);

-- TAO BANG PAYMENT

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);

-- INSERT CUSTOMER

INSERT INTO Customer
(customer_id, customer_name, customer_email, customer_phone, customer_address)
VALUES
('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0987654321', 'Hanoi'),
('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0987654322', 'Ho Chi Minh'),
('C003', 'Le Minh Hoang', 'hoang.le@example.com', '0987654323', 'Danang'),
('C004', 'Pham Hoang Nam', 'nam.pham@example.com', '0987654324', 'Hue'),
('C005', 'Vu Minh Thu', 'thu.vu@example.com', '0987654325', 'Hai Phong');

-- INSERT PRODUCT

INSERT INTO Product
(product_id, product_name, category, product_price, stock_quantity)
VALUES
('P001', 'Laptop Dell', 'Electronics', 15000.00, 10),
('P002', 'iPhone 15', 'Electronics', 20000.00, 5),
('P003', 'T-Shirt', 'Clothing', 200.00, 50),
('P004', 'Running Shoes', 'Footwear', 1500.00, 20),
('P005', 'Table Lamp', 'Furniture', 500.00, 15);

-- INSERT ORDERS

INSERT INTO Orders
(order_id, customer_id, product_id, order_date, order_quantity, total_amount)
VALUES
(1, 'C001', 'P001', '2025-06-01', 1, 15000.00),
(2, 'C002', 'P003', '2025-06-02', 2, 400.00),
(3, 'C003', 'P002', '2025-06-03', 1, 20000.00),
(4, 'C001', 'P004', '2025-06-03', 1, 1500.00),
(5, 'C005', 'P001', '2025-06-04', 2, 30000.00);

-- INSERT PAYMENT

INSERT INTO Payment
(payment_id, order_id, payment_date, payment_method, payment_status)
VALUES
(1, 1, '2025-06-01', 'Banking', 'Paid'),
(2, 2, '2025-06-02', 'Cash', 'Paid'),
(3, 3, '2025-06-03', 'Credit Card', 'Paid'),
(4, 4, '2025-06-04', 'Banking', 'Pending'),
(5, 5, '2025-06-05', 'Credit Card', 'Paid');

-- HIEN THI TOAN BO DU LIEU BAN DAU

SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM Payment;

-- PHAN 2 - TRUY VAN CO BAN

-- 3. CAP NHAT SO DIEN THOAI KHACH HANG C001

UPDATE Customer
SET customer_phone = '0999888777'
WHERE customer_id = 'C001';

SELECT * FROM Customer;

-- 4. TANG STOCK +50 VA TANG GIA 10% CHO P003


UPDATE Product
SET
    stock_quantity = stock_quantity + 50,
    product_price = product_price * 1.10
WHERE product_id = 'P003';

SELECT * FROM Product;

-- 5. XOA PAYMENT PENDING + BANKING
-- SAFE MODE FIX

SET SQL_SAFE_UPDATES = 0;

DELETE FROM Payment
WHERE payment_status = 'Pending'
AND payment_method = 'Banking';

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Payment;

-- 6. SAN PHAM ELECTRONICS GIA > 10000

SELECT
    product_id,
    product_name,
    product_price
FROM Product
WHERE category = 'Electronics'
AND product_price > 10000;

-- 7. KHACH HANG CO HO NGUYEN

SELECT
    customer_name,
    customer_email,
    customer_address
FROM Customer
WHERE customer_name LIKE 'Nguyen%';

-- 8. DANH SACH DON HANG GIAM DAN THEO TOTAL_AMOUNT

SELECT
    order_id,
    order_date,
    total_amount
FROM Orders
ORDER BY total_amount DESC;

-- 9. LAY 3 PAYMENT MOI NHAT

SELECT *
FROM Payment
ORDER BY payment_date DESC
LIMIT 3;

-- 10. BO QUA 2 BAN GHI DAU, LAY 3 BAN GHI TIEP THEO

SELECT
    product_id,
    product_name
FROM Product
LIMIT 2,3;

-- PHAN 3 - TRUY VAN NANG CAO

-- 11. DON HANG > 1000

SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    o.total_amount
FROM Orders o
INNER JOIN Customer c
    ON o.customer_id = c.customer_id
INNER JOIN Product p
    ON o.product_id = p.product_id
WHERE o.total_amount > 1000;

-- 12. LIET KE TAT CA SAN PHAM KE CA CHUA CO DON HANG

SELECT
    p.product_id,
    p.product_name,
    o.order_id
FROM Product p
LEFT JOIN Orders o
    ON p.product_id = o.product_id;

-- 13. TONG DOANH THU THEO CATEGORY

SELECT
    p.category,
    SUM(o.total_amount) AS Total_Revenue
FROM Orders o
INNER JOIN Product p
    ON o.product_id = p.product_id
GROUP BY p.category;

-- 14. SO LUONG DON HANG CUA MOI KHACH HANG >= 2

SELECT
    c.customer_name,
    COUNT(o.order_id) AS Order_Count
FROM Customer c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) >= 2;

-- 15. DON HANG CO GIA TRI > TRUNG BINH

SELECT
    o.order_id,
    c.customer_name,
    o.total_amount
FROM Orders o
INNER JOIN Customer c
    ON o.customer_id = c.customer_id
WHERE o.total_amount >
(
    SELECT AVG(total_amount)
    FROM Orders
);

-- 16. KHACH HANG DA MUA ELECTRONICS

SELECT DISTINCT
    c.customer_name,
    c.customer_phone
FROM Customer c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
INNER JOIN Product p
    ON o.product_id = p.product_id
WHERE p.category = 'Electronics';

-- 17. THONG TIN TONG HOP DON HANG + THANH TOAN

SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    py.payment_method,
    py.payment_status
FROM Orders o
INNER JOIN Customer c
    ON o.customer_id = c.customer_id
INNER JOIN Product p
    ON o.product_id = p.product_id
LEFT JOIN Payment py
    ON o.order_id = py.order_id;

-- HIEN THI DU LIEU CUOI CUNG

SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM Payment;
