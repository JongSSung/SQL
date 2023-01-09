CREATE TABLE `error_log` (
    `error_log_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '에러 로그 ID',
    `proc_name` VARCHAR(100) NOT NULL COMMENT '프로시저 이름',
    `proc_step` TINYINT(3) UNSIGNED NOT NULL COMMENT '프로시저 내에서 에러가 발생한 스텝 번호',
    `sql_state` VARCHAR(5) NOT NULL COMMENT 'SQLSTATE',
    `error_no` INT(11) NOT NULL COMMENT '에러 번호',
    `error_msg` TEXT NOT NULL COMMENT '에러 메세지',
    `call_stack` TEXT NULL COMMENT '프로시저 호출 파라미터',
    `proc_call_date` DATETIME(0) NOT NULL COMMENT '프로시저 호출 일자',
    `log_date` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '로그 적재 일자',
    PRIMARY KEY (`error_log_id`))
ENGINE = InnoDB
COMMENT = 'DB 런타임 에러 로그';

CREATE DEFINER=CURRENT_USER() PROCEDURE `usp_add_terms_agreement_for_campaign`(
      IN pi_int_campaign_id int UNSIGNED    -- 캠페인 ID
    , IN pi_int_social_user_id int UNSIGNED -- 소셜 유저 ID
    , IN pi_dt5_now datetime(0)             -- 현재 서버 시각
    , OUT po_int_return int                 -- 리턴 값
)
DETERMINISTIC
SQL SECURITY DEFINER
CONTAINS SQL
COMMENT '
author : doeyull.kim
e-mail : purumae@gmail.com
created date : 2018-05-03
description : 캠페인 약관에 동의합니다.
parameter : 
      IN pi_int_campaign_id int UNSIGNED    -- 캠페인 ID
    , IN pi_int_social_user_id int UNSIGNED -- 소셜 유저 ID
    , IN pi_dt5_now datetime(0)             -- 현재 서버 시각
    , OUT po_int_return int                 -- 리턴 값
return value :
    0 = 에러가 없습니다.
    -1 = 예상하지 않은 런 타임 오류가 발생하였습니다.
'
proc_body: BEGIN
    DECLARE v_vch_proc_name varchar(100) DEFAULT 'usp_add_terms_agreement_for_campaign'; --현재 stored Procedure의 이름
    DECLARE v_iny_proc_step tinyint UNSIGNED DEFAULT 0; -- SQL Exception이 발생한 구문의 위치를 찾기 위해 사용, 위 변수를 디버깅할 때 유용
    DECLARE v_txt_call_stack text; --Input parameter 값을 json 형태로 변환하여 담는다
    DECLARE v_vch_sql_state varchar(5); --아래 3변수 SQL STATE, Error Number, Error Message를 담을 변수
    DECLARE v_int_error_no int;
    DECLARE v_txt_error_msg text;
 
 
 --SQLEXCEPTION conditon이 되었을 때, BEGIN ~ END 블럭의 내용을 실행하고 EXIT 즉, Stored Procedure실행을 강제로 종료
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_vch_sql_state = RETURNED_SQLSTATE --디버깅에 필요한 다음 세 가지 condition information을 가져온다 
            , v_int_error_no = MYSQL_ERRNO
            , v_txt_error_msg = MESSAGE_TEXT;
 
        ROLLBACK;
--Stored Procedure의 input parameter 값을 JSON 문자열로 만들어 v_txt_call_stack 변수에 담는다
        SET v_txt_call_stack = CONCAT('{"pi_int_campaign_id":', IF(pi_int_campaign_id IS NULL, 'null', pi_int_campaign_id)
            , ',"pi_int_social_user_id":', IF(pi_int_social_user_id IS NULL, 'null', pi_int_social_user_id)
            , ',"pi_dt5_now":', IF(pi_dt5_now IS NULL, 'null', CONCAT('"', pi_dt5_now, '"'))
            , '}'
        );

        INSERT error_log (proc_name, proc_step, sql_state, error_no, error_msg, call_stack, proc_call_date, log_date)
        VALUES (v_vch_proc_name, v_iny_proc_step, v_vch_sql_state, v_int_error_no, v_txt_error_msg, v_txt_call_stack, pi_dt5_now, NOW(0));

 --프로시저가 정상적으로 실행 : SET po_int_return =0;
 -- SQL Exeption이 발생하여 'error_log' 테이블에 로깅 : SET po_int_return=-1;
        SET po_int_return = -1;
 
 --error condition 정보를 Stored Procedure를 호출한 클라이언트에게 전환
 --RESIGNAL 하지 않으면 Stored Procedure를 호출한 클라이언트는 SQL Exception이 발생했다는 사실을 감지못하기에 RESIGNAL이 필요
        RESIGNAL;
    END;
