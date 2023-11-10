-- Find the top 3 most common letters across all the words 
-- from both the tables (ignore filename column). 
-- Output the letter along with the number of occurrences and order records 
-- in descending order based on the number of occurrences.
WITH combined_words AS (
    SELECT regexp_split_to_table(contents, ' ') AS word
    FROM google_file_store
    UNION ALL
    SELECT regexp_split_to_table(words1, ',')
    FROM google_word_lists
    UNION ALL
    SELECT regexp_split_to_table(words2, ',')
    FROM google_word_lists
), -- regexp_split_to_table () to split series of words into single words
-- and put them into separate rows
all_letters AS (
    SELECT 
        word,
        generate_series(1, length(word)) AS idx
    FROM combined_words
)  -- generate index for all the words from 1 to the length of the words themselves
SELECT
    substring(word from idx for 1) AS letter,
    COUNT(*) AS occurrence
FROM
    all_letters
WHERE
    substring(word from idx for 1) NOT IN (',', '.')
-- substring() allows to extract 1 letter at a time starting from the
-- position indicated by the index
GROUP BY 
    letter
ORDER BY
    occurrence DESC
LIMIT 3
-- I am using PostgresSQL, so unnest() does not exist. unnest() will make
-- this much easier.