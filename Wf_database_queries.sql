-- QUERIES --

-- Finding all employees that do not work for branch 103 and 104 --
SELECT * FROM wf_employee WHERE NOT branch_id = 103 AND NOT branch_id = 104
ORDER BY branch_id ASC;

-- Finding all employees whos salary is not greater than 50k a year --
SELECT * FROM wf_employee WHERE NOT salary > 50000
ORDER BY salary DESC;

-- Finding all unique positions in employees table --
SELECT DISTINCT position from wf_employee;
SELECT COUNT(DISTINCT position) FROM wf_employee;

-- Find all employees who are ages 22-26 --
SELECT * FROM wf_employee WHERE birth_date BETWEEN '1998/01/01' AND '2002/01/01'
ORDER BY birth_date ASC;

-- Find all employees who make over 100k and work in branch 110 --
SELECT * FROM wf_employee WHERE branch_id = 110 AND salary > 100000;

-- Find all Bank tellers that work in branch 101 or 108 --
SELECT * FROM wf_employee WHERE position = 'Bank Teller' AND branch_id IN (101, 108)
ORDER BY branch_id ASC;

-- Update Customer with id 19936 email to merlinemaccorley01@gmail.com --
UPDATE wf_customer SET email = 'merlinemaccorley01@gmail.com'
WHERE customer_id = 19936;

-- Update customer with the first name Josephine, last name Whetson current credit score from 595 to 633 --
UPDATE wf_customer SET credit_score = 633
WHERE first_name = 'Josephine' AND last_name = 'Whetson';

-- Give all current Bank tellers at branch 105 a 1k raise --
BEGIN TRAN
UPDATE wf_employee SET salary = salary + 1000
WHERE position = 'Bank Teller' AND branch_id = 105;
rollback tran

-- Delete terminated employees with employee ids 03-4170083 and 01-2158087 --
BEGIN TRAN
DELETE FROM wf_employee
WHERE employee_id = '03-4170083' OR employee_id = '01-2158087'
ROLLBACK TRAN

-- Select the top 10 highest paid employees from branch 110 --
SELECT TOP 10 salary, branch_id, first_name, last_name
FROM wf_employee
WHERE branch_id = 110
ORDER BY salary DESC;

-- Find the highest and lowest loan amounts --
SELECT MAX(loan_amount) AS Highest_loan, MIN(loan_amount) AS Lowest_loan
FROM wf_loans;

-- Find how many employees work in branch 103 --
SELECT COUNT(employee_id) AS employee_count_103
FROM wf_employee
WHERE branch_id = 103;

-- Finding the Max and Min loans --
SELECT MAX(loan_amount) AS Highest_Loan FROM wf_loans; 
SELECT MIN(loan_amount) AS Lowest_Loan FROM wf_loans; 

-- Find how many savings accounts have a balance of greater than 20,000 --
SELECT COUNT(account_id) AS savings_account_count
FROM wf_account
WHERE account_type = 'savings' AND balance > 20000;

-- Find the total amount loaned out --
SELECT SUM(loan_amount) AS loan_amount_sum
FROM wf_loans;

-- Find the average loan amount --
SELECT CAST(AVG(loan_amount) AS Decimal(10,2)) AS avg_loan_amount
FROM wf_loans;

-- Find the average customer credit score --
SELECT AVG(credit_score) AS avg_credit_score
FROM wf_customer;

-- Find all customers with less than the average credit score --
SELECT * FROM wf_customer
WHERE credit_score < (SELECT AVG(credit_score) FROM wf_customer)
ORDER BY credit_score DESC;

-- Find all employees whos first name start with A and last name starts with M --
SELECT * FROM wf_employee 
WHERE first_name LIKE 'A%' AND last_name LIKE 'M%';

-- Find all customers whos first name starts with Av --
SELECT * FROM wf_customer
WHERE first_name LIKE 'Av%';

-- Find all employees whos last names start with either x y or z --
SELECT * FROM wf_employee
WHERE last_name LIKE '[xyz]%'
ORDER BY last_name ASC;

-- Find all employees who work in Accounting, Human Resources, and Personal Bankers --
SELECT * FROM wf_employee WHERE position IN ('Accounting', 'Human Resources', 'Personal Banker');

-- Find all customers that have taken out loans --
SELECT * FROM wf_customer 
WHERE customer_id IN (SELECT customer_id FROM wf_loans);

-- Find all customers that have a savings account with a balance of atleast 80k --
SELECT * FROM wf_customer
WHERE customer_id IN (SELECT customer_id FROM wf_account WHERE account_type = 'savings' AND balance > 80000);

-- Find all current loans with an apr between 25% and 30% --
SELECT loan_id, customer_id, loan_type, loan_amount, CONCAT(loan_apr, '%') AS loan_apr_percent
FROM wf_loans
WHERE loan_apr BETWEEN 25.00 AND 30.00;

-- Find all mortgage and auto loans between 2k and 5k --
SELECT * FROM wf_loans
WHERE loan_amount BETWEEN 2000 AND 5000
AND loan_type IN('mortgage', 'auto')
ORDER BY loan_amount DESC;

