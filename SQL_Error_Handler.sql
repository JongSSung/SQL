--기본 문법

DECLARE handler_action HANDLER
    FOR condition_value [, condition_value] ...
    statement
 
 
handler_action:
    CONTINUE
  | EXIT
  | UNDO
  /*
특정 상태를 캐치했을 때 무엇을 할 수 있나?

1. CONTINUE
DECLARE CONTINUE HANDLER의 BEGIN ~ END 블럭을 실행하고, 이하의 SP 본문을 이어서 계속 실행합니다.

2. EXIT
DECLARE EXIT HANDLER의 BEGIN ~ END 블럭을 실행하고, SP의 실행을 종료합니다.

3. UNDO
문법에는 나오지만 실제로 UNDO 기능을 지원하진 않습니다.

*/
 
condition_value:
    mysql_error_code
  | SQLSTATE [VALUE] sqlstate_value
  | condition_name
  | SQLWARNING
  | NOT FOUND
  | SQLEXCEPTION

/*
어떤 상황을 캐치 할 수 있나?

1. 특정 에러
    1. 특정 ERROR CODE 발생
    2. 특정 SQLSTATE 발생
        1.SQLSTATE는 5자리 문자열 임

2. SQLWARNING
    1.에러가 아닌 경고가 발생
    2.SQLSTATE는 '01'로 시작 함

3. NOT FOUND
    1.커서가 마지막 레코드에 도달하여, 다음 레코드를 Fetch하지 못했을 때
    2.SQLSTATE는 '02'로 시작함

4.SQLEXCEPTION
    1.에러가 발생
    2.SQLSTATE가 '00', '01', '02'로 시작하지 않는 나머지 모두


*/
