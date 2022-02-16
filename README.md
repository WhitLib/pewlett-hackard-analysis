# pewlett-hackard-analysis
Exploration and Analyzation of Databases Using SQL

### Table of Contents
- [1 Overview](#1-overview)
- [2 Results](#2-results)
- [3 Summary](#3-summary)


## 1 Overview

The purpose of this project was to assist Bobby, an HR Analyst at Pewlett-Hackard, do employee research. Pewlett-Hackard,na large company that employs several thousand employees have a large number of baby boomers who are beginning to retire. To help the company look towards the future, PH is preparing itself to distribute retirement packages to qualifying retiring employees and start filling positions in anticipation for the upcoming "silver tsunami." Using SQL, we helped Bobby build a complete employee database by applying data modeling, engineering, and analysis skills. 

## 2 Results

<p align="center">
  <img src="https://user-images.githubusercontent.com/95978097/154167004-fa1df3cf-5a50-4d46-9b61-47996ba582a0.png" />
</p>

````
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    t.to_date 
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;
````

Based on the retirement_titles table, the **amount of employees that held multiple job titles throughout their career *and* who were born between January 1, 1952 and December 31, 1955 totaled 133,776 rows - a great deal of employees**. However, to eliminate the number of duplicate employees and remove the employees that are no longer with the company, we created another table, unique titles, that **reduced the number of rows (employees) in the table from 133,776 to 72,458**. While the number of employees were cut by almost half between the two tables, the adjusted value is still a large number of exiting employees that Pewlett-Hackard will have to fill.

<p align="center">
  <img src="https://user-images.githubusercontent.com/95978097/154167169-2b6db54c-4cad-4913-87e3-f8a94eb9f79b.png" />
</p>

````
SELECT DISTINCT ON (emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title, 
    rt.from_date,
    rt.to_date
INTO unique_titles
FROM retirement_titles AS rt
WHERE (to_date = '9999-01-01')
ORDER BY emp_no ASC, to_date DESC;
````

Then, by retrieving the number of employees by their most recent job title who are about to retire, the image below shows that **senior staff and engineer positions have the highest number of employees retiring**. This means that Pewlett-Hackard may need to consider filling their senior roles first to make up for the loss. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/95978097/154167264-8c57eee4-c39e-4053-a0fd-0937d5671b74.png" />
</p>

````
SELECT COUNT(ut.title),
    ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY count DESC;
````
Lastly, in finding mentorship eligibility, current employees born between January 1, 1965 and December 31, 1965 were eligible to participate. **Based on the results, 1,549 employees (rows) were retrieved - a relatively low number in comparison to the amount of employees retiring**. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/95978097/154169513-4fa81a0d-f703-4457-8adf-6e4091367a7c.png" />
</p>

````
SELECT DISTINCT ON (emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    t.title,
    de.from_date,
    de.to_date
INTO mentorship_eligbility
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
WHERE (de.to_date = '9999-01-01')
    AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;
````
## 3 Summary

As Pewlett-Hackard moves into the inevitable "silver tsunami," the company should prepare to lose 72,458 employees - 50,842 of which are senior level staff. This is critical information for PH, as it will give them insight on where the largest gaps will be once the retiring employees begin to exit. With 50,842 senior level staff persons leaving, there are enough qualified employees in the departments to mentor the next generation of Pewlett-Hackard employees. 

Two additional queries that were created were *retiring salaries* and *average retiring salaries*. The retiring salaries table shows all the current job titles for retiring folks and their current salaries. This information could be useful for Pewlett-Hackard when analyzing budgets for department hiring and negotiating salary ranges with incoming employees. Average retiring salaries analyzes the retiring salaries table and finds the average salary per title. Paired with the retiring salaries CSV table, this information could help PH rethink the pay structure in the company and determine what salary ranges are fair and competitive within the job market. As shown in the second table below, the average salary for a manager is higher than the average salary for a senior level staff position. Similarly, the average salary for a standard engineer is higher than a senior engineer position. Pewlett-Hackard should consider reevaluating their department and salary structuring before they feel the repercussions of the silver tsunami.

<p align="center">
  <img src="https://user-images.githubusercontent.com/95978097/154311665-f90025f5-a2c4-442d-aebb-5704ad6aefd0.png" />
</p>

````
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
````

<p align="center">
  <img src="https://user-images.githubusercontent.com/95978097/154313479-62de7136-992e-409d-96a6-afa9077c81a8.png" />
</p>

````
SELECT rs.title,
	AVG(rs.salary)
-- INTO avg_retiring_salaries
FROM retiring_salaries AS rs
GROUP BY rs.title
ORDER BY avg DESC;
````
