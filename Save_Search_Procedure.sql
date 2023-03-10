
--장비활요일정
BEGIN


		SELECT M.SEQNO, M.MACCD, A.MACNM, C.CSTCD, C.CSTNM, M.BIZNO, M.STADATE, M.FSHDATE, M.USAGETIME,
			CAST(M.USAGEFEE AS DOUBLE) AS USAGEFEE, M.SAMPLE, M.PURPOSE, M.DOCIMG, M.USEQTY, M.REMARK,
			M.REGUSER, M.EDTUSER, M.REGDATIME, M.EDTDATIME
	FROM tb_macplnhis M  INNER JOIN tb_macmstinfo A ON A.MACCD = M.MACCD
								INNER JOIN tb_cstmstinfo C ON C.CSTCD = M.CSTNM
	WHERE (CASE WHEN _MACCD != '' THEN M.MACCD  LIKE  CONCAT('%', _MACCD, '%') ELSE TRUE END) 
	 AND	(CASE WHEN _CSTNM != '' THEN C.CSTNM  LIKE  CONCAT('%', _CSTNM, '%') ELSE TRUE END)
	 AND	(CASE WHEN _BIZNO != '' THEN M.BIZNO  LIKE  CONCAT('%', _BIZNO, '%') ELSE TRUE END)
	 AND  DATE_FORMAT(M.STADATE, '%Y-%m-%d') > DATE_FORMAT(_STADT, '%Y-%m-%d') AND DATE_FORMAT( M.FSHDATE, '%Y-%m-%d') < DATE_FORMAT(_FSHDT, '%Y-%m-%d')
	ORDER BY M.REGDATIME DESC;

END

--재고현황, 자산정보 검색 조건생성
BEGIN

-- 	SELECT W.ITMCD, (SELECT I.ITMNM FROM tb_itmmstinfo I WHERE I.ITMCD = W.ITMCD) AS ITMNM,
-- 			CAST(SUM(W.WHOQTY) AS DOUBLE) AS WHOQTY, CAST(SUM(W.DEVQTY) AS DOUBLE) AS DEVQTY 
-- 	FROM tb_inventwrk W
-- 	WHERE W.ITMCD LIKE CONCAT('%',_ITMCD,'%')
-- 	GROUP BY W.ITMCD
-- 	ORDER BY W.ITMCD;

	SELECT T.ITMCD, T.ITMNM, T.WHOQTY , T.DEVQTY, (T.WHOQTY - T.DEVQTY) AS INVQTY 
	FROM (
		SELECT 	W.ITMCD, I.ITMNM,
					CAST(SUM(W.WHOQTY) AS DOUBLE) AS WHOQTY, 
					CAST(SUM(W.DEVQTY) AS DOUBLE) AS DEVQTY				
		FROM tb_inventwrk W INNER JOIN tb_itmmstinfo I ON I.ITMCD = W.ITMCD
	--	WHERE W.ITMCD LIKE CONCAT('%','','%') -- AND W.WHOQTY != 0
		GROUP BY W.ITMCD
		ORDER BY W.ITMCD
	) AS T  
	WHERE (CASE WHEN _ITMCD != '' THEN T.ITMCD LIKE CONCAT('%',_ITMCD,'%') ELSE TRUE END)
	AND T.WHOQTY != 0 ;
	
END