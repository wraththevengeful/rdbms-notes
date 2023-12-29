# Consider the following relational schema for a banking database application:

CUSTOMER(**CID**, CNAME),
BRANCH(**BCODE**, BNAME),
ACCOUNT(**ANO**, ATYPE, BALANCE, CID, BCODE);

An account can be a savings account or a current account. Check ATYPE ins 'S' or 'C'. A customer can have both types of accounts.

TRANSACTION(**TID**, ANO, TTYPE, TTDATE, TAMOUNT)
TTYPE CAN BE 'D' OR 'W'.

D - Deposit; W - Withdrawal.

The primary keys are of this style: **EXAMPLE**

a. Develop DDL to implement the above schema specifying the appropriate data types for each attribute enforcing primary key, check constraints and foreign key constraints.

b. Populate the database with a rich data set.

c. Develop a SQL query to list the details of customers who have a savings account and a current account.

d. Develop a SQL query to list the details of branches and the number of accounts in each branch.

e. Develop a SQL query to list the details of branches where the number of accounts is less than the average number of accounts in all branches.

f. Develop a SQL query to list the details of customers who have performed three transactions on a day.

g. Create a view that will keep track of branch details and the number of accounts in each branch.

h. Develop a database trigger that will not permit a customer to perform more than three transactions on a day.

i. Develop a database trigger that will update the value of BALANCE in ACCOUNT table when a record is inserted in the transaction table. Consider the following cases:
    1. If TTYPE = 'D' the value of BALANCE in the ACCOUNT table must be incremented by the value of TAMOUNT.

    2. If TTYPE = 'W' the value of BALANCE in the ACCOUNT table must be decremented by the value of TAMOUNT if a minimum balance of Rs. 2000/- will be maintained for a savings account and a minimum balance of Rs. 5000/- will be maintained for a current account else appropriate messages will be displayed.