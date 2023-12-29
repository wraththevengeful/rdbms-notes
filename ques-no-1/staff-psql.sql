--PSQL VERSION:

--a.Crate tables:
CREATE TABLE STAFF (
    STAFFNO INT PRIMARY KEY,
    NAME VARCHAR(25) NOT NULL,
    DOB DATE,
    GENDER CHAR(1) CHECK (GENDER IN ('M', 'F')),
    DOJ DATE,
    DESIGNATION VARCHAR(25),
    BASIC_PAY INT,
    DEPTNO INT
);

CREATE TABLE DEPT (
    DEPTNO INT PRIMARY KEY,
    NAME VARCHAR(25) NOT NULL
);

CREATE TABLE SKILL (
    SKILL_CODE INT PRIMARY KEY,
    DESCRIPTION VARCHAR(60),
    CHARGE_OUTRATE INT
);

CREATE TABLE STAFF_SKILL (
    STAFFNO INT,
    SKILL_CODE INT,
    CONSTRAINT pk_staff_skill PRIMARY KEY (STAFFNO, SKILL_CODE),
    CONSTRAINT fk_staffno_skill FOREIGN KEY (STAFFNO) REFERENCES STAFF(STAFFNO),
    CONSTRAINT fk_skillcode_skill FOREIGN KEY (SKILL_CODE) REFERENCES SKILL(SKILL_CODE)
);

CREATE TABLE PROJECT (
    PROJECTNO INT PRIMARY KEY,
    PNAME VARCHAR(25) NOT NULL,
    START_DATE DATE,
    END_DATE DATE,
    BUDGET INT,
    PROJECT_MANAGER VARCHAR(25),
    STAFFNO BIGINT,
    CONSTRAINT fk_staffno_project FOREIGN KEY (STAFFNO) REFERENCES STAFF(STAFFNO)
);

CREATE TABLE WORKS (
    STAFFNO NUMBER,
    PROJECTNO NUMBER,
    DATE_WORKED_ON DATE,
    IN_TIME TIMESTAMP,
    OUT_TIME TIMESTAMP,
    CONSTRAINT pk_works PRIMARY KEY (STAFFNO, PROJECTNO, DATE_WORKED_ON),
    CONSTRAINT fk_staffno_works FOREIGN KEY (STAFFNO) REFERENCES STAFF(STAFFNO),
    CONSTRAINT fk_projectno_works FOREIGN KEY (PROJECTNO) REFERENCES PROJECT(PROJECTNO)
); 

--b. Populating the Database:
STAFF:
INSERT INTO STAFF VALUES(1, 'John Doe', '1990-05-15', 'M', '2015-03-10', 'Manager', 60000, 1);
INSERT INTO STAFF VALUES(2, 'Jane Smith', '1988-10-22', 'F', '2018-01-20', 'Developer', 45000, 2);
INSERT INTO STAFF VALUES(3, 'Michael Johnson', '1995-07-08', 'M', '2020-06-05', 'Analyst', 55000, 1);
INSERT INTO STAFF VALUES(4, 'Emily Johnson', '1993-08-12', 'F', '2019-07-22', 'Engineer', 50000, 1);
INSERT INTO STAFF VALUES(5, 'William Brown', '1991-04-25', 'M', '2017-09-12', 'Analyst', 52000, 3);
INSERT INTO STAFF VALUES(6, 'Sophia Wilson', '1994-11-30', 'F', '2022-02-18', 'Developer', 48000, 2);
INSERT INTO STAFF VALUES(7, 'Oliver Davis', '1997-03-08', 'M', '2020-12-05', 'Manager', 65000, 1);
INSERT INTO STAFF VALUES(8, 'Ava Martinez', '1990-12-19', 'F', '2016-08-28', 'Engineer', 51000, 1);
INSERT INTO STAFF VALUES(9, 'Ethan Garcia', '1996-06-14', 'M', '2021-05-17', 'Developer', 47000, 2);
INSERT INTO STAFF VALUES(10, 'Isabella Rodriguez', '1992-09-05', 'F', '2018-11-30', 'Analyst', 54000, 3);

DEPT:
INSERT INTO DEPT VALUES(1, 'Engineering');
INSERT INTO DEPT VALUES(2, 'Marketing');
INSERT INTO DEPT VALUES(3, 'HR');
INSERT INTO DEPT VALUES(4, 'Finance');
INSERT INTO DEPT VALUES(5, 'Operations');
INSERT INTO DEPT VALUES(6, 'Sales');

SKILL:
INSERT INTO SKILL VALUES(101, 'Programming', 100);
INSERT INTO SKILL VALUES(102, 'Marketing Strategy', 120);
INSERT INTO SKILL VALUES(103, 'Database Management', 110);

STAFF_SKILL:
INSERT INTO STAFF_SKILL VALUES(1, 101);
INSERT INTO STAFF_SKILL VALUES(2, 102);
INSERT INTO STAFF_SKILL VALUES(3, 103);

--c. SQL Query to list the department number and number of staff in each department:
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

--g. SQL Query for Staff with Skills Charge Outrate > 60:

SELECT S.*
FROM STAFF S
JOIN STAFF_SKILL SS ON S.STAFFNO = SS.STAFFNO
JOIN SKILL SK ON SS.SKILL_CODE = SK.SKILL_CODE
WHERE SK.CHARGE_OUTRATE > 60; 

--h. Create a view that will keep track of the department number, the department name, the number of employees in the department, and the total basic pay expenditure for each department:
CREATE OR REPLACE VIEW DepartmentSummary AS
SELECT D.DEPTNO, D.NAME AS DEPT_NAME, COUNT(S.STAFFNO) AS NUM_OF_EMPLOYEES, SUM(S.BASIC_PAY) AS TOTAL_BASIC_PAY
FROM DEPT D
LEFT JOIN STAFF S ON D.DEPTNO = S.DEPTNO
GROUP BY D.DEPTNO, D.NAME; 

--i. Database trigger that will not permit a staff to work on more than three projects on a day:
CREATE OR REPLACE TRIGGER check_works_limit
BEFORE INSERT ON WORKS
FOR EACH ROW
DECLARE
    projects_count INT;
BEGIN
    SELECT COUNT(PROJECTNO)
    INTO projects_count
    FROM WORKS
    WHERE STAFFNO = :NEW.STAFFNO AND DATE_WORKED_ON = :NEW.DATE_WORKED_ON;

    IF projects_count >= 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Staff is not allowed to work on more than three projects in a day');
    END IF;
END;
/ 

--j. INCR Procedure:
CREATE OR REPLACE PROCEDURE INCR(staff_num IN NUMBER, increment_amount IN NUMBER)
IS
    current_basic_pay NUMBER;
BEGIN
    SELECT BASIC_PAY INTO current_basic_pay
    FROM STAFF
    WHERE STAFFNO = staff_num;

    IF current_basic_pay IS NOT NULL THEN
        UPDATE STAFF
        SET BASIC_PAY = BASIC_PAY + increment_amount
        WHERE STAFFNO = staff_num;
        DBMS_OUTPUT.PUT_LINE('Basic pay updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Staff has basic pay null');
        RAISE_APPLICATION_ERROR(-20002, 'No such staff number');
    END IF;
END;
/ 
