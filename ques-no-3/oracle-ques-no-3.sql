-- a. DDL to implement the schema
-- Assume that the user already has a schema (e.g., EX3_COMPANYDB)

CREATE TABLE DEPARTMENT (
    DEPT_NO NUMBER PRIMARY KEY,
    NAME VARCHAR2(255),
    MENO NUMBER
);

CREATE TABLE EMPLOYEE (
    ENO NUMBER PRIMARY KEY,
    NAME VARCHAR2(255),
    GENDER CHAR(1) CHECK (GENDER IN ('M', 'F')),
    DOB DATE,
    DOJ DATE,
    DESIGNATION VARCHAR2(255),
    BASIC NUMBER,
    DEPT_NO NUMBER,
    PAN VARCHAR2(20),
    SENO NUMBER,
    CONSTRAINT FK_DEPT FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENT(DEPT_NO),
    CONSTRAINT FK_EMPLOYEE FOREIGN KEY (SENO) REFERENCES EMPLOYEE(ENO)
);

CREATE TABLE PROJECT (
    PROJ_NO NUMBER PRIMARY KEY,
    NAME VARCHAR2(255),
    DEPT_NO NUMBER,
    CONSTRAINT FK_PROJ_DEPT FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENT(DEPT_NO)
);

CREATE TABLE WORKSFOR (
    ENO NUMBER,
    PROJ_NO NUMBER,
    DATE_WORKED DATE,
    HOURS NUMBER,
    PRIMARY KEY (ENO, PROJ_NO, DATE_WORKED),
    CONSTRAINT FK_WF_EMPLOYEE FOREIGN KEY (ENO) REFERENCES EMPLOYEE(ENO),
    CONSTRAINT FK_WF_PROJECT FOREIGN KEY (PROJ_NO) REFERENCES PROJECT(PROJ_NO)
);

-- b. Populate the database with a rich data set

-- Inserting 5 departments
INSERT INTO DEPARTMENT (DEPT_NO, NAME, MENO) VALUES
  (1, 'Human Resources', 101),
  (2, 'Information Technology', 102),
  (3, 'Finance', 103),
  (4, 'Marketing', 104),
  (5, 'Operations', 105);


-- Inserting 50 employees

-- Department 1
INSERT INTO EMPLOYEE (ENO, NAME, GENDER, DOB, DOJ, DESIGNATION, BASIC, DEPT_NO, PAN, SENO) VALUES
  (101, 'John Doe', 'M', '1980-01-15', '2020-02-01', 'Manager', 80000.00, 1, 'ABCDE1234F', NULL),
  (102, 'Jane Smith', 'F', '1985-05-20', '2019-10-15', 'Supervisor', 65000.00, 1, 'XYZ123456M', NULL),
  (103, 'Bob Johnson', 'M', '1990-11-30', '2021-03-10', 'Analyst', 55000.00, 1, 'PQR789012G', 102),
  (104, 'Alice Brown', 'F', '1982-08-25', '2018-12-05', 'Developer', 75000.00, 1, 'LMN456789K', 102),
  (105, 'Eva White', 'F', '1992-04-12', '2022-01-20', 'Developer', 70000.00, 1, 'STU789012X', 102),
  (106, 'Michael Green', 'M', '1983-06-18', '2017-09-08', 'Analyst', 58000.00, 1, 'ABC123456H', 102),
  (107, 'Emily Davis', 'F', '1991-10-22', '2019-11-30', 'Developer', 82000.00, 1, 'XYZ456789M', 102),
  (108, 'Daniel Wilson', 'M', '1987-03-14', '2020-07-12', 'Developer', 67000.00, 1, 'PQR789012N', 102),
  (109, 'Sophia Adams', 'F', '1984-12-08', '2018-04-25', 'Analyst', 56000.00, 1, 'LMN456789O', 102),
  (110, 'Matthew Hall', 'M', '1993-02-05', '2022-03-15', 'Developer', 78000.00, 1, 'STU789012P', 102);