-- Join Queries --

-- Inner join between customer and loan table --
SELECT wf_loans.loan_id, wf_loans.customer_id, first_name, last_name, credit_score, loan_type, loan_amount, loan_apr, loan_term_months
FROM wf_loans 
INNER JOIN wf_customer ON 
wf_loans.customer_id = wf_customer.customer_id
ORDER BY loan_id ASC;

-- Inner Join between branch and employee table --
SELECT wf_branch.branch_id, branch_address, wf_employee.employee_id, first_name, last_name, position
FROM wf_branch
JOIN wf_employee ON
wf_branch.branch_id = wf_employee.branch_id
ORDER BY branch_id ASC;

-- Left join to find customers who have an account and taken out a loan --
SELECT * FROM wf_loans
LEFT JOIN wf_account ON
wf_loans.customer_id = wf_account.customer_id
ORDER BY loan_id;

-- Right join to find customers who have an account and taken out a loan --
SELECT * FROM wf_account
RIGHT JOIN wf_loans ON
wf_account.customer_id = wf_loans.customer_id
ORDER BY loan_id;

-- Left join to find customers who have an account and have made a transaction --
SELECT * FROM wf_transaction
LEFT JOIN wf_account ON
wf_transaction.customer_id = wf_account.customer_id;

-- Right join to find customers who have an account and have made a transaction --
SELECT * FROM wf_account
RIGHT JOIN wf_transaction ON
wf_transaction.customer_id = wf_account.customer_id;



-- Triple Join between transaction, employee, and customer table --
SELECT wf_transaction.transaction_id, wf_employee.employee_id, wf_employee.first_name AS employee_first_name, wf_employee.last_name AS employee_last_name,
wf_customer.customer_id, wf_customer.first_name AS customer_first_name, wf_customer.last_name AS customer_last_name, transaction_type, transaction_amount, transaction_date
FROM wf_transaction
JOIN wf_employee ON
wf_employee.employee_id = wf_transaction.employee_id
JOIN wf_customer ON
wf_customer.customer_id = wf_transaction.customer_id
ORDER BY transaction_id ASC;

-- All first names from employee and customer table including duplicates --
SELECT first_name FROM wf_employee
UNION ALL
SELECT first_name FROM wf_customer
ORDER BY first_name ASC;

-- Non duplicate first names from employee and customer table --
SELECT first_name FROM wf_employee
UNION
SELECT first_name FROM wf_customer
ORDER BY first_name ASC;

-- Find out how many employees work in each position --
SELECT COUNT(employee_id) AS total_employees, position
FROM wf_employee
GROUP BY position
ORDER BY total_employees DESC;

-- Find out how many customers have a checking and how many have a savings account --
SELECT COUNT(account_id) AS total_customers, account_type
FROM wf_account 
GROUP BY account_type
ORDER BY total_customers ASC;

-- Find out how many total accounts have a very good credit score of 750 or more --
SELECT COUNT(account_id) AS total_accounts, credit_score
FROM wf_account 
JOIN wf_customer ON
wf_account.customer_id = wf_customer.customer_id
GROUP BY credit_score
HAVING credit_score > 750;

-- Find out how many customers have taken a personal loan with less than 15% apr --
SELECT COUNT(loan_id) AS total_loan, loan_type
FROM wf_loans
WHERE loan_type = 'personal' AND loan_apr < 15.00
GROUP BY loan_type;

-- Check to see the first and last names that exist of people who have loans of less than 5000 --
SELECT first_name, last_name
FROM wf_customer
WHERE EXISTS(SELECT loan_amount FROM wf_loans
WHERE wf_customer.customer_id = wf_loans.customer_id AND loan_amount < 5000); 

-- Check wether its true if there were any wire transfers on 2023/03/01 --
SELECT transaction_date FROM wf_transaction
WHERE transaction_date = ANY
(SELECT transaction_date FROM wf_transaction
WHERE transaction_date = '2023/03/01' AND transaction_type = 'wire transfer');

-- Views --
GO
CREATE VIEW view_wf_account_customer_join AS
SELECT TOP 1000 wf_account.account_id, branch_id, wf_account.customer_id, first_name, last_name, account_type, CONCAT('$', balance) AS balance, date_opened
FROM wf_customer
JOIN wf_account ON 
wf_customer.customer_id = wf_account.customer_id
ORDER BY account_id;
SELECT * FROM view_wf_account_customer_join;

GO
CREATE VIEW view_wf_loans_customer_join AS
SELECT TOP 1000 wf_loans.loan_id, wf_loans.customer_id, first_name, last_name, credit_score, loan_type, loan_amount, loan_apr, loan_term_months
FROM wf_loans 
INNER JOIN wf_customer ON 
wf_loans.customer_id = wf_customer.customer_id
ORDER BY loan_id ASC;
SELECT * FROM view_wf_loans_customer_join;

