/* ALIAS gives as certain heading another description. */
SELECT column01 , column02 || column03 AS "description" -- || concatenats column02 with column03
FROM table01;