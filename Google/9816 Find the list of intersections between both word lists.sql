-- Find the list of intersections between both word lists
WITH split_words AS(
    SELECT
        REGEXP_SPLIT_TO_TABLE(words1, ',') AS new_words1,
        REGEXP_SPLIT_TO_TABLE(words2, ',') AS new_words2
    FROM 
        google_word_lists
)
SELECT new_words1
FROM split_words
WHERE new_words1 IN (
    SELECT new_words2
    FROM split_words
)