--==================================
--관리자(system)계정
--===================================
--student계정 생성 및 권한부여
create user student
identified by student
default tablespace users;

grant connect, resource to student;

--========================================
--Student 계정
--=========================================
--member 테이블 생성
create table member (
    member_id varchar2(15),
    password varchar2(15) not null,
    member_name varchar2(50) not null,
    gender char(1),
    age number,
    email varchar2(300),
    phone char(11) not null,
    address varchar2(300),
    hobby varchar2(100),
    enroll_date date default sysdate,
    constraint pk_member_id primary key(member_id),
    constraint ck_gender check(gender in ('M', 'F'))
);

--sample data 추가
insert into member
values(
    'honggd', '1234', '홍길동', 'M', 30, 'honggd@naver,com', '01012341234',
    '서울 강남구 테헤란로', '등산, 그림, 요리', default
);

select * from member;

insert into member
values(
    'gogd', '1234', '고길동', 'M', 35, 'gogd@naver,com', '01012345678',
    '서울 서초구', '산책, 영화', default
);
insert into member
values(
    'leegd', '1234', '이길동', 'F', 28, 'leegd@naver,com', '01033334444',
    '서울 영등포구', '음악', default
);
insert into member
values(
    'sinsa', '1234', '신사임당', 'F', 48, 'sinsa@naver.com', '01099998888',
    '경기도 광주', '요리, 검술', default
);
insert into member
values(
    'sejong', '1234', '세종대왕', 'M', 76, 'sejong@naver.com', '01033332345',
    '서울시 중구', '독서, 육식', default
);
select * from member;

commit;