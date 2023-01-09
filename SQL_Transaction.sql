이것은 하나의 작업을 위해 더이상 분할될 수 없는 명령들의 모음,

즉, 한꺼번에 수행되어야 할 일련의 연산모음을 의미한다.

데이터베이스와 어플리케이션의 데이터 거래(Transaction)에 있어서 안전성을 확보하기 위한 방법이 트랜잭션

따라서 데이터베이스에서 테이블의 데이터를 읽어 온 후 다른 테이블에 데이터를 입력하거나 갱신, 삭제하는 도중에 오류가 발생하면, 
결과를 재반영 하는 것이 아니라 모든 작업을 원상태로 복구하고, 처리 과정이 모두 성공하였을때 만 그 결과를 반영한다.


트랜잭션 도구

START TRANSACTION;

// COMMIT, ROLLBACK이 나올 때까지 실행되는 모든 SQL 추적

COMMIT;

// 모든 코드를 실행(문제가 없을 경우에)

ROLLBACK;

// START TRANSACTION 실행 전 상태로 되돌림(문제 생기면)



ex)

START TRANSACTION; -- 트랜잭션 시작
 
select * from members; -- 초기 상태 보여줌
insert into members values(1, '쿠', '크다스', '크라운제과' '?', '대한민국'); -- 데이터 수정
select * from members; -- 수정 상태 보여줌
 
COMMIT -- 트랜잭션을 DB에 적용
 
select * from members; -- 적용된 결과 조회