GO
CREATE VIEW view_wf_branch_employee AS
SELECT TOP 1000 wf_branch.branch_id, branch_address, wf_employee.employee_id, first_name, last_name, position
FROM wf_branch
JOIN wf_employee ON
wf_branch.branch_id = wf_employee.branch_id
ORDER BY branch_id ASC;
SELECT * FROM view_wf_branch_employee;

GO
CREATE VIEW view_transaction_employee_customer_join AS
SELECT TOP 1000 wf_transaction.transaction_id, wf_employee.employee_id, wf_employee.first_name AS employee_first_name, wf_employee.last_name AS employee_last_name,
wf_customer.customer_id, wf_customer.first_name AS customer_first_name, wf_customer.last_name AS customer_last_name, transaction_type, transaction_amount, transaction_date
FROM wf_transaction
JOIN wf_employee ON
wf_employee.employee_id = wf_transaction.employee_id
JOIN wf_customer ON
wf_customer.customer_id = wf_transaction.customer_id
ORDER BY transaction_id ASC;
SELECT * FROM view_transaction_employee_customer_join;
-- Views --

-- CASE Queries --

-- Case querie that rates customers credit score from poor to exceptional --
SELECT customer_id, first_name, last_name, credit_score,
CASE
	WHEN credit_score >= 300 AND credit_score <= 579  THEN 'This customer has poor credit'
	WHEN credit_score > 579 AND credit_score <= 669 THEN 'This customer has fair credit score'
	WHEN credit_score > 669 AND credit_score <= 739 THEN 'This customer has good credit score'
	WHEN credit_score > 739 AND credit_score <= 799 THEN 'This customer has very good credit score'
	WHEN credit_score > 799 AND credit_score <= 850 THEN 'This customer has Exceptional credit score'
	ELSE 'this credit score does not fall into the FICO Score range'
END AS credit_score_check
FROM wf_customer
ORDER BY credit_score ASC;

-- Case querie that checks if savings accounts are eligible for cash bonus --
SELECT account_id, customer_id, account_type, balance,
CASE
	WHEN balance > 5000 AND balance <= 9999 THEN 'You qualify for 200$ cash bonus'
	WHEN balance > 10000  AND balance <= 39999 THEN 'You qualify for 1000$ cash bonus'
	WHEN balance > 40000 AND balance <= 69999 THEN 'You qualify for 2500$ cash bonus'
	WHEN balance > 70000 AND balance <= 89999 THEN 'You qualify for 5000$ cash bonus'
	WHEN balance > 90000 THEN 'You qualify for 10000$ cash bonus!!!'
	ELSE 'Balance too low to qualify for cash bonus'
END AS cash_bonus_eligibility
FROM wf_account
ORDER BY balance ASC;

-- Case querie that checks wether an employee is eligible for raise --
SELECT employee_id, branch_id, first_name, last_name, position,
CASE 
	WHEN branch_id = 101 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	WHEN branch_id = 104 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	WHEN branch_id = 108 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	WHEN branch_id = 110 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	ELSE 'Sorry you do not qualify for a raise at this time'
END AS employee_raise_eligibility
FROM wf_employee
ORDER BY branch_id ASC;

-- Stored Procedures --

-- Procedure to easily find all branch managers --
CREATE PROCEDURE find_branch_managers @position varchar(30) AS
SELECT * FROM wf_employee WHERE position = @position
EXEC find_branch_managers @position = 'Branch Manager';

-- Procedure to find what branches checking accounts belong to --
CREATE PROCEDURE find_checking_account_branch @branch tinyint, @account varchar(20) AS
SELECT * FROM wf_account WHERE branch_id = @branch AND account_type = @account;
EXEC find_checking_account_branch @branch = 105, @account = 'checking';

-- Procedure for CASE statement --
CREATE PROCEDURE case_raise AS
SELECT employee_id, branch_id, first_name, last_name, position,
CASE 
	WHEN branch_id = 101 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	WHEN branch_id = 104 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	WHEN branch_id = 108 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	WHEN branch_id = 110 AND position = 'Bank Teller' THEN 'You qualify for 2 dollar raise'
	ELSE 'Sorry you do not qualify for a raise at this time'
END AS employee_raise_eligibility
FROM wf_employee
ORDER BY branch_id ASC;
EXEC case_raise;

-- Procedure for CASE statement --
CREATE PROCEDURE case_credit_score AS 
SELECT customer_id, first_name, last_name, credit_score,
CASE
	WHEN credit_score >= 300 AND credit_score <= 579  THEN 'This customer has poor credit'
	WHEN credit_score > 579 AND credit_score <= 669 THEN 'This customer has fair credit score'
	WHEN credit_score > 669 AND credit_score <= 739 THEN 'This customer has good credit score'
	WHEN credit_score > 739 AND credit_score <= 799 THEN 'This customer has very good credit score'
	WHEN credit_score > 799 AND credit_score <= 850 THEN 'This customer has Exceptional good credit score'
	ELSE 'this credit score does not fall into the FICO Score range'
END AS credit_score_check
FROM wf_customer
ORDER BY credit_score ASC;
EXEC case_credit_score;
