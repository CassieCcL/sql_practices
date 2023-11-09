-- Find the oldest survivor of each passenger class.
-- Output the name and the age of the survivor along with 
-- the corresponding passenger class.
-- Order records by passenger class in ascending order.
SELECT pclass,
    MAX(age) AS oldest_survivor
FROM titanic
WHERE survived = 1
GROUP BY pclass
ORDER BY pclass ASC