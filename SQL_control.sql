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

CREATE INDEX idx_emp ON emp ( deptno );PRO

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

create table EMP_TEST select * from emp
create table dept_TEST select * from dept

select * from emp_test;

DELIMITER //
CREATE PROCEDURE LOOP_TEST(IN PNAME VARCHAR(10))
BEGIN
	DECLARE VCNT INT;
    SET VCNT = 8500;
    
    MYLABEL : LOOP
		-- INSERT문 수행하되 VCNT를 EMPNO으로 넣기
        -- 사원명 PNAME으로, 급여는 (VCNT-2000) , 업무 : SALESMAN
        -- VCNT값은 반복문을 돌면서 10씩 증가시키세요 VCNT 값이 8600이 되엇을 때 반복문 벗어나기
        INSERT INTO emp_test(EMPNO,ENAME,SAL,JOB)
        VALUES(VCNT,PNAME,(VCNT-2000),'SALESMAN');
        SET VCNT = VCNT+10;
			IF VCNT >=8600 THEN
					LEAVE MYLABEL;
		END IF;
    END LOOP;
    SELECT '루프문 수행 완료';
END //

DELIMITER ;

drop procedure loop_test

select * from emp_test order by 1 desc;
call loop_test('peter')
		
-- 프로시저에서 동적인 SQL문 활용
-- 테이블명을 인파라미터로 전달하면 해당 테이블의 데이터를
-- 조회하는 프로시저를 작성

DELIMITER //
CREATE PROCEDURE DYNAMIC(IN TNAME VARCHAR(30))
BEGIN

-- 변수 선언해서 SELECT 문을 할당
	SET @QUERY = CONCAT('SELECT * FROM ',TNAME);
-- [1] 동적인 SQL문을 실행시킬 준비
	PREPARE MYQ FROM @QUERY;	-- MYQ를 준비시킴
    
-- [2] SQL문을 실행 
	EXECUTE MYQ; -- MYQ를 실행
    
-- [3] 준비되었던 동적인 SQL문을 해제
	DEALLOCATE PREPARE MYQ; -- MYQ를 해제
END //
DELIMITER ;

CALL DYNAMIC('EMP');

/*
select 문에 의한 결과가 다중 레코드일 때는 cursor를 이용해야 한다.
cursor : 질의 결과 얻어진 여러 행이 저장된 메모리상의 위치
	여러행을 처리하기 위해서는 명시적 커서를 사용하여
	커서를정의하고 열고 커서를 이용하여 데이터를 읽고 닫을 수 있다.
*/

DELIMITER //
CREATE PROCEDURE EMPALL()
BEGIN
DECLARE VNAME VARCHAR(20);
DECLARE VJOB VARCHAR(20);
DECLARE VDATE DATE;

SELECT ENAME,JOB,HIREDATE
INTO VNAME,VJOB,VDATE
FROM EMP ORDER BY 1;

SELECT VNAME, VJOB, VDATE AS "모든 사원 정보";

END//
DELIMITER ;

CALL EMPALL(); -- error

-- 1 개의 레코드를 초과하는 결과셋이 있을 경우는 
-- 커서를 선언해서 커서를 이동시켜가면서 데이터를 인출해야한다.

DROP PROCEDURE IF exists EMPALL;

-- cursor 사용

DELIMITER //
CREATE PROCEDURE EMPALL()
BEGIN

DECLARE VNAME VARCHAR(20);
DECLARE VJOB VARCHAR(20);
DECLARE VDATE DATE;


DECLARE endOfrow BOOLEAN default FALSE; -- 레코드가 있는지 여부를 판단할 변수 선언
-- [1] 커서선언
DECLARE ECR CURSOR FOR
	SELECT ENAME, JOB, HIREDATE FROM EMP ORDER BY 1;
    
    DECLARE CONTINUE HANDLER FOR
		NOT FOUND SET endOfrow=TRUE;	-- 더 이상의 행이 발견되지 않을 경우 SET 절을 수행한다.

-- [2] 커서를 OPEN
OPEN ECR;

-- [3] 반복문을 돌면서 커서로부터 데이터를 인출하기 (FATCH)
-- 			( 이 때 반복문을 빠져나갈 조건을 걸어주자)
MLOOP : LOOP
	-- 커서에서 데이터 인출
    FETCH ECR INTO VNAME, VJOB, VDATE;
	IF endOfrow THEN
		LEAVE MLOOP;
    END IF;
    SELECT VNAME, VJOB, VDATE;
END LOOP;
-- [4] 커서를 CLOSE
CLOSE ECR;
END //
DELIMITER ;

CALL EMPALL();


delimiter $$
create procedure emp2all()
begin
	declare pjob varchar(15);
    declare cnt int;
    declare max int;
    declare av int;
    DECLARE SM INT;
    DECLARE MIN INT;
    
    declare endofrow boolean default false;
    
    declare ecr cursor for 
		select job,count(empno),max(sal),MIN(SAL),SUM(SAL),round(avg(sal)) from emp
        group by job;
        
	declare continue handler for
		not found set endofrow = true; 
        
    open ecr;
    
   /* mloop : loop
        fetch ecr into pjob,cnt,max,MIN,SM,av;
		if endofrow then
			leave mloop;
		end if;
        select pjob,cnt,max,MIN,SM,av order by 1;
	end loop; */
    WHILE ENDOFROW = FALSE DO
    
		FETCH ECR INTO PJOB,CNT,MAX,MIN,SM,AV;
		select pjob,cnt,max,MIN,SM,av order by 1;
        
    END WHILE;
    
	close ecr;
end $$
delimiter ;

drop procedure emp2all
call emp2all();