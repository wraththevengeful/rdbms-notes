# EXERCISE 3:

## NOTES:
Text with **BOLD** format are primary keys.


## Consider the following relations for an order-processing database application in a company:

CUSTOMER(
    **CUSTOMERNO** BIGINT,
    CNAME VARCHAR(30),
    CITY VARCHAR(30)
);
Implement a check constraint to check CUSTOMERNO STARTS with '4' and length of CUSTOMERNO is 5.

CUST_ORDER(
    **ORDERNO** BIGINT,
    ODATE DATE,
    CUSTOMERNO REFERENCES CUSTOMER,
    ORD_AMT BIGINT DEFAULT 0
);
Implement a check constraint to check ORDERNO starts with '5' and length 5.

ITEM(
    **ITEMNO** BIGINT,
    ITEM_NAME VARCHAR(30),
    UNIT_PRICE NUMBER(5)
);
Implement a check constraint to check ITEMNO starts with '6' and length of ITEMNO is 5.

ORDER_ITEM(
    **ORDERNO** REFERENCES CUST_ORDER,
    **ITEMNO** REFERENCES ITEM,
    QTY NUMBER(3)
);


Here, ORD_AMT refers to total amount of an order(ORD_AMT is a derived attribute); ODATE is the date the order was placed, the primary key of each relation is in **BOLD** format.

1. Develop DDL to implement the above schema enforcing primary key, check constraints and foreign key constraints.
2. Populate the database with a rich data set.
3. Develop a SQL query to list the details of the customers who have placed more than three orders.
4. Develop the SQL query to list the details of items where price is less than the average price of all items.
5. Develop a SQL query to list the ORDERNO and number of items in each order.
6. Develop a SQL query to list the details of items that are present in 25% of the orders.
7. Develop an update statement to update the value of ORD_AMT.
8. Create a view that will keep track of the details of each customer and the number of orders placed.
9. Develop a database trigger that will not permit to insert more than six records in the CUST_ORDER table for a particular order(An order can contain maximum of six items). 