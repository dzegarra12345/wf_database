-- TABLE CREATION --
CREATE TABLE wf_employee (
	employee_id varchar(30) NOT NULL,
	branch_id tinyint NOT NULL,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	birth_date date NOT NULL,
	position varchar(30) NOT NULL,
	salary int NOT NULL,
	ssn varchar(11) NOT NULL
	CONSTRAINT pk_wf_employee_id PRIMARY KEY(employee_id),
	CONSTRAINT fk_wf_employee_branch_id FOREIGN KEY(branch_id) REFERENCES wf_branch(branch_id)
);

CREATE TABLE wf_branch (
	branch_id int IDENTITY(101,1) NOT NULL,
	branch_address varchar(100) NOT NULL,
	CONSTRAINT pk_wf_branch PRIMARY KEY(branch_id)
);

CREATE TABLE wf_customer (
	customer_id int NOT NULL,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	email varchar(50),
	phone varchar(15),
	ssn char(11) NOT NULL,
	credit_score smallint,
	income_yearly bigint NOT NULL,
	CONSTRAINT pk_wf_customer_id PRIMARY KEY(customer_id),
	CONSTRAINT check_credit_score CHECK(credit_score >= 300 AND credit_score <= 850)
);

CREATE TABLE wf_account (
	account_id int NOT NULL,
	branch_id int NOT NULL,
	customer_id int NOT NULL,
	account_type char(8) NOT NULL,
	balance decimal(10,2) NOT NULL,
	date_opened date NOT NULL,
	CONSTRAINT pk_wf_account_id PRIMARY KEY(account_id),
	CONSTRAINT fk_wf_account_branch_id FOREIGN KEY(branch_id) REFERENCES wf_branch(branch_id),
	CONSTRAINT fk_wf_account_customer_id FOREIGN KEY(customer_id) REFERENCES wf_customer(customer_id),
	CONSTRAINT check_account_type CHECK(account_type = 'checking' OR account_type = 'savings')
);

CREATE TABLE wf_transaction (
	transaction_id int NOT NULL,
	employee_id varchar(30) NOT NULL,
	customer_id int NOT NULL,
	transaction_type char(13) NOT NULL,
	transaction_amount decimal(10,2) NOT NULL,
	transaction_date date NOT NULL,
	CONSTRAINT pk_wf_transaction_id PRIMARY KEY(transaction_id),
	CONSTRAINT fk_wf_transaction_employee_id FOREIGN KEY(employee_id) REFERENCES wf_employee(employee_id),
	CONSTRAINT fk_wf_transaction_customer_id FOREIGN KEY(customer_id) REFERENCES wf_customer(customer_id),
	CONSTRAINT check_transaction_type CHECK(transaction_type = 'deposit' OR transaction_type = 'withdrawal' OR transaction_type = 'wire transfer')
);

CREATE TABLE wf_loans (
	loan_id int NOT NULL,
	customer_id int NOT NULL,
	loan_type varchar(20) NOT NULL,
	loan_amount decimal(10,2) NOT NULL,
	loan_apr decimal(10,2) NOT NULL,
	loan_term_months tinyint NOT NULL,
	CONSTRAINT pk_wf_loans PRIMARY KEY(loan_id),
	CONSTRAINT fk_wf_loans_customer_id FOREIGN KEY(customer_id) REFERENCES wf_customer(customer_id)
);
-- END TABLE CREATION --

