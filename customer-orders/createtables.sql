--CUSTOMER ORDERS

--CREATING TABLES
create table CUSTOMER(CUSTOMERNO BIGINT PRIMARY KEY, CNAME VARCHAR(30), CITY VARCHAR(30));
create table CUST_ORDER(ORDERNO BIGINT PRIMARY KEY, ODATE DATE, CUSTOMERNO BIGINT REFERENCES CUSTOMER(CUSTOMERNO), ORD_AMT BIGINT DEFAULT 0);
create table ITEM(ITEMNO BIGINT PRIMARY KEY, ITEM_NAME VARCHAR(30),UNIT_PRICE SMALLINT);
create table ORDER_ITEM(ORDERNO BIGINT REFERENCES CUST_ORDER(ORDERNO), ITEMNO BIGINT REFERENCES ITEM(ITEMNO), QTY SMALLINT, PRIMARY KEY(ORDERNO, ITEMNO));

--Incase we forget to add primary keys while creating tables which I'm sure our dumbass will:
alter table CUSTOMER add constraint customer_pk PRIMARY KEY(CUSTOMERNO);

--Check constraints:
alter table customer add constraint check_customerno check(CUSTOMERNO>=40000 and CUSTOMERNO<50000 and length(customerno::TEXT)=5);
alter table CUST_ORDER add constraint check_orderno check(ORDERNO>=50000 and ORDERNO<59999 and length(ORDERNO::TEXT)=5);
alter table ITEM add constraint check_unit_price check(UNIT_PRICE>0 and UNIT_PRICE<99999);
alter table ITEM add constraint check_itemno check(ITEMNO>=60000 and ITEMNO<70000 and length(ITEMNO::TEXT)=5);
alter table ORDER_ITEM add constraint check_qty check(QTY>0 and QTY<1000);

--Incase we need to rename constraints(Syntax examples):
alter table customer rename constraint check_customer_no to check_customerno;
alter table CUST_ORDER rename constraint check_order_no to check_orderno;

--ANSWERS:
--3. Develop a SQL query to list the details of the customers who have placed more than three orders.
SELECT * FROM CUSTOMER WHERE CUSTOMERNO IN (SELECT CUSTOMERNO FROM CUST_ORDER GROUP BY CUSTOMERNO HAVING COUNT(ORDERNO) > 3);