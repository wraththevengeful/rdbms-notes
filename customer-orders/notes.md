# NOTES FOR PSQL:

**To create a table(with primary key and foreign key):**
```create table  TABLE_NAME(attribute datatype,...attribute datatype PRIMARY KEY, attribute datatype REFERENCES tablename(attribute));```

**Alter table to set primary key constraint:**

Assuming the CUST_ORDER table already exists:
```ALTER TABLE CUST_ORDER ADD CONSTRAINT cust_order_pk PRIMARY KEY (ORDERNO);```

Rename constraint:
```alter table customer rename constraint check_start_num_and_len TO check_start_num_and_len_customer;```