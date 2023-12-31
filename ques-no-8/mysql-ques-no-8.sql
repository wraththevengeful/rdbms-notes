--a. Develop DDL to implement the above Schema enforcing primary key, check constraints and foreign key constraints.
-- CUSTOMER table
CREATE TABLE CUSTOMER (
    CUSTOMER_ID VARCHAR(5) PRIMARY KEY CHECK (CUSTOMER_ID LIKE 'C%'),
    CUSTOMER_NAME VARCHAR(30)
);

-- PRODUCT table
CREATE TABLE PRODUCT (
    PRODUCT_CODE VARCHAR(5) PRIMARY KEY CHECK (PRODUCT_CODE LIKE 'P%'),
    PRODUCT_NAME VARCHAR(30),
    UNIT_PRICE DECIMAL(5, 2)
);

-- CUST_ORDER table
CREATE TABLE CUST_ORDER (
    ORDER_CODE VARCHAR(5) CHECK (ORDER_CODE LIKE 'O%'),
    ORDER_DATE DATE,
    ORDER_AMT DECIMAL(8, 2),
    CUSTOMER_ID VARCHAR(5),
    PRIMARY KEY (ORDER_CODE),
    CONSTRAINT fk_order_customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)
);

-- ORDER_PRODUCT table
CREATE TABLE ORDER_PRODUCT (
    ORDER_CODE VARCHAR(5),
    PRODUCT_CODE VARCHAR(5),
    NO_OF_UNITS INT,
    PRIMARY KEY (ORDER_CODE, PRODUCT_CODE),
    CONSTRAINT fk_order_product_order FOREIGN KEY (ORDER_CODE) REFERENCES CUST_ORDER(ORDER_CODE),
    CONSTRAINT fk_order_product_product FOREIGN KEY (PRODUCT_CODE) REFERENCES PRODUCT(PRODUCT_CODE)
);

--b. Populate the database with a rich data set.

-- Insert data into CUSTOMER table
INSERT INTO CUSTOMER VALUES ('C001', 'John Doe'), ('C002', 'Jane Smith');

-- Insert data into PRODUCT table
INSERT INTO PRODUCT VALUES ('P001', 'Product1', 50.00), ('P002', 'Product2', 60.00);

-- Insert data into CUST_ORDER table
INSERT INTO CUST_ORDER VALUES ('O001', '2023-01-01', 500.00, 'C001'), ('O002', '2023-01-02', 600.00, 'C002');

-- Insert data into ORDER_PRODUCT table
INSERT INTO ORDER_PRODUCT VALUES ('O001', 'P001', 2), ('O001', 'P002', 3), ('O002', 'P001', 4);

--c. Develop a SQL query to list the details of the product whose price is greater than the average price of all products.
SELECT *
FROM PRODUCT
WHERE UNIT_PRICE > (SELECT AVG(UNIT_PRICE) FROM PRODUCT);

--d. Develop a SQL query to list the order code and the no of products in each order.
SELECT OP.ORDER_CODE, COUNT(OP.PRODUCT_CODE) AS NUM_OF_PRODUCTS
FROM ORDER_PRODUCT OP
GROUP BY OP.ORDER_CODE;

--e. Develop a SQL query to list the details of the products which are contained in more than 30% of the orders.
WITH ProductOrderPercentage AS (
    SELECT PRODUCT_CODE, COUNT(DISTINCT ORDER_CODE) * 100.0 / COUNT(DISTINCT OP.ORDER_CODE) AS PERCENTAGE
    FROM ORDER_PRODUCT OP
    GROUP BY PRODUCT_CODE
)

SELECT P.*
FROM PRODUCT P
JOIN ProductOrderPercentage POP ON P.PRODUCT_CODE = POP.PRODUCT_CODE
WHERE PERCENTAGE > 30;

--f. Develop an update statement to update the ORDER_AMT in CUST_ORDER table.
UPDATE CUST_ORDER
SET ORDER_AMT = NEW_VALUE
WHERE <your_condition>;

--g.Develop a SQL Query to list the details of customers have placed more than 5% of the orders.
WITH CustomerOrderPercentage AS (
    SELECT
        C.CUSTOMER_ID,
        COUNT(DISTINCT CO.ORDER_CODE) * 100.0 / COUNT(DISTINCT OPO.ORDER_CODE) AS PERCENTAGE
    FROM
        CUSTOMER C
        LEFT JOIN CUST_ORDER CO ON C.CUSTOMER_ID = CO.CUSTOMER_ID
        LEFT JOIN ORDER_PRODUCT OPO ON CO.ORDER_CODE = OPO.ORDER_CODE
    GROUP BY
        C.CUSTOMER_ID
)

SELECT
    C.CUSTOMER_ID,
    C.CUSTOMER_NAME
FROM
    CUSTOMER C
    JOIN CustomerOrderPercentage COP ON C.CUSTOMER_ID = COP.CUSTOMER_ID
WHERE
    PERCENTAGE > 5;

--i. Create a view that will keep track of details of customers and the number of orders placed by each customer.
CREATE VIEW CustomerOrderCount AS
SELECT C.CUSTOMER_ID, C.CUSTOMER_NAME, COUNT(CO.ORDER_CODE) AS NUM_OF_ORDERS
FROM CUSTOMER C
LEFT JOIN CUST_ORDER CO ON C.CUSTOMER_ID = CO.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.CUSTOMER_NAME;

--j. Develop a database trigger that will not permit inserting more than six records in the CUST_ORDER table for a particular order.
DELIMITER //

CREATE TRIGGER check_order_item_limit
BEFORE INSERT ON CUST_ORDER
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM CUST_ORDER WHERE ORDER_CODE = NEW.ORDER_CODE) >= 6 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert more than six records for a particular order';
    END IF;
END//

DELIMITER ;

--k. Develop a procedure DISP that will accept an order number and display the order details CUST_ORDER. Include an exception in the procedure that will display a message "No such order" if the order number does not exist in the CUST_ORDER relation.
DELIMITER //

CREATE PROCEDURE DISP(IN order_code_in VARCHAR(5))
BEGIN
    DECLARE order_count INT;

    SELECT COUNT(*) INTO order_count
    FROM CUST_ORDER
    WHERE ORDER_CODE = order_code_in;

    IF order_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No such order';
    ELSE
        SELECT *
        FROM CUST_ORDER
        WHERE ORDER_CODE = order_code_in;
    END IF;
END//

DELIMITER ;

--
CALL DISP('O001');
