
/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely
- Focuses on job postings with specified salaries (remove nulls)
- BONUS: Include company names of top 10 roles
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/





SELECT
    job_id,
    job_title_short,
    company_dim.name AS Company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE,
    CASE
        WHEN job_location='Anywhere' THEN 'Remote'
        ELSE job_location
    END AS job_locate
FROM
    job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id=company_dim.company_id
WHERE
    job_title_short='Data Analyst' AND
    job_location='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10