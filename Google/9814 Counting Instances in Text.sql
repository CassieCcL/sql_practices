-- Find the number of times the words 'bull' and 'bear' occur 
-- in the contents. We're counting the number of times the words 
-- occur so words like 'bullish' should not be included in our count.
-- Output the word 'bull' and 'bear' along with the corresponding number 
-- of occurrences.
WITH words_content AS (
    SELECT 
        REGEXP_SPLIT_TO_TABLE(contents, ' ') AS words
    FROM 
        google_file_store
)
SELECT 
    words,
    COUNT(*) AS words_frequency
FROM 
    words_content
WHERE 
    words ILIKE 'bull'
OR
    words ILIKE 'bear'
GROUP BY 
    words

-- Utilize ILIKE to to include words in both upper case and lower case