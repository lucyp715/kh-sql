--=================================
--PL/SQL
--=================================
-- Procedural Language Extension to SQL SQL에 대한 절차적 지향
-- 오라클 내장 절차적 언어로써, SQL을 확장하여, 변수정의, 조건/반복처리 등을 지원한는 문법

--대표적인 유형
--1. 익명블럭 : 일회성으로 PL/SQL 실행구조를 가진 블럭
--2. 프로시져 : PL/SQL 문법을 사용하는 대표정 DB객체. 다른 프로시져/서브프로그램등에 의해 호출 사용
--3. 함수 : 프로시져와 유사하나 반드시 하나의 리턴값을 갖는 DB객체

---------------------------------------------------------
--익명블럭
--------------------------------------------------------
/*
declare
    변수/상수 선언부(선택)
begin
    실행구문(필수)
exception
    예외처리구문(선택)
end;
/ 익명블럭 종료(슬래쉬 / 잊지말것)(필수)
*/

--pl/sql 콘솔출력 설정 : 세션마다 최초 1회설정할 것
set serveroutput on;

begin
    --pl/sql출력구문 : dbms_putput패키지의 put_line프로시져 호출
    dbms_output.put_line('안녕하세요');
end;
/

--맛보기
declare
    id number;
begin
    select emp_id
    into id --쿼리 조회 결과를 pl/sql 변수에 담음
    from employee
    where emp_name = '&사원명';
    --|| sql에서 문자열 +
    dbms_output.put_line('id = ' || id); 
exception
    --try catch절에서 하는 것과 똑같은
    when no_data_found then dbms_output.put_line('해당 사원이 존재하지 않습니다.');

end;
/

--변수
--자료형 
--1. 일반 sql 자료형(varchar2, char, number, date)을 귿로 사용가능하다.
--2. boolean(true|false|null), pls_integer, binary_integer
--3. 복합자료형 recore, cursor, collection
--타입
--1. 일반변수
--2. 참조변수 : 존재하는 테이블 컬럼혹은 행의 타입을 가져와 사용할 수 있다.

declare
    a number;
    b varchar2(100) := '안녕'; --값대입연산자:=
    c CONSTANT date := sysdate;
    d boolean;
begin
    a := 10 * 20;
    d := true;
    dbms_output.put_line(a);
    dbms_output.put_line(b);
    dbms_output.put_line(c);
    if d then
        dbms_output.put_line('참');
        end if;
end;
/

desc employee;

declare
    v_emp_id employee.emp_id%type;
    v_emp_name employee.emp_name%type; --VARCHAR2(20)
    v_emp_no employee.emp_no%type;
    
    emp_row employee%rowtype;
begin
    v_emp_id := &사번;
    select emp_name, emp_no
    into v_emp_name, v_emp_no
    from employee
    where emp_id = v_emp_id;
    
    dbms_output.put_line(v_emp_id || ' : ' || v_emp_name || ' ' || v_emp_no);

    select *
    into emp_row
    from employee
    where emp_id = v_emp_id;
    
    dbms_output.put_line(emp_row.email);
    dbms_output.put_line(emp_row.phone);
end;
/

--record : 사용자정의 type생성
declare
    type my_record is record(name employee.emp_name%type, title department.dept_title%type);
    emp_row my_record;
begin
    select E.emp_name, D.dept_title
    into emp_row
    from employee E 
        left join department D
            on E.dept_code = D.dept_id
    where E.emp_id = '&사번';
    
    dbms_output.put_line(emp_row.name);
    dbms_output.put_line(emp_row.title);

end;
/

--@실습문제 : 사원명을 입력받고, 사번, 사원명, 직급명을 출력하는 익명블럭을 작성하세요
--%type, %rowtype, record
declare
    type my_record is record(
        id employee.emp_id%type,
        name employee.emp_name%type,
        job_name job.job_name%type
    );
    my_row my_record;
begin
    select emp_id, emp_name, job_name
    into my_row
    from employee 
        join job
            using(job_code)
    where emp_name = '&사원명';
    
    dbms_output.put_line(my_row.id);
    dbms_output.put_line(my_row.name);
    dbms_output.put_line(my_row.job_name);
end;
/

--PL/SQL에서 dml처리도 가능
create table users (
    no number primary key,
    name varchar2(100) not null
);
create sequence seq_users_no;

begin
    insert into users (no, name)
    values(seq_users_no.nextval, '&이름');
    --pl/sql구문안에서 함께 transaction처리
    commit;
end;
/

select * from users;

--조건문
/*
if 조건식 then
    참일때, 처리구문
else
    거짓일때, 처리구문
end if;

if 조건식1 then
    처리구문
elsif 조건식2 then
    처리구문
elsif 조건식3 then
    처리구문
end if;
*/

declare
    num number;
