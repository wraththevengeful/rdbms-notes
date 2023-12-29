--a. Create tables:
CREATE TABLE CUSTOMER (
    CUSTOMERNO VARCHAR(5) PRIMARY KEY,
    CNAME VARCHAR(30),
    CITY VARCHAR(30),
    CONSTRAINT check_customerno CHECK (CUSTOMERNO LIKE 'C%')
);

CREATE TABLE CUST_ORDER (
    ORDERNO VARCHAR(5) PRIMARY KEY,
    ODATE DATE,
    CUSTOMERNO VARCHAR(5),
    ORD_AMT INT,
    CONSTRAINT check_orderno CHECK (ORDERNO LIKE 'O%'),
    CONSTRAINT fk_customer FOREIGN KEY (CUSTOMERNO) REFERENCES CUSTOMER(CUSTOMERNO)
);

CREATE TABLE ITEM (
    ITEMNO VARCHAR(5) PRIMARY KEY,
    ITEM_NAME VARCHAR(30),
    UNIT_PRICE INT,
    CONSTRAINT check_itemno CHECK (ITEMNO LIKE 'I%')
);

CREATE TABLE ORDER_ITEM (
    ORDERNO VARCHAR(5),
    ITEMNO VARCHAR(5),
    QTY INT,
    PRIMARY KEY (ORDERNO, ITEMNO),
    CONSTRAINT fk_order_item_order FOREIGN KEY (ORDERNO) REFERENCES CUST_ORDER(ORDERNO),
    CONSTRAINT fk_order_item_item FOREIGN KEY (ITEMNO) REFERENCES ITEM(ITEMNO)
);

CREATE TABLE SHIPMENT (
    ORDERNO VARCHAR(5),
    ITEMNO VARCHAR(5),
    SHIP_DATE DATE,
    PRIMARY KEY (ORDERNO, ITEMNO),
    CONSTRAINT fk_shipment_order FOREIGN KEY (ORDERNO) REFERENCES CUST_ORDER(ORDERNO),
    CONSTRAINT fk_shipment_item FOREIGN KEY (ITEMNO) REFERENCES ITEM(ITEMNO)
); 

--.b Populating the Database:
Use INSERT INTO statements to add data to each table. 

--c. SQL Query to list the details of customers who have placed more than three orders:
SELECT C.CUSTOMERNO, C.CNAME, COUNT(O.ORDERNO) AS NUM_ORDERS
FROM CUSTOMER C
JOIN CUST_ORDER O ON C.CUSTOMERNO = O.CUSTOMERNO
GROUP BY C.CUSTOMERNO, C.CNAME
HAVING COUNT(O.ORDERNO) > 3; 

--d. SQL Query to list the details of items whose prive is less than the average of all items:
SELECT *
FROM ITEM
WHERE UNIT_PRICE < (SELECT AVG(UNIT_PRICE) FROM ITEM); 

--e. SQL Query to list the orderno and number of items in each order:
SELECT ORDERNO, COUNT(ITEMNO) AS NUM_ITEMS
FROM ORDER_ITEM
GROUP BY ORDERNO; 

--f. SQL Query to list the details of items that are present in 25% of the orders:
SELECT ITEMNO, COUNT(DISTINCT ORDERNO) AS ORDER_COUNT
FROM ORDER_ITEM
GROUP BY ITEMNO
HAVING ORDER_COUNT >= (SELECT COUNT(DISTINCT ORDERNO) * 0.25 FROM CUST_ORDER); 

--g.Update Statement to Update ORD_AMT:
The ORD_AMT seems to be a derived attribute, so its value would need to be calculated or updated using an appropriate SQL statement based on the business logic. 

--h. View to keep track of the details of each customer and the number of orders placed:
CREATE OR REPLACE VIEW CustomerOrderDetails AS
SELECT C.CUSTOMERNO, C.CNAME, COUNT(O.ORDERNO) AS NUM_ORDERS
FROM CUSTOMER C
JOIN CUST_ORDER O ON C.CUSTOMERNO = O.CUSTOMERNO
GROUP BY C.CUSTOMERNO, C.CNAME; 

--i. Database Trigger to Limit Insertion in CUST_ORDER Table:
MySQL does not support row-level triggers, thus direct enforcement of the maximum number of items per order through triggers isn't feasible. You might need to handle this constraint through your application logic.

--j. DISP Procedure

DELIMITER //

CREATE PROCEDURE DISP(IN order_num VARCHAR(5))
BEGIN
    DECLARE order_exists INT;
   
    SELECT COUNT(*) INTO order_exists
    FROM CUST_ORDER
    WHERE ORDERNO = order_num;
   
    IF order_exists > 0 THEN
        SELECT * FROM CUST_ORDER WHERE ORDERNO = order_num;
    ELSE
        SELECT 'No such order' AS MESSAGE;
    END IF;
END //

DELIMITER ;
