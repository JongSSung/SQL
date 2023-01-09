drop table IF EXISTs emp;
drop table IF EXISTs dept;

CREATE TABLE dept ( 
	deptno               int  NOT NULL  AUTO_INCREMENT,
	dname                varchar(20)    ,
	loc                  varchar(20)    ,
	CONSTRAINT pk_dept PRIMARY KEY ( deptno )
 ) engine=InnoDB;

CREATE TABLE emp ( 
	empno                int  NOT NULL  AUTO_INCREMENT,
	ename                varchar(20)    ,
	job      			 varchar(20),
	mgr                  smallint    ,
	hiredate             date    ,
	sal                  numeric(7,2)    ,
	comm                 numeric(7,2)    ,
	deptno               int    ,
	CONSTRAINT pk_emp PRIMARY KEY ( empno )
 ) engine=InnoDB;

CREATE INDEX idx_emp ON emp ( deptno );

ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY ( deptno ) REFERENCES dept( deptno ) ON DELETE NO ACTION ON UPDATE NO ACTION;



insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');
  
insert into emp values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE ('17-11-1981','%d-%m-%Y'), 5000, null, 10);
insert into emp values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30);
insert into emp values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10);
insert into emp values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20);
insert into emp values( 7788, 'SCOTT', 'ANALYST', 7566, DATE_ADD(STR_TO_DATE('13-7-1987','%d-%m-%Y'),INTERVAL -85 DAY)  , 3000, null, 20);
insert into emp values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20);
insert into emp values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30);
insert into emp values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30);
insert into emp values( 7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-09-1981','%d-%m-%Y'), 1250, 1400, 30);
insert into emp values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30);
insert into emp values( 7876, 'ADAMS', 'CLERK', 7788, DATE_ADD(STR_TO_DATE('13-7-1987', '%d-%m-%Y'),INTERVAL -51 DAY), 1100, null, 20);
insert into emp values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30);
insert into emp values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10);

SELECT * FROM EMP;
SELECT * FROM DEPT;

drop procedure show_msg;

delimiter $$
create procedure show_msg()
begin
	declare my_msg varchar(50); -- 변수 선언
    set my_msg = 'Hello Stored Procedure';
    select my_msg;
end $$
delimiter ;

-- 프로시저 호출
call show_msg();


-- 현재 시간에서 1시간 후와 3시간 전의 시각을 구하는 프로시저
drop procedure if exists show_time;

delimiter //
create procedure show_time()
begin
	-- 변수 2개 선언 datetime 
    declare vdate1 datetime;
    declare vdate3 datetime;
    -- 실행문 작성 : now(), date_add(), date_sub()
    select date_add(now(), interval 1 hour),
    date_sub(now(), interval 3 hour) into vdate1, vdate3;
    
    select vdate1 as "1 시간 후", vdate3 as "3시간 전";    
end //
delimiter ;

call show_time();


DROP PROCEDURE IF EXISTS EMP_INFO;

DELIMITER //
CREATE PROCEDURE EMP_INFO(IN PNO INT)
BEGIN
	DECLARE VNAME VARCHAR(10);
    DECLARE VJOB VARCHAR(10);
    DECLARE VSAL DECIMAL(7,2);

	SELECT ENAME, JOB, SAL
    INTO VNAME, VJOB, VSAL
    FROM EMP
    WHERE EMPNO = PNO;
    
    SELECT PNO, VNAME, VJOB, VSAL;
END //
DELIMITER ;

CALL EMP_INFO(7369);

--부서번호를 인파라미터로 넘기면 해당 무서의 부서명과 근무지 가져오는 프로시져

delimiter //
create procedure dept_info (in pno int)
begin 
   declare vdname varchar(10);
   declare vloc varchar(10);
   
   select dname, loc
   into vdname, vloc
   from dept
   where deptno = pno;
   
   select pno, vdname, vloc;
end  //
delimiter ;

CALL DEPT_INFO(10); 

DELIMITER //
CREATE procedure EMP_FIND(in pno int, out oname varchar(30)) -- OUT파라미터 (출력매개변수)
begin
	select ename into oname
		from emp
		where empno = pno;
end//
DELIMITER;

--OUT파라미터 프로시저를 실행하려면 호출전에 아웃파라미터 위치에
--"@변수명"형태로 전달해줘야 함

CALL EMP_FIND(7369, @ENAME);
SELECT @ENAME AS "7369번 사원명";

-- DEPT 테이블에서 부서번호를 IN파라미터로 전달
-- 해당 부서의 평균임금, 최대임금, 최저임금
-- OUT파라미터로 전달하는 프로시저

DROP PROCEDURE DEPT_STAT;

delimiter $$
create procedure DEPT_STAT(in dno int , out avgsal decimal(7,2),
out maxsal decimal(7,2), out minsal decimal(7,2))
BEGIN
	SELECT AVG(SAL), MAX(SAL), MIN(SAL)
    INTO avgsal, maxsal, minsal
    FROM EMP
    WHERE DEPTNO=DNO;
END $$
DELIMITER ;

CALL DEPT_STAT(20, @AVG, @MX, @MN);

SELECT @AVG, @MX, @MN;

delimiter $$
create procedure DEPT_STAT2(inout dno int , out avgsal decimal(7,2),
out maxsal decimal(7,2), out minsal decimal(7,2))
BEGIN
	SELECT AVG(SAL), MAX(SAL), MIN(SAL)
    INTO avgsal, maxsal, minsal
    FROM emp
    WHERE DEPTNO=DNO;
END $$
DELIMITER ;

set @pno=10;
call dept_stat2(@pno,@avg, @mx, @mn);
select @pno, @avg, @mx, @mn;


DELIMITER;

DROP PROCEDURE EMP_INSERT;

DELIMITER //
CREATE PROCEDURE EMP_INSERT
(IN PNO INT, IN INAME VARCHAR(15), IN ISAL INT, IN IJOB VARCHAR(10))
BEGIN
	INSERT INTO EMP(EMPNO, ENAME, SAL,JOB)
    VALUES (PNO, INAME, ISAL, IJOB);
END//
DELIMITER ;

CALL EMP_INSERT(1111,'TERY',5550,'MANAGER')
									  


DELIMITER $$
CREATE PROCEDURE emp2_update(IN uempno INT, IN USAL INT)
BEGIN
	UPDATE EMP SET SAL=SAL+(SAL*(USAL/100))
	WHERE EMPNO = UEMPNO;
END $$
DELIMITER ;

CALL EMP2_UPDATE(1111, -20);
SELECT * FROM EMP

DROP PROCEDURE EMP_DELETE

delimiter $$
create procedure EMP_DELETE(IN PNO INT)
BEGIN
	DELETE FROM TEST_TABLE WHERE EMPNO= PNO;
    SELECT CONCAT(PNO, '번 사원정보를 삭제했습니다');
END $$
DELIMITER ;

CALL EMP_DELETE(1111);
SELECT * FROM TEST_TABLE