begin
    num := &정수;
    
    if mod(num, 2) = 0 then
        dbms_output.put_line('짝수');
    else
        dbms_output.put_line('홀수');
    end if;
    dbms_output.put_line('---프로그램 종료 ---');
end;
/

--@실습문제 : 사번을 입력받고, 직급명을 조회
--직급명이 '대표'인 경우, 대표님 안녕하세요 출력
--직급명이 '부사장'인 경우, 부사장님 안녕하세요 출력
--그외의 경우, 안녕하세요 출력

declare
   type my_record is record( id employee.emp_id%type, job_name job.job_name%type);
    my_row my_record;
begin
     select emp_id, job_name
    into my_row
    from employee 
        join job
            using(job_code)
    where emp_id = '&사번';
    
    if (my_row.job_name ='대표')then
       dbms_output.put_line('사장님 안녕하세요');
   elsif(my_row.job_name = '부사장') then
        dbms_output.put_line('부사장님 안녕하세요');
    else
        dbms_output.put_line('안녕하세요');
    end if;
end;
/
/*
declare
    v_job_name job.job_name%type;
begin
    select job_name
    into v_job_name
    from employee join job
        using(job_code)
    where emp_id = '&사번';
    
    if v_job_name in ('대표', '부사장') then
        dbms_output.put_line(v_job_name || '님, 안녕하세요');
    else
        dbms_output.put_line('안녕하세요');
    end if;
end;
/
*/
/* 강사님꺼
declare
    job_name job.job_name%type;
begin
    select job_name
    into job_name
    from employee 
        join job
            using(job_code)
    where emp_id = '&사번';
    
    dbms_output.put_line(job_name);
    
    if job_name = '대표' then
        dbms_output.put_line('대표님, 안녕하세요.');
    elsif job_name = '부사장' then
        dbms_output.put_line('부사장님, 안녕하세요.');
    else
        dbms_output.put_line('안녕하세요.');
    end if;
    
end;
/
*/

--조건식 case문
-- 정수를 입력받고, 선물뽑기 게임 익명블럭
declare
--    num number := '&정수';
    num number;
begin
    num := dbms_random.value(1, 100);
    dbms_output.put_line(num);
    num:=trunc(num);
--    case mod(num, 5)
--        when 0 then dbms_output.put_line('인형을 뽑았습니다.');
--        when 1 then dbms_output.put_line('오토바이를 뽑았습니다.');
--        else dbms_output.put_line('꽝입니다.');
--    end case;
    
    case 
        when mod(num, 5) = 0 then dbms_output.put_line('인형을 뽑았습니다.');
        when mod(num, 5) = 1 then dbms_output.put_line('오토바이를 뽑았습니다.');
        else dbms_output.put_line('꽝입니다.');
    end case;
end;
/

--반목문
--1. loop 무한반복
--2. while loop
--3. for loop

declare
    n number := 1;
begin
    loop
        dbms_output.put_line(n);
        n := n + 1;
        --반복문 탈출조건 명시
--        if n > 10 then
--            exit;
--        end if;
        exit when n > 10;
    end loop;
end;
/

--@실습문제 : 1 ~ 10사이의 난수 10개 출력
declare
    r number; --난수
    i number := 1; --반복문 증감변수
begin
    loop
        r := dbms_random.value(1, 10);
         i := i + 1;
        dbms_output.put_line(trunc(r));
        exit when i > 10;
    end loop;
    
end;
/
/* 강사님
declare
    r number; -- 난수
    i number := 0; -- 반복문 증감변수
begin
    loop
        r := trunc(dbms_random.value(1,11));
        dbms_output.put_line(i + 1 || ' : ' || r);
        i := i + 1;
        exit when i > 9;
    end loop;  
end;
/
*/

--while loop
declare
    n number := 1;
begin
    while n <= 10 loop
        dbms_output.put_line(n);
        n := n + 1;
    end loop;
end;
/

--for loop
--증감변수를 선언할 필요없다
-- reverse(거꾸로나옴))를 사용해 최대값에서 최소값으로 -1 처리가능
-- 증감변수를 임의로 변경 할 수 없다
--증가값을 변경 할 수 없다
begin
    for n in 200..210 loop
    dbms_output.put_line(n);
    end loop;
end;
/

declare
    start_ number := 200;
    end_ number := 210;
begin
    for n in start_..end_ loop
        dbms_output.put_line(n);
    end loop;
    dbms_output.put_line('끝');
end;
/

declare 
    s number := 200;
    e number := 210;
    emp_row employee%rowtype;
begin
    for n in s..e loop
        --dbms_output.put_line(n);
        select *
        into emp_row
        from employee
        where emp_id = n;
        dbms_output.put_line(emp_row.emp_name);
        
    end loop;
end;
/

