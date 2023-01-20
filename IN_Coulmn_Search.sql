SELECT
T.name AS table_name, C.name AS column_name
FROM
sys.tables AS T
INNER JOIN
sys.columns AS C
ON
T.object_id = C.object_id
WHERE
C.name ='UNICD'