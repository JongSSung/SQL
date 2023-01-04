/*
만약 A, B라는 컬럼을 인자로 COALSESC 함수로 주게 되면
A 컬럼 값이 NULL 값이 아닌 경우 A 값을 리턴하고 A가 NULL이고 B가 NULL이 아닌 경우 B 값을 리턴합니다. 모든 인수가 NULL이면 NULL을 반환
*/

SELECT A, B, COALESCE(A,B) FROM table_a;

/*
A	        B	    COALESCE(A, B)
1	       NULL	          1
NULL	    2	          2
NULL 	    NULL	     NULL

*/


/*
특정열의 NULL 값을 적절한 값으로 치환할 때 사용하기 용이합니다. 
만약 아래와 같이 사용한다면 div 열에 값이 NULL이 아닌경우 
div의 열값을 NULL인 경우에는 0 값을 리턴하므로 해당 열의 NULL을 0으로 변환해서 처리할 수 있습니다
*/

SELECT div, COALESCE(div, 0) FROM table_a;

/*
div	        COALESCE(div, 0)
2	            2
NULL        	0
5	            5
*/

/*
= 연산자는 SET 문의 일부로 또는 UPDATE 문의 SET 절의 일부로 값을 할당합니다. 
다른 경우에 = 연산자는 비교 연산자로 해석됩니다. 반면 := 연산자는 값을 할당하며 비교 연산자로 해석되지 않습니다.
*/