/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

Possible Errors: 
- ERROR >>  duplicate key value violates unique constraint "company_dim_pkey"
- ERROR >> could not open file "C:\Users\...\company_dim.csv" for reading: Permission denied

1. Drop the Database 
            DROP DATABASE IF EXISTS sql_course;
2. Repeat steps to create database and load table schemas
            - 1_create_database.sql
            - 2_create_tables.sql
3. Open pgAdmin
4. In Object Explorer (left-hand pane), navigate to `sql_course` database
5. Right-click `sql_course` and select `PSQL Tool`
            - This opens a terminal window to write the following code
6. Get the absolute file path of your csv files
            1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
7. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding
\COPY company_dim
FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY skills_dim
FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY job_postings_fact
FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\COPY skills_job_dim
FROM 'C:\Users\cheth\Downloads\csv_files-20260523T130116Z-3-001\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


SELECT COUNT(*)
FROM company_dim;
SELECT COUNT(*)
FROM job_postings_fact;
SELECT COUNT(*)
FROM skills_dim;
SELECT COUNT(*)
FROM skills_job_dim;

SELECT *
FROM job_postings_fact
LIMIT 100

SELECT job_schedule_type,
AVG(salary_year_avg) AS avg_salary_year,
AVG(salary_hour_avg) AS avg_salary_hour
FROM job_postings_fact
WHERE job_posted_date:: DATE >'2023-06-01'::DATE
GROUP BY job_schedule_type


SELECT 
    job_title_short,
    job_location,
    CASE
        WHEN job_location='Anywhere' THEN 'Remote'
        WHEN job_location='New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS job_lacate
FROM job_postings_fact
WHERE job_title_short='Data Analyst'
LIMIT 1000

SELECT 
    job_postings_fact.job_id,
    skills_job_dim.skills,
    skills_dim.skill_type

FROM job_postings_fact
INNER JOIN skills_dim
ON job_postings_fact.job_id=skills_dim.job_id

WHERE EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 1
AND job_postings_fact.salary_year_avg > 70000

UNION 

SELECT 
    job_posted_fact.job_id,
    skills_job_dim.skills,
    skills_dim.skill_type
FROM job_postings_fact

INNER JOIN skills_job_dim
ON job_postings_fact.job_id=skills_dim.job_id

WHERE EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 1
AND job_postings_fact.salary_year_avg > 70000
