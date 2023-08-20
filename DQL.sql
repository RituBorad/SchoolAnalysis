SELECT * FROM SCHOOL;
SELECT * FROM SUBJECTS;
SELECT * FROM STAFF;
SELECT * FROM STAFF_SALARY;
SELECT * FROM CLASSES;
SELECT * FROM STUDENTS;
SELECT * FROM PARENTS;
SELECT * FROM STUDENT_CLASSES;
SELECT * FROM STUDENT_PARENT;
SELECT * FROM ADDRESS;

-- Basic queries
SELECT * FROM STUDENTS;   -- Fetch all columns and all records (rows) from table.
SELECT ID, FIRST_NAME FROM STUDENTS; -- Fetch only ID and FIRST_NAME columns from students table.

-- Comparison Operators
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME = 'Mathematics'; -- Fetch all records where subject name is Mathematics.
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME <> 'Mathematics'; -- Fetch all records where subject name is not Mathematics.
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME != 'Mathematics'; -- same as above. Both "<>" and "!=" are NOT EQUAL TO operator in SQL.
SELECT * FROM STAFF_SALARY WHERE SALARY > 10000; -- All records where salary is greater than 10000.
SELECT * FROM STAFF_SALARY WHERE SALARY < 10000; -- All records where salary is less than 10000.
SELECT * FROM STAFF_SALARY WHERE SALARY < 10000 ORDER BY SALARY; -- All records where salary is less than 10000 and the output is sorted in ascending order of salary.
SELECT * FROM STAFF_SALARY WHERE SALARY < 10000 ORDER BY SALARY DESC; -- All records where salary is less than 10000 and the output is sorted in descending order of salary.
SELECT * FROM STAFF_SALARY WHERE SALARY >= 10000; -- All records where salary is greater than or equal to 10000.
SELECT * FROM STAFF_SALARY WHERE SALARY <= 10000; -- All records where salary is less than or equal to 10000.

-- Logical Operators
SELECT * FROM STAFF_SALARY WHERE SALARY BETWEEN 5000 AND 10000; -- Fetch all records where salary is between 5000 and 10000.
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME IN ('Mathematics', 'Science', 'Arts'); -- All records where subjects is either Mathematics, Science or Arts.
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME NOT IN ('Mathematics', 'Science', 'Arts'); -- All records where subjects is not Mathematics, Science or Arts.
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME LIKE 'Computer%'; -- Fetch records where subject name has Computer as prefixed. % matches all characters.
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME NOT LIKE 'Computer%'; -- Fetch records where subject name does not have Computer as prefixed. % matches all characters.
SELECT * FROM STAFF WHERE AGE > 50 AND GENDER = 'F'; -- Fetch records where staff is female and is over 50 years of age. AND operator fetches result only if the condition mentioned both on left side and right side of AND operator holds true. In OR operator, atleast any one of the conditions needs to hold true to fetch result.
SELECT * FROM STAFF WHERE FIRST_NAME LIKE 'A%' AND LAST_NAME LIKE 'S%'; -- Fetch record where first name of staff starts with "A" AND last name starts with "S".
SELECT * FROM STAFF WHERE FIRST_NAME LIKE 'A%' OR LAST_NAME LIKE 'S%'; -- Fetch record where first name of staff starts with "A" OR last name starts with "S". Meaning either the first name or the last name condition needs to match for query to return data.
SELECT * FROM STAFF WHERE (FIRST_NAME LIKE 'A%' OR LAST_NAME LIKE 'S%') AND AGE > 50; -- Fetch record where staff is over 50 years of age AND has his first name starting with "A" OR his last name starting with "S".

-- Arithmetic Operators
SELECT (5+2) AS ADDITION;   -- Sum of two numbers. PostgreSQL does not need FROM clause to execute such queries.
SELECT (5-2) AS SUBTRACT;   -- Oracle & MySQL equivalent query would be -->  select (5+2) as Addition FROM DUAL; --> Where dual is a dummy table.
SELECT (5*2) AS MULTIPLY;
SELECT (5/2) AS DIVIDE;   -- Divides 2 numbers and returns whole number.
SELECT (5%2) AS MODULUS;  -- Divides 2 numbers and returns the remainder

