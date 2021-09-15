-- Searching for employees about to retire
SELECT first_name, last_name FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';  --employees born between 1952-1955

--how many employees were born in 1952
SELECT first_name, last_name FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- retirement eligibility takes into account birthdate and hiring date between 1985-1988
SELECT first_name, last_name FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- number of rows that meet the two retirement conditions
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- generating a new table called retirement_info 
SELECT first_name, last_name INTO retirement_info FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;