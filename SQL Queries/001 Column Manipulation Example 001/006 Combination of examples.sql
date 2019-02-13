/* This query combines the previous examples. */
SELECT x1.column01, x1.column02, CONCAT(x1.column03, ', SOUTH AFRICA') AS "x1.column03" -- CONCAT is a different way of concatenation and applies this operation after the rest of the query is done 
FROM table01 x1 -- different way of giving a alias
JOIN 
    (SELECT MIN(y1.column02) AS min_value, y1.column03 -- MIN finds the minimum value in the column
     FROM table01 y1
     WHERE y1.column02
     BETWEEN '01/JAN/18' AND '31/DEC/18'
     AND y1.column01 IS NOT NULL -- IS NOT NULL checks for NULL values and exclude it
     AND y1.column03 NOT LIKE '%some character%' -- NOT LIKE exclude values of this, wildcards added to make sure the character is not found in any of the column string values
     AND y1.column03 != 'AWL' -- != not equal
     AND REGEXP_INSTR(y1.column03, '[0123456789/\().,_~]') = 0 -- REGEXP_INSTR compares each character between the square brackets to the column string and excludes all rows that they are found in.
     AND y1.column03 IN -- IN checks if the column values are found in the condition following 
        (SELECT REGEXP_REPLACE(column03, ' ', '', 1, 1) -- REGEXP_REPLACE takes away the first 'space' or char(32) in ascii away
         FROM table01
         WHERE column02
         BETWEEN '01/JAN/18' AND '31/DEC/18')
     AND p1.column03 NOT IN 
        (SELECT column03 -- this condition makes sure the unique values are removed
         FROM table01 
         WHERE column02 
         BETWEEN '01/JAN/18' AND '31/DEC/18'
         GROUP BY column03 
         HAVING COUNT(*) = 1)
     GROUP BY p1.column03) y1 
ON y1.column03 = x1.column03
AND y1.min_value = x1.column02
GROUP BY x1.column01 , x1.column02, x1.column03