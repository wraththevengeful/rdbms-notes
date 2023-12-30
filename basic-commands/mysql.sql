--Show the list of databases in your server:
SHOW DATABASES;

--Show the list of users in your server:
SELECT user, host FROM mysql.user;

--******************************************************************************************************
--CREATING AN USER:
-- Create a new user
CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';

-- Grant all privileges on a specific database to the new user
GRANT ALL PRIVILEGES ON database_name.* TO 'newuser'@'localhost';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;
--*****************************************************************************************************

-- Create a new database
CREATE DATABASE your_database_name;

-- Switch to the newly created database
USE your_database_name;

-- Drop a database (Delete):
DROP DATABASE your_database_name;

-- Show your current database:
SELECT DATABASE();