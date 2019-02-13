/* Working */
/*SELECT CASE WHEN TRIM(TRANSLATE(CITY, '0123456789-,.', ' ')) IS NULL
            THEN 'numeric'
            ELSE 'alpha'
       END
FROM CLICK_AND_ADVANTEX_CLOSED*/

/* Working */
/*SELECT DISTINCT city
FROM click_and_advantex_closed
WHERE ord_closed_date
BETWEEN '01/JAN/18' AND '31/DEC/18'
AND city IN
    (SELECT REGEXP_REPLACE(city,' ','',1,1)
     FROM click_and_advantex_closed
     WHERE ord_closed_date
     BETWEEN '01/JAN/18' AND '31/DEC/18')
ORDER BY city*/

/*Working*/
SELECT x1.tsa_order_number, x1.ord_closed_date, CONCAT(x1.city, ', SOUTH AFRICA') AS "x1.city"
FROM click_and_advantex_closed x1
JOIN 
    (SELECT MIN(p1.ord_closed_date) AS min_date, p1.city
     FROM click_and_advantex_closed p1
     WHERE p1.ord_closed_date
     BETWEEN '01/JAN/18' AND '31/DEC/18'
     AND p1.tsa_order_number IS NOT NULL
     AND p1.city IS NOT NULL
     AND p1.city NOT LIKE '%CBS%'
     AND p1.city != 'AWL'
     AND p1.city != 'BXT'
     AND p1.city != 'JOHANNESSBURG'
     AND p1.city != 'KA'
     AND p1.city != 'KZN'
     AND p1.city != 'NA'
     AND p1.city != 'PIETERMARISBURG'
     AND p1.city != 'PIETERMARIZTBURG'
     AND p1.city != 'PIETERMARTIZBURG'
     AND p1.city != 'SR'
     AND p1.city != 'VAL'
     AND p1.city != 'X'
     AND p1.city != 'd'
     AND p1.city != 'jhb'
     AND p1.city != 'na'
     AND p1.city != 's'
     AND REGEXP_INSTR(p1.city, '[0123456789/\().,_~]') = 0
     AND p1.city IN
        (SELECT REGEXP_REPLACE(city,' ','',1,1)
         FROM click_and_advantex_closed
         WHERE ord_closed_date
         BETWEEN '01/JAN/18' AND '31/DEC/18')
     AND p1.city NOT IN 
        (SELECT city 
         FROM click_and_advantex_closed 
         WHERE ord_closed_date 
         BETWEEN '01/JAN/18' AND '31/DEC/18'
         GROUP BY city 
         HAVING COUNT(*) = 1)
     GROUP BY p1.city) y1 
ON y1.city = x1.city
AND y1.min_date = x1.ord_closed_date
GROUP BY x1.tsa_order_number, x1.ord_closed_date, x1.city 
ORDER BY x1.city