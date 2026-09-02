/* =========================================================
   SHOPNOVA SALES DASHBOARD — MYSQL QUERIES
   ========================================================= */


/* =========================================================
   KPI 1 — NET REVENUE
   ========================================================= */

SELECT 
    CONCAT(
        ROUND(SUM(Final_Amount_INR) / 1000000, 2),
        'M'
    ) AS Net_Revenue
FROM orders;


/* =========================================================
   KPI 2 — TOTAL ORDERS
   ========================================================= */

SELECT 
    CONCAT(
        ROUND(COUNT(DISTINCT Order_ID) / 1000, 2),
        'K'
    ) AS Total_Orders
FROM orders;


/* =========================================================
   KPI 3 — AVERAGE ORDER VALUE (AOV)
   ========================================================= */

SELECT 
    CONCAT(
        ROUND(
            SUM(Final_Amount_INR) /
            COUNT(DISTINCT Order_ID) / 1000,
            2
        ),
        'K'
    ) AS Average_Order_Value
FROM orders;


/* =========================================================
   KPI 4 — RETURN RATE
   ========================================================= */

SELECT
    CONCAT(
        ROUND(
            COUNT(DISTINCT r.Order_ID) * 100.0 /
            COUNT(DISTINCT o.Order_ID),
            2
        ),
        '%'
    ) AS Return_Rate
FROM orders o
LEFT JOIN returns r
    ON o.Order_ID = r.Order_ID;


/* =========================================================
   KPI 5 — TOTAL QUANTITY SOLD
   ========================================================= */

SELECT 
    CONCAT(
        ROUND(SUM(Quantity) / 1000, 2),
        'K'
    ) AS Total_Quantity_Sold
FROM orders;


/* =========================================================
   KPI 6 — TOTAL CUSTOMERS
   ========================================================= */

SELECT 
    COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM orders;



/* =========================================================
   CHART 1 — MONTHLY REVENUE TREND
   ========================================================= */

SELECT
    Month_Name,
    CONCAT(
        ROUND(Revenue / 1000000, 2),
        'M'
    ) AS Revenue
FROM
(
    SELECT
        DATE_FORMAT(Order_Date, '%b') AS Month_Name,
        MONTH(Order_Date) AS Month_Num,
        SUM(Final_Amount_INR) AS Revenue
    FROM orders
    GROUP BY
        YEAR(Order_Date),
        MONTH(Order_Date),
        DATE_FORMAT(Order_Date, '%b')

    UNION ALL

    SELECT
        'Total' AS Month_Name,
        13 AS Month_Num,
        SUM(Final_Amount_INR) AS Revenue
    FROM orders
) AS Monthly_Data
ORDER BY Month_Num;



/* =========================================================
   CHART 2 — REVENUE BY CATEGORY
   ========================================================= */

SELECT
    Category,
    CONCAT(
        ROUND(SUM(Final_Amount_INR) / 1000000, 2),
        'M'
    ) AS Revenue
FROM orders
GROUP BY Category

UNION ALL

SELECT
    'Total' AS Category,
    CONCAT(
        ROUND(SUM(Final_Amount_INR) / 1000000, 2),
        'M'
    ) AS Revenue
FROM orders;



/* =========================================================
   CHART 3 — TOP 10 PRODUCT REVENUE
   ========================================================= */

SELECT
    Product_Name,
    CONCAT(
        ROUND(Revenue / 1000000, 2),
        'M'
    ) AS Revenue
FROM
(
    SELECT
        Product_Name,
        SUM(Final_Amount_INR) AS Revenue
    FROM orders
    GROUP BY Product_Name
    ORDER BY Revenue DESC
    LIMIT 10
) AS Top_Products

UNION ALL

SELECT
    'Total' AS Product_Name,
    CONCAT(
        ROUND(SUM(Revenue) / 1000000, 2),
        'M'
    ) AS Revenue
FROM
(
    SELECT
        Product_Name,
        SUM(Final_Amount_INR) AS Revenue
    FROM orders
    GROUP BY Product_Name
    ORDER BY Revenue DESC
    LIMIT 10
) AS Top_Products_Total;



/* =========================================================
   CHART 4 — ORDERS BY PAYMENT METHOD
   ========================================================= */

SELECT
    Payment_Method,
    CONCAT(
        ROUND(COUNT(DISTINCT Order_ID) / 1000, 2),
        'K'
    ) AS Orders
FROM orders
GROUP BY Payment_Method

UNION ALL

SELECT
    'Total' AS Payment_Method,
    CONCAT(
        ROUND(COUNT(DISTINCT Order_ID) / 1000, 2),
        'K'
    ) AS Orders
FROM orders;



/* =========================================================
   CHART 5 — ORDERS BY ORDER CHANNEL
   ========================================================= */

SELECT
    Order_Channel,
    CONCAT(
        ROUND(COUNT(DISTINCT Order_ID) / 1000, 2),
        'K'
    ) AS Orders
FROM orders
GROUP BY Order_Channel
ORDER BY COUNT(DISTINCT Order_ID) DESC;