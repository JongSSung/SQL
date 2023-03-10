

SELECT  K.KANBANNO, K.PARTNO, COALESCE((SELECT TOP 1 C.ALCCODE FROM TB_CSTPARTINFO C WHERE C.COMPANY = P.COMPANY AND C.PARTNO = P.PARTNO ORDER BY C.EDTDATIME DESC), '') AS ALCCODE
FROM TB_PARTINFO P LEFT JOIN TB_KANBANINFO K
ON P.COMPANY = K. COMPANY 
WHERE P.PARTNO = '9999999999'


--확인용
SELECT C.COMPANY, C.PARTNO, COUNT(C.PARTNO)AS CNT 
FROM TB_CSTPARTINFO C
GROUP BY C.COMPANY, C.PARTNO
