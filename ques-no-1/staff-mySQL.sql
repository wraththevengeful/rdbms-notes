--a. create tables:
-- Create STAFF table
CREATE TABLE STAFF (
    STAFFNO INT PRIMARY KEY,
    NAME VARCHAR(255) NOT NULL,
    DOB DATE,
    GENDER CHAR(1) CHECK (GENDER IN ('M', 'F')),
    DOJ DATE,
    DESIGNATION VARCHAR(255),
    BASIC_PAY DECIMAL(10, 2),
    DEPTNO INT,
    FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO)
);

-- Create DEPT table
CREATE TABLE DEPT (
    DEPTNO INT PRIMARY KEY,
    NAME VARCHAR(255) NOT NULL
);

-- Create SKILL table
CREATE TABLE SKILL (
    SKILL_CODE INT PRIMARY KEY,
    DESCRIPTION VARCHAR(255),
    CHARGE_OUTRATE DECIMAL(10, 2)
);

-- Create STAFF_SKILL table
CREATE TABLE STAFF_SKILL (
    STAFFNO INT,
    SKILL_CODE INT,
    PRIMARY KEY (STAFFNO, SKILL_CODE),
    FOREIGN KEY (STAFFNO) REFERENCES STAFF(STAFFNO),
    FOREIGN KEY (SKILL_CODE) REFERENCES SKILL(SKILL_CODE)
);

-- Create PROJECT table
CREATE TABLE PROJECT (
    PROJECTNO INT PRIMARY KEY,
    PNAME VARCHAR(255) NOT NULL,
    START_DATE DATE,
    END_DATE DATE,
    BUDGET DECIMAL(15, 2),
    PROJECT_MANAGER VARCHAR(255),
    STAFFNO INT,
    FOREIGN KEY (STAFFNO) REFERENCES STAFF(STAFFNO)
);

-- Create WORKS table
CREATE TABLE WORKS (
    STAFFNO INT,
    PROJECTNO INT,
    DATE_WORKED_ON DATE,
    IN_TIME TIME,
    OUT_TIME TIME,
    PRIMARY KEY (STAFFNO, PROJECTNO, DATE_WORKED_ON),
    FOREIGN KEY (STAFFNO) REFERENCES STAFF(STAFFNO),
    FOREIGN KEY (PROJECTNO) REFERENCES PROJECT(PROJECTNO)
); 

--b. Insert data into DEPT table
INSERT INTO DEPT VALUES (1, 'HR');
INSERT INTO DEPT VALUES (2, 'IT');

-- Insert data into SKILL table
INSERT INTO SKILL VALUES (1, 'Programming', 50.00);
INSERT INTO SKILL VALUES (2, 'Database Management', 45.00);

-- Insert data into STAFF table
INSERT INTO STAFF VALUES (101, 'John Doe', '1990-05-15', 'M', '2010-01-01', 'Manager', 80000.00, 1);
INSERT INTO STAFF VALUES (102, 'Jane Smith', '1985-08-20', 'F', '2012-03-15', 'Developer', 60000.00, 2);

-- Insert data into STAFF_SKILL table
INSERT INTO STAFF_SKILL VALUES (101, 1);
INSERT INTO STAFF_SKILL VALUES (102, 1);
INSERT INTO STAFF_SKILL VALUES (102, 2);

-- Insert data into PROJECT table
INSERT INTO PROJECT VALUES (201, 'Project A', '2023-01-01', '2023-06-30', 100000.00, 'John Doe', 101);
INSERT INTO PROJECT VALUES (202, 'Project B', '2023-02-01', '2023-07-31', 80000.00, 'Jane Smith', 102);

-- Insert data into WORKS table
INSERT INTO WORKS VALUES (101, 201, '2023-01-05', '08:00:00', '17:00:00');
INSERT INTO WORKS VALUES (102, 201, '2023-01-05', '09:00:00', '18:00:00');
INSERT INTO WORKS VALUES (102, 202, '2023-02-10', '08:30:00', '17:30:00'); 

--c.SQL Query to list the department number and number of staff in each department:
SELECT DEPTNO, COUNT(STAFFNO) AS NUM_OF_STAFF
FROM STAFF
GROUP BY DEPTNO; 

--d.SQL Query to list the details of staff who earn less than the average pay of all staff:
SELECT *
FROM STAFF
WHERE BASIC_PAY < (SELECT AVG(BASIC_PAY) FROM STAFF); 

--e. SQL Query to list the details of departments which has more than five working staff in it:
SELECT D.*
FROM DEPT D
JOIN (
    SELECT DEPTNO, COUNT(STAFFNO) AS NUM_OF_STAFF
    FROM STAFF
    GROUP BY DEPTNO
    HAVING COUNT(STAFFNO) > 5
) S ON D.DEPTNO = S.DEPTNO; 

--f. SQL Query to list the details of staff who have more than three skills:
SELECT S.*
FROM STAFF S
JOIN (
    SELECT STAFFNO, COUNT(SKILL_CODE) AS NUM_OF_SKILLS
    FROM STAFF_SKILL
    GROUP BY STAFFNO
    HAVING COUNT(SKILL_CODE) > 3
) SS ON S.STAFFNO = SS.STAFFNO; 

--g. SQL Query to list the details of staff who have skills with a charge out rate greater than 60 per hour:
SELECT S.*
FROM STAFF S
JOIN STAFF_SKILL SS ON S.STAFFNO = SS.STAFFNO
JOIN SKILL SK ON SS.SKILL_CODE = SK.SKILL_CODE
WHERE SK.CHARGE_OUTRATE > 60; 

--h. Create a view that will keep track of the department number, the department name, the number of employees in the department, and the total basic pay expenditure for each department:
CREATE VIEW DepartmentSummary AS
SELECT D.DEPTNO, D.NAME AS DEPT_NAME, COUNT(S.STAFFNO) AS NUM_OF_EMPLOYEES, SUM(S.BASIC_PAY) AS TOTAL_BASIC_PAY
FROM DEPT D
LEFT JOIN STAFF S ON D.DEPTNO = S.DEPTNO
GROUP BY D.DEPTNO, D.NAME; 

--i. Database trigger that will not permit a staff to work on more than three projects on a day:
DELIMITER //

CREATE TRIGGER check_works_limit
BEFORE INSERT ON WORKS
FOR EACH ROW
BEGIN
    DECLARE projects_count INT;
   
    SELECT COUNT(PROJECTNO)
    INTO projects_count
    FROM WORKS
    WHERE STAFFNO = NEW.STAFFNO AND DATE_WORKED_ON = NEW.DATE_WORKED_ON;
   
    IF projects_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Staff is not allowed to work on more than three projects in a day';
    END IF;
END //

DELIMITER ; 

--j.INCR Procedure:

DELIMITER //

CREATE PROCEDURE INCR(IN staff_num INT, IN increment_amount DECIMAL(10, 2))
BEGIN
    DECLARE current_basic_pay DECIMAL(10, 2);

    -- Check if the staff number exists
    SELECT BASIC_PAY INTO current_basic_pay
    FROM STAFF
    WHERE STAFFNO = staff_num;
   
    IF current_basic_pay IS NOT NULL THEN
        -- Increment the basic pay
        UPDATE STAFF
        SET BASIC_PAY = BASIC_PAY + increment_amount
        WHERE STAFFNO = staff_num;
        SELECT 'Basic pay updated successfully' AS MESSAGE;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No such staff number';
    END IF;
END //

DELIMITER ; 

--You can call this procedure by providing the staff number and the increment amount as follows: ALL INCR(123, 500.00);