-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- DROP TABLE titles;

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Verify imports 
SELECT * FROM departments;

SELECT * FROM employees;

SELECT * FROM dept_emp;

SELECT * FROM dept_manager;

SELECT * FROM salaries;

SELECT * FROM titles;

-- Find employees born between 1952 and 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Find employees born for each year
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Save names in new table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- View retirement_info table
SELECT * FROM retirement_info;

-- Drop the retirement_info table
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
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
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- shorten syntax (same as codes above)
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- use left joins retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number, create new table
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_retiring_emp
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Verify table
SELECT * FROM dept_retiring_emp;

-- DROP TABLE emp_info;
-- Create a new table to find employee information
SELECT * FROM salaries
ORDER BY to_date DESC;

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
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');

-- List of managers per department
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

-- Department retirees
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

-- Create table with only Sales employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name, 
	d.dept_name
INTO sales_emp
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
LEFT JOIN departments as D
ON (de.dept_no = d.dept_no)
WHERE de.dept_no = 'd007';

-- Create a table with Sales and Development employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name, 
	d.dept_name
INTO dev_sales_emp
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (de.dept_no = 'd007')
	OR (de.dept_no = 'd005');

DROP TABLE retiring_emp_titles
-- Find the number of retiring employees by title
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date 
-- INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

-- Eliminate duplicate employee numbers
SELECT DISTINCT ON (emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title, 
    rt.from_date,
    rt.to_date
-- INTO unique_titles
FROM retirement_titles AS rt
WHERE (to_date = '9999-01-01')
ORDER BY emp_no ASC, to_date DESC;

-- Count the number of unique titles
SELECT COUNT(ut.title),
    ut.title
--INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY count DESC;

-- Retrieve employees eligibile for the mentorship proram
SELECT DISTINCT ON (emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    t.title,
    de.from_date,
    de.to_date
--INTO mentorship_eligbility
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
WHERE (de.to_date = '9999-01-01')
    AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;    

-- Find the salaries of all retiring employees
SELECT ut.emp_no,
    ut.first_name,
    ut.last_name,
	ut.title,
	s.salary
INTO retiring_salaries 
FROM unique_titles AS ut
INNER JOIN salaries AS s
ON ut.emp_no = s.emp_no
ORDER BY ut.emp_no ASC;  

-- Find average salary per title
SELECT rs.title,
	AVG(rs.salary)
INTO avg_retiring_salaries
FROM retiring_salaries AS rs
GROUP BY rs.title
ORDER BY avg DESC;


