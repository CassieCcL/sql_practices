-- Find all words which contain exactly two vowels 
-- in any list in the table.
-- Extract all words into 1 column.
WITH words_list AS (
    SELECT 
        REGEXP_SPLIT_TO_TABLE (words1, ',') AS words_split
    FROM 
        google_word_lists
        
    UNION ALL 
    
    SELECT
        REGEXP_SPLIT_TO_TABLE (words2, ',') AS words_split
    FROM 
        google_word_lists
)
-- Replace vowels with nothing, the difference of length between
-- the original word and the new word need to be at 2
SELECT
    words_split
FROM
    words_list
WHERE
    LENGTH(words_split) - LENGTH(REGEXP_REPLACE(words_split,'[aeiou]','','g')) = 2