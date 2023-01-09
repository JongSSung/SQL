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


drop procedure cursorproc;

delimiter$$ --스토어드 프로그램 시작
create procedure cursorProc()
begin
	declare vsal int;--변수 선언 급여
	declare cnt int default 0; -- 읽은행의수
	declare totalsal int default 0; -- 급여 합계
	
	declare endOfRow boolean default false; -- 행의 끝 여부 기본 false지정
	
	declare userCursor cursor for -- 아래줄 셀렉트를 usercursor로 선언
		select sal from emp;		--emp 테이블에서 급여만 선택해 윗줄 userCursor에
		
	declare continue handler --행의 끝이면, SET endOfRow = True (변수에 True대입)
		for not found set endOfRow = True;
		
	open userCursor; --커서 열기
	
	cursor_loop : loop --루프햘 명칭 : loop 시작
		fetch userCursor into vsal; -- userCursor(키)값을 vsal변수에 입력. 급여 1개를 대입
		
		if endofrow then --더이상 읽을 행이 없으면 loop를 종료
			leave cursor_loop;
		end if;
		
		set cnt = cnt +1;
		set totalsal = totalsal + vsal;
	end loop cursor_loop; --루프 끝나고 cursor_loop 시작점으로 다시 올라감
	
	--급야 평균을 출력
	select concat('급여 평균==>',avg(totalsal));
	
	close userCursor; -- 커서닫기
	
end $$	--프로시저 코드 끝
delimiter; 

call cursorProc(); --호출