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

