Consider the following relational schema for a company database
application:

EMPLOYEE (**ENO**, NAME, GENDER, DOB, DOJ, DESIGNATION, BASIC, DEPT NO, PANNO, SENO)

Implement a Check Constraint for GENDER

PAN-Permanent account Number

SENO-Supervy Employee Number

DEPARTMENT (**DEPT_NO**, NAME, MENO, NOE)

MENO - Manager Employee Number

NOE-Number of Employees

The default value of NOE is 0

PROJECT (**PROJ_NO**, NAME, DEPT_NO)

WORKSFOR (**ENO, PROJ_NO, DATE_WORKED**, HOURS)

Each department has a manager managing it. There are also supervisors in each department who supervise a set of employees. A department can control any number of projects But only one department can control a project. An employee can work on any number of distinct projects on a given day. The Primary Key of each relation is underlined
