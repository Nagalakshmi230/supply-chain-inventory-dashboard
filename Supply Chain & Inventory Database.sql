CREATE DATABASE SupplyChainDB;
USE SupplyChainDB;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    reorder_level INT
);

CREATE TABLE Inventory (
    product_id INT,
    stock_quantity INT,
    warehouse VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    order_date DATE,
    quantity_ordered INT,
    delivery_date DATE
);

CREATE TABLE Suppliers (
    supplier_id INT,
    product_id INT,
    lead_time_days INT
);

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 10),
(2, 'Phone', 'Electronics', 15),
(3, 'Chair', 'Furniture', 20),
(4, 'Desk', 'Furniture', 10),
(5, 'Headphones', 'Accessories', 25);

INSERT INTO Inventory VALUES
(1, 8, 'WH1'),
(2, 20, 'WH1'),
(3, 15, 'WH2'),
(4, 5, 'WH2'),
(5, 30, 'WH1');

INSERT INTO Orders VALUES
(101, 1, '2023-01-10', 5, '2023-01-15'),
(102, 2, '2023-02-12', 10, '2023-02-18'),
(103, 3, '2023-03-05', 8, '2023-03-12'),
(104, 4, '2023-04-01', 6, '2023-04-10'),
(105, 5, '2023-05-15', 12, '2023-05-20');

INSERT INTO Suppliers VALUES
(201, 1, 5),
(202, 2, 6),
(203, 3, 7),
(204, 4, 4),
(205, 5, 3);

--Stock Status (Key Insight)
SELECT 
    p.product_name,
    i.stock_quantity,
    p.reorder_level,
    CASE 
        WHEN i.stock_quantity < p.reorder_level THEN 'Shortage'
        WHEN i.stock_quantity > p.reorder_level * 2 THEN 'Overstock'
        ELSE 'Optimal'
    END AS stock_status
FROM Products p
JOIN Inventory i ON p.product_id = i.product_id;

--Inventory Turnover (Demand)
SELECT 
    product_id,
    SUM(quantity_ordered) AS total_demand
FROM Orders
GROUP BY product_id;

--Lead Time
SELECT 
    product_id,
    AVG(lead_time_days) AS avg_lead_time
FROM Suppliers
GROUP BY product_id;

--Order Fulfillment Rate
SELECT 
    COUNT(CASE WHEN delivery_date <= DATEADD(day, 5, order_date) THEN 1 END) * 100.0 / COUNT(*) AS fulfillment_rate
FROM Orders;