-- Department 2
INSERT INTO EMPLOYEE (ENO, NAME, GENDER, DOB, DOJ, DESIGNATION, BASIC, DEPT_NO, PAN, SENO) VALUES
  (111, 'Olivia Taylor', 'F', '1986-07-31', '2017-12-10', 'Manager', 69000.00, 2, 'JKL456789Q', NULL),
  (112, 'Christopher Martin', 'M', '1995-05-17', '2019-08-22', 'Supervisor', 59000.00, 2, 'ABC123456R', NULL),
  (113, 'Ava Anderson', 'F', '1989-09-28', '2021-01-05', 'Analyst', 85000.00, 2, 'XYZ456789S', 112),
  (114, 'William Garcia', 'M', '1981-03-03', '2018-06-18', 'Developer', 72000.00, 2, 'PQR789012T', 112),
  (115, 'Emma Martinez', 'F', '1990-11-15', '2022-02-28', 'Analyst', 60000.00, 2, 'LMN456789U', 112),
  (116, 'Alexander Smith', 'M', '1994-08-08', '2017-10-12', 'Developer', 80000.00, 2, 'STU789012V', 112),
  (117, 'Madison Turner', 'F', '1982-12-20', '2019-03-26', 'Developer', 67000.00, 2, 'JKL456789W', 112),
  (118, 'Nicholas Davis', 'M', '1987-06-23', '2020-09-14', 'Analyst', 55000.00, 2, 'ABC123456X', 112),
  (119, 'Chloe Harris', 'F', '1991-04-05', '2018-07-30', 'Developer', 76000.00, 2, 'XYZ456789Y', 112),
  (120, 'Daniel White', 'M', '1984-10-12', '2021-04-02', 'Developer', 70000.00, 2, 'PQR789012Z', 112);

-- Department 3
INSERT INTO EMPLOYEE (ENO, NAME, GENDER, DOB, DOJ, DESIGNATION, BASIC, DEPT_NO, PAN, SENO) VALUES
  (121, 'Grace Lopez', 'F', '1993-07-19', '2017-11-15', 'Manager', 58000.00, 3, 'LMN456789AA', NULL),
  (122, 'Joseph Brown', 'M', '1985-01-28', '2019-01-22', 'Supervisor', 84000.00, 3, 'STU789012AB', NULL),
  (123, 'Ella Rodriguez', 'F', '1990-05-09', '2022-03-10', 'Developer', 72000.00, 3, 'JKL456789AC', 122),
  (124, 'Jackson Harris', 'M', '1982-09-14', '2018-05-05', 'Developer', 60000.00, 3, 'ABC123456AD', 122),
  (125, 'Aria Davis', 'F', '1987-12-25', '2020-08-18', 'Developer', 78000.00, 3, 'XYZ456789AE', 122),
  (126, 'Logan Turner', 'M', '1995-04-30', '2017-09-05', 'Developer', 67000.00, 3, 'PQR789012AF', 122),
  (127, 'Zoe Taylor', 'F', '1989-11-03', '2019-12-12', 'Developer', 55000.00, 3, 'LMN456789AG', 122),
  (128, 'Gabriel Martin', 'M', '1981-05-18', '2022-01-28', 'Developer', 82000.00, 3, 'STU789012AH', 122),
  (129, 'Penelope Garcia', 'F', '1986-08-22', '2018-03-10', 'Developer', 69000.00, 3, 'JKL456789AI', 122),
  (130, 'Carter Turner', 'M', '1992-02-15', '2021-06-05', 'Developer', 58000.00, 3, 'ABC123456AJ', 122);

