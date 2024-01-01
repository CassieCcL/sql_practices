-- Consider all LinkedIn users who, at some point, worked at Microsoft. 
-- For how many of them was Google their next employer right after Microsoft 
-- (no employers in between)?

-- Filter the employees who employed by Microsoft and then find their next employer through order by their start_date
WITH mic_employees AS (
    SELECT 
        user_id,
        employer,
        start_date
    FROM 
        linkedin_users
    WHERE 
        user_id IN (
            SELECT 
                user_id
            FROM 
                linkedin_users
            WHERE 
                employer = 'Microsoft'
        )
),
previous_employer AS (
    SELECT
        user_id,
        employer,
        LAG(employer)OVER(PARTITION BY user_id ORDER BY start_date DESC) AS previous_emp,
        start_date
    FROM    
        mic_employees
)
SELECT 
    COUNT(*)
FROM 
    previous_employer
WHERE 
    employer = 'Google' AND previous_emp = 'Microsoft'