SELECT STAFF_TYPE FROM STAFF ; -- Returns lot of duplicate data.
SELECT DISTINCT STAFF_TYPE FROM STAFF ; -- Returns unique values only.

-- CASE WHEN statement
SELECT STAFF_ID, SALARY,
CASE WHEN SALARY > 10000 THEN 'High Salary'
	 WHEN SALARY BETWEEN 5000 AND 10000 THEN 'Average Salary'
	 WHEN SALARY < 10000 THEN 'Low Salary'
END AS RANGE
FROM STAFF_SALARY
ORDER BY 2 DESC;

-- JOINS
-- Fetching all the class names where Music is thought as a subject
SELECT CLASS_NAME
FROM SUBJECTS sub
JOIN CLASSES cls
ON sub.SUBJECT_ID = cls.SUBJECT_ID
WHERE sub.SUBJECT_NAME = 'Music';

-- Fetch the full name of all staff who teach Mathematics
SELECT DISTINCT (ST.FIRST_NAME|| ' ' ||ST.LAST_NAME)  AS FULL_NAME 
FROM SUBJECTS SUB
JOIN CLASSES CLS ON SUB.SUBJECT_ID = CLS.SUBJECT_ID
JOIN STAFF ST ON CLS.TEACHER_ID = ST.STAFF_ID
WHERE SUB.SUBJECT_NAME = 'Mathematics';

-- Fetch all staff who teach grade 8, 9, 10 and also fetch all the non-teaching staff
SELECT DISTINCT (ST.FIRST_NAME|| ' ' ||ST.LAST_NAME)  AS FULL_NAME
FROM STAFF ST 
JOIN CLASSES CLS
ON ST.STAFF_ID = CLS.TEACHER_ID
WHERE CLASS_NAME IN ('Grade 8', 'Grade 9', 'Grade 10')
AND ST.STAFF_TYPE = 'Teaching'
UNION
SELECT DISTINCT (FIRST_NAME|| ' ' ||LAST_NAME)  AS FULL_NAME
FROM STAFF
WHERE STAFF_TYPE = 'Non-Teaching';

--GROUP BY statements
-- Count the number of students in each class
SELECT CLASS_ID, COUNT(CLASS_ID) AS "no_of_students"
FROM STUDENT_CLASSES
GROUP BY CLASS_ID
ORDER BY CLASS_ID;

-- More than 100 students in each class
SELECT CLASS_ID, COUNT(1) AS "no_of_students"
FROM STUDENT_CLASSES
GROUP BY CLASS_ID
HAVING COUNT(1) > 100
ORDER BY CLASS_ID;

-- Parents with more than one kid in school
SELECT PARENT_ID, COUNT(1) AS "no_of_kids"
FROM STUDENT_PARENT
GROUP BY PARENT_ID
HAVING COUNT(1) > 1
ORDER BY PARENT_ID;

-- Subqueries
-- Fetch the details of the parents having more than one kids going to the school
SELECT ID, FIRST_NAME, LAST_NAME, GENDER
FROM PARENTS
WHERE ID IN
(SELECT PARENT_ID
FROM STUDENT_PARENT
GROUP BY PARENT_ID
HAVING COUNT(1) > 1);

-- Staff details who salary is less than 5000
SELECT ST.STAFF_ID, ST.STAFF_TYPE, ST.FIRST_NAME, ST.LAST_NAME, ST.AGE, STS.SALARY
FROM STAFF ST
JOIN STAFF_SALARY STS ON ST.STAFF_ID = STS.STAFF_ID
WHERE ST.STAFF_ID IN
(
SELECT staff_id
FROM STAFF_SALARY
WHERE SALARY < 5000);