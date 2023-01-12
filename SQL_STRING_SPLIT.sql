-- STRING_SPLIT( "문자열", "구분자" )

SELECT empno
     , ename
     , skills
     , value
  FROM emp
 CROSS APPLY STRING_SPLIT(skills, ',')

--  조회된 skills 컬럼의 쉼표(',') 구분자를 잘라서 해당 개수만큼 행으로 변환한다.

-- 결과 컬럼은 value로 생성된다.

