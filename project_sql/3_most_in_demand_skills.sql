
/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/




WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings 
        ON skills_to_job.job_id = job_postings.job_id -- Added missing join condition
    WHERE
        job_postings.job_work_from_home = True AND 
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)


--OR--


SELECT
    skills.skill_id,
    skills.skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills 
    ON remote_job_skills.skill_id = skills.skill_id -- Added missing join condition
ORDER BY
    skill_count DESC
LIMIT 5;

SELECT 
    skills,
    count(skills_job_dim.job_id) AS total_count
FROM job_postings_fact

INNER join skills_job_dim
ON job_postings_fact.job_id=skills_job_dim.job_id
INNER join skills_dim
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE 
    job_title_short='Data Analyst'
GROUP BY
    skills
ORDER BY
    total_count DESC
LIMIT 5