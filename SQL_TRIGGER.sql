CREATE TABLE chat(
	id VARCHAR(32),
	answer VARCHAR(32) NOT NULL
);

CREATE TABLE chatBackup(
	idBackup VARCHAR(32),
	answerBackup VARCHAR(32) NOT NULL
);

INSERT INTO chat VALUE ('pigg', '안녕');
INSERT INTO chat VALUE ('lemon', '반가워');
INSERT INTO chat VALUE ('pigg', '오늘 날씨 어때?');
INSERT INTO chat VALUE ('lemon', '날씨 좋아');

SELECT * FROM CHAT;
SELECT * FROM CHATBACKUP;
/*
Trigger 생성 구문
Create [OR REPLACE] TRIGGER <트리거 이름>
{BEFORE|AFTER}<EVENT>ON<TABLE> 이벤트 발생 테이블
[FOR EACH ROW]
[WHEN (<조건>)]
[DECLARE <변수선언>]
BEGIN
	<실행코드> 이벤트 발생시 실행할 문장
[EXCEPTION <예외사항>]
END <트리거이름>;

old
예전 데이터 즉, 
delete 로 삭제 된 데이터 또는 
update 로 바뀌기 전의 데이터

​

new
새 데이터 즉,
insert 로 삽입된 데이터 또는
update 로 바뀐 후의 데이터

*/

DELIMITER $$
	CREATE TRIGGER autoBackup
	BEFORE  DELETE ON chat
	FOR EACH ROW 
	BEGIN
		DECLARE idTemp VARCHAR(32);
		DECLARE answerTemp VARCHAR(32);
		
		SET idTemp = OLD.id;
		SET answerTemp = OLD.answer;
		
		INSERT INTO chatBackup VALUE (idTemp, answerTemp);
		
	END $$
DELIMITER ;

SHOW TRIGGERS; --트리거 확인

DELETE FROM CHAT WHERE ID = 'PIGG';

SELECT * FROM CHAT;
SELECT * FROM CHATBACKUP;