-- Department 4
INSERT INTO EMPLOYEE (ENO, NAME, GENDER, DOB, DOJ, DESIGNATION, BASIC, DEPT_NO, PAN, SENO) VALUES
  (131, 'Scarlett Brown', 'F', '1983-09-10', '2017-10-20', 'Manager', 85000.00, 4, 'XYZ456789AK', NULL),
  (132, 'Henry Martin', 'M', '1988-01-28', '2019-11-15', 'Supervisor', 71000.00, 4, 'PQR789012AL', NULL),
  (133, 'Lily Turner', 'F', '1994-05-09', '2022-02-10', 'Analyst', 59000.00, 4, 'LMN456789AM', 132),
  (134, 'Leo Harris', 'M', '1980-09-14', '2018-06-18', 'Developer', 80000.00, 4, 'STU789012AN', 132),
  (135, 'Sophie Davis', 'F', '1985-12-25', '2020-09-10', 'Developer', 69000.00, 4, 'JKL456789AO', 132),
  (136, 'Lucas Smith', 'M', '1991-04-30', '2017-11-05', 'Developer', 58000.00, 4, 'ABC123456AP', 132),
  (137, 'Mia Rodriguez', 'F', '1987-11-03', '2019-12-12', 'Developer', 82000.00, 4, 'XYZ456789AQ', 132),
  (138, 'Elijah Martin', 'M', '1982-05-18', '2022-01-28', 'Developer', 71000.00, 4, 'PQR789012AR', 132),
  (139, 'Ava Turner', 'F', '1989-08-22', '2018-03-10', 'Developer', 59000.00, 4, 'LMN456789AS', 132),
  (140, 'Oliver Davis', 'M', '1995-02-15', '2021-06-05', 'Developer', 78000.00, 4, 'STU789012AT', 132);

-- Department 5
INSERT INTO EMPLOYEE (ENO, NAME, GENDER, DOB, DOJ, DESIGNATION, BASIC, DEPT_NO, PAN, SENO) VALUES
  (141, 'Emma Brown', 'F', '1983-09-10', '2017-10-20', 'Manager', 69000.00, 5, 'JKL456789AU', NULL),
  (142, 'Noah Martin', 'M', '1988-01-28', '2019-11-15', 'Supervisor', 71000.00, 5, 'PQR789012AV', NULL),
  (143, 'Isabella Turner', 'F', '1994-05-09', '2022-02-10', 'Developer', 80000.00, 5, 'LMN456789AW', 142),
  (144, 'Liam Harris', 'M', '1980-09-14', '2018-06-18', 'Developer', 75000.00, 5, 'STU789012AX', 142),
  (145, 'Aiden Davis', 'F', '1985-12-25', '2020-09-10', 'Developer', 59000.00, 5, 'JKL456789AY', 142),
  (146, 'Ella Smith', 'M', '1991-04-30', '2017-11-05', 'Developer', 82000.00, 5, 'PQR789012AZ', 142),
  (147, 'Mason Rodriguez', 'F', '1987-11-03', '2019-12-12', 'Developer', 71000.00, 5, 'LMN456789BA', 142),
  (148, 'Sophia Martin', 'M', '1982-05-18', '2022-01-28', 'Developer', 58000.00, 5, 'STU789012BB', 142),
  (149, 'Jackson Turner', 'F', '1989-08-22', '2018-03-10', 'Developer', 75000.00, 5, 'JKL456789BC', 142),
  (150, 'Lily Davis', 'M', '1995-02-15', '2021-06-05', 'Developer', 69000.00, 5, 'PQR789012BD', 142); 

-- Inserting 7 projects
INSERT INTO PROJECT (PROJ_NO, NAME, DEPT_NO) VALUES
  (501, 'Employee Portal', 2),
  (502, 'Payroll System', 3),
  (503, 'Training Program', 1),
  (504, 'Product Launch', 4),
  (505, 'Website Redesign', 2),
  (506, 'Financial Analysis', 3),
  (507, 'Inventory Management', 5);


