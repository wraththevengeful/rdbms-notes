--a. DDL to implement the schema:

CREATE TABLE CUSTOMER (
    CID SERIAL PRIMARY KEY,
    CNAME VARCHAR(255) NOT NULL
);

CREATE TABLE BRANCH (
    BCODE SERIAL PRIMARY KEY,
    BNAME VARCHAR(255) NOT NULL
);

CREATE TABLE ACCOUNT (
    ANO SERIAL PRIMARY KEY,
    ATYPE CHAR(1) CHECK (ATYPE IN ('S', 'C')),
    BALANCE DECIMAL(10,2) NOT NULL,
    CID INT,
    BCODE INT,
    FOREIGN KEY (CID) REFERENCES CUSTOMER(CID),
    FOREIGN KEY (BCODE) REFERENCES BRANCH(BCODE)
);

CREATE TABLE TRANSACTION (
    TID SERIAL PRIMARY KEY,
    ANO INT,
    TTYPE CHAR(1) CHECK (TTYPE IN ('D', 'W')),
    TTDATE DATE,
    TAMOUNT DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ANO) REFERENCES ACCOUNT(ANO)
);

--b. Populate the database with a rich data set:

-- Insert data into CUSTOMER table
INSERT INTO CUSTOMER (CNAME) VALUES ('Customer1');
INSERT INTO CUSTOMER (CNAME) VALUES ('Customer2');

-- Insert data into BRANCH table
INSERT INTO BRANCH (BNAME) VALUES ('Branch1');
INSERT INTO BRANCH (BNAME) VALUES ('Branch2');

-- Insert data into ACCOUNT table
INSERT INTO ACCOUNT (ATYPE, BALANCE, CID, BCODE) VALUES ('S', 5000.00, 1, 1);
INSERT INTO ACCOUNT (ATYPE, BALANCE, CID, BCODE) VALUES ('C', 10000.00, 1, 2);
INSERT INTO ACCOUNT (ATYPE, BALANCE, CID, BCODE) VALUES ('S', 8000.00, 2, 1);

-- Insert data into TRANSACTION table
INSERT INTO TRANSACTION (ANO, TTYPE, TTDATE, TAMOUNT) VALUES (1, 'D', '2023-01-01', 1000.00);
INSERT INTO TRANSACTION (ANO, TTYPE, TTDATE, TAMOUNT) VALUES (2, 'W', '2023-01-02', 500.00);
INSERT INTO TRANSACTION (ANO, TTYPE, TTDATE, TAMOUNT) VALUES (3, 'D', '2023-01-03', 2000.00);

--c. SQL query to list the details of customers who have a savings account and a current account:
SELECT DISTINCT C.CID, C.CNAME
FROM CUSTOMER C
JOIN ACCOUNT A1 ON C.CID = A1.CID AND A1.ATYPE = 'S'
JOIN ACCOUNT A2 ON C.CID = A2.CID AND A2.ATYPE = 'C';

--d. SQL query to list the details of branches and the number of accounts in each branch:
SELECT B.BCODE, B.BNAME, COUNT(A.ANO) AS NUM_ACCOUNTS
FROM BRANCH B
LEFT JOIN ACCOUNT A ON B.BCODE = A.BCODE
GROUP BY B.BCODE, B.BNAME;

--e. SQL query to list the details of branches where the number of accounts is less than the average number of accounts in all branches:
SELECT B.BCODE, B.BNAME, COUNT(A.ANO) AS NUM_ACCOUNTS
FROM BRANCH B
LEFT JOIN ACCOUNT A ON B.BCODE = A.BCODE
GROUP BY B.BCODE, B.BNAME
HAVING COUNT(A.ANO) < (SELECT AVG(COUNT(ANO)) FROM ACCOUNT GROUP BY BCODE);

--f. SQL query to list the details of customers who have performed three transactions on a day:
SELECT DISTINCT C.CID, C.CNAME
FROM CUSTOMER C
JOIN ACCOUNT A ON C.CID = A.CID
JOIN TRANSACTION T ON A.ANO = T.ANO
WHERE T.TTDATE IN (SELECT TTDATE FROM TRANSACTION GROUP BY TTDATE HAVING COUNT(TID) = 3);

--g. Create a view that will keep track of branch details and the number of accounts in each branch:

CREATE VIEW BranchAccountCount AS
SELECT B.BCODE, B.BNAME, COUNT(A.ANO) AS NUM_ACCOUNTS
FROM BRANCH B
LEFT JOIN ACCOUNT A ON B.BCODE = A.BCODE
GROUP BY B.BCODE, B.BNAME;

--h. Database trigger to not permit a customer to perform more than three transactions on a day:

CREATE OR REPLACE FUNCTION CheckTransactionLimit()
RETURNS TRIGGER AS $$
DECLARE
    TransactionCount INTEGER;
BEGIN
    SELECT COUNT(*) INTO TransactionCount
    FROM TRANSACTION
    WHERE ANO = NEW.ANO AND TTDATE = NEW.TTDATE;

    IF TransactionCount >= 3 THEN
        RAISE EXCEPTION 'Customer has reached the daily transaction limit.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_transaction_limit
BEFORE INSERT ON TRANSACTION
FOR EACH ROW
EXECUTE FUNCTION CheckTransactionLimit();


--i. Database trigger to update the value of BALANCE in ACCOUNT table:

CREATE OR REPLACE FUNCTION UpdateAccountBalance()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.TTYPE = 'D' THEN
        UPDATE ACCOUNT SET BALANCE = BALANCE + NEW.TAMOUNT WHERE ANO = NEW.ANO;
    ELSIF NEW.TTYPE = 'W' THEN
        IF (SELECT ATYPE FROM ACCOUNT WHERE ANO = NEW.ANO) = 'S' THEN
            UPDATE ACCOUNT SET BALANCE = BALANCE - NEW.TAMOUNT WHERE ANO = NEW.ANO AND BALANCE >= 2000.00;
        ELSIF (SELECT ATYPE FROM ACCOUNT WHERE ANO = NEW.ANO) = 'C' THEN
            UPDATE ACCOUNT SET BALANCE = BALANCE - NEW.TAMOUNT WHERE ANO = NEW.ANO AND BALANCE >= 5000.00;
        ELSE
            RAISE EXCEPTION 'Invalid account type.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_account_balance
BEFORE INSERT ON TRANSACTION
FOR EACH ROW
EXECUTE FUNCTION UpdateAccountBalance();