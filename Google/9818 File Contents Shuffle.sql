-- Sort the words alphabetically in 'final.txt' and make a new file 
-- named 'wacky.txt'. Output the file contents in one column and 
-- the filename 'wacky.txt' in another column. 
-- Lowercase all the words. 
-- To simplify the question, there is no need to remove the punctuation marks.
SELECT 'wacky.txt' AS filename,
    ARRAY_TO_STRING(ARRAY_AGG(LOWER(words)), ' ') AS contents
FROM (
    SELECT 
        regexp_split_to_table (contents, ' ') AS words
    FROM 
        google_file_store
    WHERE 
        filename = 'final.txt'
    ORDER BY
        words ASC
) a 

-- LOWER() is used to change all the letters to lower case
--  To better deal with the contents, use "regexp_split_to_table()" 
-- or "unnest()" to transform the words into array and put them into a column
-- Note: may need to apply STRING_TO_ARRAY() before UNNEST()
-- After transforming the words into lower case, use ARRAY_AGG() to
-- transform the column to a row of the words combined.