-- Inserting data into WORKSFOR table
INSERT INTO WORKSFOR (ENO, PROJ_NO, DATE_WORKED, HOURS) VALUES
  (101, 501, '2023-01-10', 40),
  (102, 501, '2023-01-10', 32),
  (103, 503, '2023-01-12', 20),
  (104, 502, '2023-01-15', 45),
  (105, 506, '2023-01-18', 38),
  (106, 504, '2023-01-20', 42),
  (107, 507, '2023-01-22', 25),
  (108, 505, '2023-01-25', 30),
  (109, 503, '2023-01-28', 35),
  (110, 504, '2023-02-01', 40),
  (111, 506, '2023-02-05', 28),
  (112, 503, '2023-02-08', 33),
  (113, 504, '2023-02-10', 36),
  (114, 502, '2023-02-15', 42),
  (115, 507, '2023-02-18', 20),
  (116, 505, '2023-02-20', 30),
  (117, 506, '2023-02-22', 25),
  (118, 504, '2023-02-25', 38),
  (119, 502, '2023-02-28', 40),
  (120, 505, '2023-03-05', 22),
  (121, 503, '2023-03-10', 28),
  (122, 506, '2023-03-12', 32),
  (123, 504, '2023-03-15', 25),
  (124, 502, '2023-03-18', 30),
  (125, 505, '2023-03-20', 35),
  (126, 507, '2023-03-22', 40),
  (127, 506, '2023-03-25', 42),
  (128, 503, '2023-03-28', 18),
  (129, 504, '2023-04-01', 22),
  (130, 502, '2023-04-05', 30),
  (131, 505, '2023-04-10', 32),
  (132, 507, '2023-04-12', 25),
  (133, 506, '2023-04-15', 38),
  (134, 503, '2023-04-18', 42),
  (135, 504, '2023-04-20', 30),
  (136, 502, '2023-04-22', 28),
  (137, 505, '2023-04-25', 35),
  (138, 506, '2023-04-28', 20),
  (139, 503, '2023-05-01', 30),
  (140, 504, '2023-05-05', 40),
  (141, 502, '2023-05-10', 22),
  (142, 506, '2023-05-12', 32),
  (143, 504, '2023-05-15', 25),
  (144, 505, '2023-05-18', 38),
  (145, 503, '2023-05-20', 42),
  (146, 504, '2023-05-22', 30),
  (147, 502, '2023-05-25', 28),
  (148, 506, '2023-05-28', 35),
  (149, 503, '2023-06-01', 18),
  (150, 504, '2023-06-05', 22);


-- c. SQL query to list departments and details of the manager in each department
SELECT D.*, M.NAME AS MANAGER_NAME
FROM DEPARTMENT D
JOIN EMPLOYEE M ON D.MENO = M.ENO;

-- d. SQL query to list details of all employees and the details of their supervisors
SELECT E.*, S.NAME AS SUPERVISOR_NAME
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE S ON E.SENO = S.ENO;

-- e. SQL query to list department number, department name, and the number of employees in each department
SELECT D.DEPT_NO, D.NAME, COUNT(E.ENO) AS NUM_EMPLOYEES
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.DEPT_NO = E.DEPT_NO
GROUP BY D.DEPT_NO, D.NAME;

-- f. SQL query to list details of employees earning less than the average basic pay of all employees
SELECT *
FROM EMPLOYEE
WHERE BASIC < (SELECT AVG(BASIC) FROM EMPLOYEE);

-- g. SQL query to list details of departments with more than six employees
SELECT D.*, COUNT(E.ENO) AS NUM_EMPLOYEES
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.DEPT_NO = E.DEPT_NO
GROUP BY D.DEPT_NO, D.NAME
HAVING COUNT(E.ENO) > 6;

-- h. Create a view to track department details, the number of employees, and total basic pay expenditure
CREATE VIEW DEPARTMENT_SUMMARY AS
SELECT D.DEPT_NO, D.NAME, COUNT(E.ENO) AS NUM_EMPLOYEES, SUM(E.BASIC) AS TOTAL_BASIC_PAY
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.DEPT_NO = E.DEPT_NO
GROUP BY D.DEPT_NO, D.NAME;

-- i. Database trigger to prevent an employee from working on more than three projects in a day
CREATE OR REPLACE TRIGGER enforce_project_count
BEFORE INSERT ON WORKSFOR
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM WORKSFOR WHERE ENO = :NEW.ENO AND DATE_WORKED = :NEW.DATE_WORKED) >= 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee cannot work on more than three projects in a day');
    END IF;
END enforce_project_count;

-- j. Procedure INCR to update the basic pay of an employee
CREATE OR REPLACE PROCEDURE INCR(employee_number NUMBER, increment_amount NUMBER) AS
BEGIN
    UPDATE EMPLOYEE
    SET BASIC = COALESCE(BASIC, 0) + increment_amount
    WHERE ENO = employee_number;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No such employee number');
    END IF;

    IF :NEW.BASIC IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'Employee has basic pay null');
    END IF;
END INCR;
/
