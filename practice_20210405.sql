/*
## @실습문제
1. EMPLOYEE테이블의 퇴사자관리를 별도의 테이블 TBL_EMP_QUIT에서 하려고 한다.
다음과 같이 TBL_EMP_JOIN, TBL_EMP_QUIT테이블을 생성하고, TBL_EMP_JOIN에서 DELETE시 자동으로 퇴사자 데이터가 
TBL_EMP_QUIT에 INSERT되도록 트리거를 생성하라.
-TBL_EMP_JOIN 테이블 생성 : EMPLOYEE테이블에서 QUIT_DATE, QUIT_YN 컬럼제외하고 복사
    CREATE TABLE TBL_EMP_JOIN
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE
    FROM EMPLOYEE
	WHERE QUIT_YN = 'N';
    SELECT * FROM TBL_EMP_JOIN;
-TBL_EMP_QUIT : EMPLOYEE테이블에서 QUIT_YN 컬럼제외하고 복사
    CREATE TABLE TBL_EMP_QUIT
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE
    FROM EMPLOYEE
    WHERE QUIT_YN = 'Y';
	SELECT * FROM TBL_EMP_QUIT;
*/

CREATE TABLE TBL_EMP_JOIN
AS
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE
FROM EMPLOYEE
WHERE QUIT_YN = 'N';

SELECT * FROM TBL_EMP_JOIN;

CREATE TABLE TBL_EMP_QUIT
AS
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE
FROM EMPLOYEE
WHERE QUIT_YN = 'Y';

SELECT * FROM TBL_EMP_QUIT;

create or replace trigger trg_emp_quit
    before
    delete on tbl_emp_join
    for each row
begin
    insert into tbl_emp_quit values(
        :old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, :old.dept_code, :old.job_code,
    :old.sal_level, :old.salary, :old.bonus, :old.manager_id, :old.hire_date, sysdate
    );
end;
/
delete from tbl_emp_join where emp_id = 223;