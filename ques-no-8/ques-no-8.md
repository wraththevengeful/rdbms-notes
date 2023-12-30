# QUESTION NO 8:
Consider the following relational schema for an order processing application:

CUSTOMER(**CUSTOMER_ID** VARCHAR2 (5) PRIMARY KEY, CUSTOMER_NAME VARCHAR2 (30))
CHECK CUSTOMER_ID STARTS WITH 'C'

PRODUCT(**PRODUCT_CODE** VARCHAR2 (5) PRIMARY KEY, PRODUCT_NAME VARCHAR2(30), UNIT_PRICE NUMBER(5))
CHECK PRODUCT_CODE STARTS WITH 'P'

CUST_ORDER(**ORDER_CODE** VARCHAR2 (5), ORDER_DATE DATE, ORDER_AMT NUMBER(8), CUSTOMER_ID REFERENCES CUSTOMER)
CHECK ORDER_CODE STARTS WITH 'O'
ORDER_AMT IS A DERIVED ATTRIBUTE

ORDER_PRODUCT(**ORDER_CODE** REFERENCES CUST_ORDER, **PRODUCT_CODE** REFERENCES PRODUCT, NO_OF_UNITS NUMBER(3), PRIMARY KEY(ORDER_CODE, PRODUCT_CODE))

The primary key of each relation is of this style: **EXAMPLE**

a. Develop DDL to implement the above Schema enforcing primary key, check constraints and foreign key constraints.

b. Populate the database with a rich data set.

c. Develop a SQL query to list the details of the product whose price is greater than average price of all products.

d. Develop a SQL query to list the order code and the no of products in each order.

e. Develop a SQL query to list the details of the details of the products which is contained in more than 30% of the orders.

f. Develop an update statement to update statement to update the ORDE_AMT in CUST_ORDER table.

g.Develop a SQL Query to list the details of customers have placed more than 5% of the orders.

h. Develop a SQL query to list the details of the products which is contained in less than 10% of the orders.

i. Create a view that will keep track of details of customers and the number of orders placed by each customer.

j. Develop a database trigger that will not permit to insert more than six records in the CUST_ORDER table for a particular order. (An order can contain a maximum of six items).
