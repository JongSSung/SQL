

SET ANSI_NULLS { ON | OFF }

-- SET ANSI_NULLS 옵션이 ON인 경우, WHERE column_name = NULL을 사용하는 SELECT 문은 column_name에 Null 값이 있을 때도 0행을 반환합니다.
--  WHERE column_name <> NULL을 사용하는 SELECT 문은 column_name에 Null이 아닌 값이 있을 때도 0행을 반환합니다.

 

-- SET ANSI_NULLS 옵션이 OFF면 Equals(=)와 Not Equal(<>) 비교 연산자가 ISO 표준을 따르지 않습니다.
--  WHERE column_name = NULL을 사용하는 SELECT 문은 column_name에 Null 값이 있는 행을 반환합니다. 
--  WHERE column_name <> NULL을 사용하는 SELECT 문은 열에 Null이 아닌 값이 있는 행을 반환합니다. 
--  또한 WHERE column_name <> XYZ_value를 사용하는 SELECT 문은 XYZ_value가 아니고 NULL이 아닌 모든 행을 반환합니다.

SET QUOTED_IDENTIFIER { ON | OFF }

-- ON(기본값)이면, 식별자는 큰따옴표(“ ”)로 구분할 수 있고 리터럴은 작은따옴표(' ')로 구분해야 합니다. 큰따옴표로 구분되는 모든 문자열은 개체 식별자로 해석됩니다.