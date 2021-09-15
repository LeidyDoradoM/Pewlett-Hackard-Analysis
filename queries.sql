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

-- we need to add a new column to the retirement table.
-- This new columns is the emp_no, the identification of the employees
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
--this joining is to get info about the employee is still hired
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Left join and creating a new table of employees still
-- working and about to retire
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01'); --filter

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number and in order
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--Create the table of employee count by department and in order to export
SELECT COUNT(ce.emp_no), de.dept_no INTO retirement_bydept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- new list requiered about employees about to retire
--1st list, employee information w/gender + salary
SELECT * FROM salaries
ORDER BY to_date DESC; --to see salary information by employee

-- generate the new table of employees about to retire with the gender information
SELECT emp_no,
    first_name,
	last_name,
    gender INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM emp_info;
 
DROP TABLE emp_info;

-- now we are going to add the salary information and department
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
	de.to_date 
 INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- 2nd List: managers about to retire per department, current emp table
-- has information about the employees about to retire
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

--3rd List: department retirees, again we use current_emp table
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
 INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);