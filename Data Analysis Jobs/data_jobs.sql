
/*
1. Prior to going into exploring the data, let's find the minimum date
*/

SELECT min(job_posted_date)
FROM
    job_postings_fact;

/* The min date is 12/31/2022. */

/*
2. Let's also find the maximum date.
*/

SELECT max(job_posted_date)
FROM
    job_postings_fact;

/* The max date is 12/31/2023. We can conclude that this data is from one years worth of job postings.*/



/*
3. What are the top-paying data analyst jobs?
-Identify top 10 highest-paying data analyst roles available remotely.
-Focus on job potings with specified salaries (removing nulls).
-Goal: To highlight the top-paying opportunities for data analysts offering insights into remote employment opportunities.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM
    job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/* The top salary job posting was from Mantys for a Data Analyst position at 650k. There are also a few tech companies such as Meta and Pinterest. Other companies include consulting companies and UCLA health. This data will also be exported to CSV for some further analysis. 
*/


/* 
4. What are the top 25 companies with the highest salaries of Data Analysts job postings in California?
-Identify Top 25 salaries in California
-Focus on Full-time roles
Goal: Highlight top-paying opportunities for data analysts in California.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM
    job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
    job_schedule_type = 'Full-time' AND
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%CA' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 25;

/* A majority of the top 25 highest salaried postings in California are tech companies. Tiktok has multiple job postings throughout the year for data related roles. 
*/


/* 
5. How many job postings are there in the the surrounding Irvine, CA area with listed salaries and full-time?
-Include surrounding areas
-Focus on full-time positions with listed salaries
Goal: Understand the market demand for full-time Data Analyst roles with advertised salaries in the greater Irvine area. This will help assess job availability and potential salary ranges for data analyst candidates.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_schedule_type = 'Full-time'
    AND job_title_short = 'Data Analyst'
    AND (
        job_location IN (
            'Irvine, CA',
            'Costa Mesa, CA',
            'Lake Forest, CA',
            'Orange, CA',
            'Mission Viejo, CA',
            'Laguna Niguel, CA',
            'Aliso Viejo, CA'
        )
    )
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;

/* There are a total of 31 job listings that are full-time with listed salaries in and surrounding Irvine. A good amount are consulting companies. Looks like I will have to consider commuting further. 
*/ 

/* 
6. What are the the most in-demand skills for data analysts?
-Join job postings to inner join table.
-Identify the top 5 in-demand skills for data analysts.
-Focus on all job postings.
-Goal: Retrieves top 5 skills with the highest demand in the job market.
*/

SELECT 
    skills,
    count(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;

/* The top 5 skills are SQL, Excel, Python, Tableau, and Power bi.
*/

/*
7. What are the top paying skills based on salary?
-Look at the average salary associated with each skill for data analysts 
-Focus on roles with specified salaries, regardless of location
-Goal: Reveal how different skills impact salary levels for data analysts in identify most financially rewarding skill to learn/ improve.
*/

SELECT
    skills,
    round(avg(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL 
    AND job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/* There are a lot of niche tools such as web development tools and big data tools which make sense since there are top paying roles.
*/

SELECT
    skills,
    round(avg(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL 
    AND job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
GROUP BY 
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/* If we are looking at remote jobs, some familiar tools come up in the top 25 such as pyspark, pandas, numpy, scikit-learn, and postgresql.
*/

/*
8. What are the top optimal skillset for a data analyst?
-High Demand and high salary
-Also concentrate on remote roles
Goal: Targeting skills that offer job security. 
*/


SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) as demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL 
    AND job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
GROUP BY 
    skills_dim.skill_id
HAVING  
    COUNT(skills_job_dim.job_id) >10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;


/* We can again see that some of the cloud based tools are some of the higher associated skills for higher salaries. 
*/





