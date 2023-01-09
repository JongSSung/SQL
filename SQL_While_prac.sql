CREATE DATABASE good_test; /*good DB 생성*/
/*_______________________________________________________________________________*/

USE good_test; /* good DB 선택*/
/*_______________________________________________________________________________*/

CREATE TABLE test( /*테스트용 테이블 생성*/
	no INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(20),
	email VARCHAR(40),
	pass VARCHAR(30),
	content TEXT,
	date DATETIME,
	PRIMARY KEY(NO)
);
/*_______________________________________________________________________________*/

DELIMITER ;; /* 프로시저 만들기 위한 구분문자 DELIMITER 사이에 공백 지우면 에러남 */
CREATE PROCEDURE auto_insert(IN count INT) /*auto_insert 이름의 프로시저 생성 호출시 들어오는 숫자를 count 변수에 저장*/
BEGIN
    DECLARE i INT DEFAULT 1;/* 변수 I에 1 초기화 */
    WHILE (i <= count) DO/*1부터 호출시 입력한 숫자만큼 반복*/
		  INSERT INTO test (name, email, pass, content, date)VALUES(CONCAT('자동생성' ,i) , CONCAT('auto', i, '@mail.com'), '12345', CONCAT('자동생성 데이타 입니다.', i), NOW()); /* INSERT 실행 CONCAT 함수는 문자를 합치기 위해 사용*/
        SET i = i + 1; /* 루프가 끝나기전 I변수 1증가 */
    END WHILE; /* 반복  */
END;;
DELIMITER ; /* 프로시저 종료 지점 마찬가지로 DELIMITER 사이 공백 지우면 에러남.*/
/*_______________________________________________________________________________*/

CALL auto_insert(1121); /* 1121개 데이터  인서트 해봐~ */
/*_______________________________________________________________________________*/

SELECT * FROM test; /* 데이타 잘들어갔는지 확인.*/
/*_______________________________________________________________________________*/

DROP PROCEDURE auto_insert; /*  INSERT 된거 확인 했고 필요 없으니 프로시저  삭제~ */
/*_______________________________________________________________________________*/