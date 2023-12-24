--customer table:
INSERT INTO CUSTOMER(CUSTOMERNO, CNAME, CITY) VALUES(40001,'Arul','Chennai'),(40002,'Mathew','Chennai'),(40003,'Ruban','Kanchipuram'),(40004,'Chezhiyan','Villupuram'),(40005,'Kokila','Tiruvannamalai'),(40006,'Aishwarya','Chengalpattu'),(40007,'Shakthi','Tiruvannnamalai'),(40008,'Shiva','Madurai'),(40009,'Periyasamy','Pudukottai'),(40010,'Aashish','Trichy');
insert into customer(customerno, cname, city) values(40000,'Vijay','Goa');

--cust_order table:
INSERT INTO CUST_ORDER(ORDERNO, ODATE, CUSTOMERNO, ORD_AMT) VALUES(50000,'2023-12-01',40000,1),(50001,'2023-12-11',40001,2),(50003,'2023-12-10',40003,3),(50004,'2023-12-11',40004,22),(50005,'2023-12-08',40005,12),(50006,'2023-12-19',40006,9),(50007,'2023-12-17',40007,7),(50008,'2023-12-11',40008,8),(50009,'2023-12-01',40009,23),(50010,'2023-12-15',40010,4);

--item table:
INSERT INTO ITEM(ITEMNO, ITEM_NAME, UNIT_PRICE)VALUES(60000,'Nebulizer',2999),(60001,'Phone Case',349),(60002,'Earphones',749),(60003,'AUX Cable',199),(60004,'Glasses',259),(60005,'Water Bottle',339),(60006,'Shirt',499),(60007,'Watch',1199),(60008,'Notebook',89),(60009,'Bag',649),(60010,'Pen',49);

--order_item:
INSERT INTO ORDER_ITEM(ORDERNO,ITEMNO,QTY)VALUES(50000,60000,10),(50001,60001,6),(50003,60002,4),(50003,60003,5),(50004,60004,16),(50005,60005,6),(50006,60006,9),(50007,60007,6),(50008,60008,8),(50009,60009,19),(50010,60010,4);