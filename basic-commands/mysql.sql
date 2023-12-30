--MYSQL IS CASE SENSITIVE IN TERMS OF NAMING TABLES AND ATTRIBUTES
--SO PLEASE ALWAYS USE CAPS LOCK ON AND TYPE EVERYTHING IN CAPS

--******************************************************************************************************
--USER COMMANDS:

--Show the list of users in your server:
SELECT user, host FROM mysql.user;

-- Create a new user
CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';

-- Grant all privileges on a specific database to the new user
GRANT ALL PRIVILEGES ON database_name.* TO 'newuser'@'localhost';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

--See current user:
SELECT USER();

--*****************************************************************************************************
--DATABASE COMMANDS:
--Show the list of databases in your server:
SHOW DATABASES;

-- Create a new database
CREATE DATABASE your_database_name;

-- Switch to the newly created database
USE your_database_name;

-- Drop a database (Delete):
DROP DATABASE your_database_name;

--view all databases:
SHOW DATABASES;

-- Show your current database:
SELECT DATABASE();

--Show tables of your current database:
SHOW TABLES;

--View details of a specific table:
DESCRIBE your_table_name;