--================================
--FUNCTION
--===================================
-- 프로시져객체의 파생형, 리턴값이 반드시 하나 존재해야 한다.
/*
create or replace function 함수 (매개변수1, 매개변수2, ...)
return 자료형
is
    --변수선언부
begin
    --실행구문
    return 값;
end;
/
*/
--매개변수, 리턴 선언문에는 자료형의 크기를 명시하지 않는다.
create or replace function func_dnameb (name varchar2)
return varchar2
is
    result varchar2(32767); --pl/sql 자료형의 최대 32767byte까지 가능
begin
    result := 'd' || name || 'b';
    return result;
end;
/
--Function FUNC_DNAMEB이(가) 컴파일되었습니다. -> 즉시 실행가능한 형태로 저장되었다.

--함수 실행
--1. 일반 sql문에서 사용
select func_dnameb(emp_name)
from employee;
--2. pl/sql구문에서 사용
begin
    dbms_output.put_line(func_dnameb('&이름'));
end;
/

--DataDictionary에서 조회
select *
from user_procedures
where object_type = 'FUNCTION';

--성별조회
select E.*,
    case substr(emp_no, 8, 1)
            when '1' then '남'
            when '2' then '여'
            when '3' then '남'
            when '4' then '여'
    end gender
from employee E;

select *
from (
    select E.*,
           case 
                when substr(emp_no, 8, 1) in ('1', '3') then '남'
                else '여'
           end gender
    from employee E
    )
where gender = '여';


create or replace function func_gender(emp_no employee.emp_no%type)
return char
is 
    gender char(3);
begin
    --pl/sql에서 decode단독사용불가
    case 
        when substr(emp_no, 8, 1) in ('1', '3') then gender := '남';
        else gender := '여';
    end case;
    return gender;
    
end;
/

select E.*,
        func_gender(emp_no)
from employee E
where func_gender(emp_no) = '여';

--=========================
--PROCEDURE
--========================
--일련의 작업절차를 하나의 객체로 만들어 저장. 호출해서 재사용이 가능
--함수와 달리 리턴값이 없다.
--전달한 매개변수의 mode(in | out | inout) out을 사용하면, 호출부로 연산결과를 전달할 수 있다.
--in이면 (받아올것)값이넘어오고, out이면 주소값넘어오는 개념(담아서 내보낼것)
--db에 미리 컴파일된 채 저장하므로 효율성이 좋다.
--일반 sql문에 사용불가. execute명령 또는 다른 pl/sql구문에서 호출가능.


/*
create or replace procedure 프로시져명(매개변수1 이름 mode 자료형 , 매개변수2 이름 mode 자료형, ...)
is
    --변수선언
begin
    --실행구문
end;
/
*/

--특정사원정보를 삭제하는 프로시져
create table emp_copy
as
select * from employee;

select * from emp_copy;

-- in 프로시져로 매개인자 전달용
-- out 프로시져에서 호출부로 값 전달용
-- inout in + out
create or replace procedure proc_del_emp(p_emp_id emp_copy.emp_id%type)
is

begin
    delete from emp_copy where emp_id = p_emp_id;
    commit;
    --트랜잭션 처리도 해줘여함.
end;
/

execute proc_del_emp('223');
--application procedure호출시에는 CallableStatement객체를 사용해야한다.
select * from emp_copy;

--call by reference으로 out매개변수는 작동한다.
create or replace procedure proc_emp_info(
    p_emp_id in emp_copy.emp_id%type,
    p_emp_name out emp_copy.emp_name%type,
    p_phone out emp_copy.phone%type
)
is

begin
    select emp_name, phone
    into p_emp_name, p_phone
    from emp_copy
    where emp_id = p_emp_id;
    
end;
/

--익명블럭에서 프로시져 호출
declare
    name emp_copy.emp_name%type;
    phone emp_copy.phone%type;
begin
    proc_emp_info('&사번', name, phone);
    dbms_output.put_line('name : ' || name);
    dbms_output.put_line('phone : ' || phone);
end;
/

--upsert 프로시져
--insert + update
create table job_copy
as
select *from job;

select *from job_copy;

--제약조건추가
alter table job_copy
add constraint pk_job_copy primary key(job_code)
modify job_name not null;

alter table job_copy
add constraint pk_job_copy primary key(job_code)
modify job_code varchar2(5)
modify job_name not null;

--alter table job_copy modify job_code varchar2(5);

create or replace procedure proc_upsert_job_copy(
    p_job_code in job_copy.job_code%type,
    p_job_name in job_copy.job_name%type
)
is
    cnt number := 0;
begin
    select count(*)
    into cnt
    from job_copy
    where job_code = p_job_code;
    dbms_output.put_line('cnt = ' || cnt);
    
    if cnt = 0 then
        -- insert
        insert into job_copy
        values(p_job_code, p_job_name);
    else
        -- update
        update job_copy
        set job_name = p_job_name
        where job_code = p_job_code;
    end if;
    --트랜잭션 처리
    commit;
end;
/

--테스트
execute proc_upsert_job_copy('J8', '인턴');
execute proc_upsert_job_copy('J8', '수습');
  
select * from job_copy;