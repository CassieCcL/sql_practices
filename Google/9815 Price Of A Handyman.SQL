-- Find the price that a small handyman business is willing to pay 
-- per employee. Get the result based on the mode of the adword earnings 
-- per employee distribution. 
-- Small businesses are considered to have not more than ten employees.
WITH handyman_business as (
SELECT *,
    adwords_earnings * 1.0/ n_employees AS earnings_per_employee
FROM google_adwords_earnings
WHERE business_type = 'handyman'
AND n_employees <=10
)
SELECT earnings_per_employee,
    COUNT(*) AS num_employees
FROM handyman_business
GROUP BY earnings_per_employee
ORDER BY num_employees DESC
LIMIT 1
-- Mode is the number that showed up the most, by using COUNT()
-- the maximum occurrence can be located