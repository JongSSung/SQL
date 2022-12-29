-- GET DIAGNOSTICS
-- GET DIAGNOSTICS 명령문은 실행된 이전 SQL문에 대한 정보를 얻습니다.
-- 구문

구문 도표 읽기시각적 구문 도표 생략
        .-CURRENT-.                                           
>>-GET--+---------+--DIAGNOSTICS--+-statement-information-+----><
        '-STACKED-'               +-condition-information-+   
                                  '-combined-information--'   

statement-information

     .-,-------------------------------------------.      
     V                                             |      
|--+---variable-1-- = --statement-information-item-+--+---------|
   '-variable-1-- = --DB2_GET_DIAGNOSTICS_DIAGNOSTICS-'   

condition-information

|--CONDITION--+-variable-2-+------------------------------------>
              '-integer----'   

   .-,------------------------------------------------.   
   V                                                  |   
>----variable-3-- = --+-connection-information-item-+-+---------|
                      '-condition-information-item--'     

combined-information

|--variable-4-- = ---------------------------------------------->

                                                   (1)   
>--ALL--+----------------------------------------+--------------|
        | .-,----------------------------------. |       
        | V                                    | |       
        '---+-STATEMENT----------------------+-+-'       
            '-+-CONDITION--+--+------------+-'           
              '-CONNECTION-'  +-variable-5-+             
                              '-integer----'   
                              
CONDITION variable–2 또는 integer

정보가 요청되는 진단을 식별합니다. SQL문을 실행하는 동안 발생하는 각 진단은 정수를 지정받습니다. 값 1은 첫 번째 진단을 나타내고, 2는 두 번째 진단을 나타내는 방식입니다. 값이 1이면 검색된 진단 정보는 이전 SQL문 (GET DIAGNOSTICS 명령문이 아닌) 실행에서 실제 리턴된 SQLSTATE 값으로 표시된 조건에 해당됩니다. 지정된 변수는 스케일이 0인 정확한 숫자 변수를 선언하기 위한 규칙에 따라 프로그램에서 선언되어야 합니다. 글로벌 변수가 아니어야 합니다. 지정된 값은 0보다 작지 않거나 사용 가능한 진단의 수보다 크지 않아야 합니다.
variable–3
변수를 선언하기 위한 규칙에 따라 프로그램에서 선언된 변수를 식별합니다. 글로벌 변수가 아니어야 합니다. 변수의 데이터 유형은 지정된 조건 정보 항목을 위한 표 1에서 지정된 대로 데이터 유형과 호환 가능해야 합니다. 변수는 검색 지정에서 설명된 검색 지정 규칙에 따라 지정된 조건 정보 항목의 값을 지정받습니다. 변수에 지정 시 값이 잘리면, 오류가 리턴되고 진단 영역의 GET_DIAGNOSTICS_DIAGNOSTICS 항목이 이 조건에 대한 세부사항으로 갱신됩니다.
지정된 진단 항목이 진단 정보를 포함하지 않는 경우, 변수는 해당 데이터 유형을 기반으로 기본값으로 설정됩니다.

정확한 숫자 진단 항목의 경우 0,
VARCHAR 진단 항목의 경우 빈 스트링,
그리고 CHAR 진단 항목의 경우 공백으로 둡니다.