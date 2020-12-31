/*
@실습문제 : CREATE
 테이블을 적절히 생성하고, 테이블, 컬럼주석을 추가하세요.
1. 첫번째 테이블 명 : EX_MEMBER
* MEMBER_CODE(NUMBER) - 기본키                       -- 회원전용코드 
* MEMBER_ID (varchar2(20) ) - 중복금지                  -- 회원 아이디
* MEMBER_PWD (char(20)) - NULL 값 허용금지                 -- 회원 비밀번호
* MEMBER_NAME(varchar2(30))                             -- 회원 이름
* MEMBER_ADDR (varchar2(100)) - NULL값 허용금지                    -- 회원 거주지
* GENDER (char(3)) - '남' 혹은 '여'로만 입력 가능             -- 성별
* PHONE(char(11)) - NULL 값 허용금지                   -- 회원 연락처
*/

--테이블생성
create table EX_MEMBER (
    member_code number,
    member_id varchar2(20),
    member_pwd char(20) not null,
    member_name varchar2(30),
    member_addr varchar2(100) not null,
    gender char(3),
    phone char(11) not null,
    constraint pk_ex_member_code primary key(member_code),
    constraint uq_ex_member_id unique (member_id),
    constraint ck_ex_member_gender check(gender in ('남', '여'))
    );
 
--테이블주석추가   
comment on table EX_MEMBER is '회원관리 테이블';

--테이블 주석확인
select *
from user_tab_comments
where table_name = 'EX_MEMBER';

--컬럼주석추가
comment on column ex_member.member_code is '회원전용코드';
comment on column ex_member.member_id is '회원 아이디';
comment on column ex_member.member_pwd is '회원 비밀번호';
comment on column ex_member.member_name is '회원 이름';
comment on column ex_member.member_addr is '회원 거주지';
comment on column ex_member.gender is '성별';
comment on column ex_member.phone is '회원 연락처';

--컬럼주석확인
select*
from user_col_comments
where table_name = 'EX_MEMBER';


/*
2. EX_MEMBER_NICKNAME 테이블을 생성하자. (제약조건 이름 지정할것)
(참조키를 다시 기본키로 사용할 것.)
* MEMBER_CODE(NUMBER) - 외래키(EX_MEMBER의 기본키를 참조), 중복금지       -- 회원전용코드
* MEMBER_NICKNAME(varchar2(100)) - 필수                       -- 회원 이름
*/

--테이블생성
create table EX_MEMBER_NICKNAME(
    member_code number,
    member_nickname varchar2(100) not null,
    constraint pk_ex_member_nickname_code primary key(member_code),
    constraint fk_ex_member_nickname_code foreign key(member_code)
                                                    references ex_member(member_code)
);

--컬럼주석추가
comment on column ex_member_nickname.member_code is '회원전용코드';
comment on column ex_member_nickname.member_nickname is '회원 이름';

--컬럼주석확인
select*
from user_col_comments
where table_name = 'EX_MEMBER_NICKNAME';

--rename제약조건
select UC.table_name, UCC.column_name, UC.constraint_name, 
       UC.constraint_type, UC.search_condition
from user_constraints UC join user_cons_columns UCC
    on UC.constraint_name = UCC.constraint_name
where UC.table_name = 'EX_MEMBER_NICKNAME';

alter table EX_MEMBER_NICKNAME
rename constraint SYS_C007212 to nn_ex_member_nickname;
