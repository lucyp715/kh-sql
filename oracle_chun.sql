show user;

select * from tb_department;
select * from tb_student;
select * from tb_professor;
select * from tb_class;
select * from tb_class_professor;
select * from tb_grade;

--1
select department_name as "학과 명", category as 계열
from tb_department;

--2
select category || '의 정원은 ' || capacity || '명 입니다.' as "학과별 정원"
from tb_department;

--3
select student_name as 학생이름, absence_yn as 휴학여부
from tb_student
where substr(student_ssn,8,1) in (2,4) 
        and department_no = '001' 
        and absence_yn = 'Y';
        
--4
select STUDENT_NAME
from tb_student
WHERE STUDENT_NO BETWEEN 'A513079' AND 'A513119'
order by STUDENT_NAME desc;

--5
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY <= 30 AND CAPACITY >= 20;

--6
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

--7
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

--8
SELECT CLASS_NO
FROM TB_CLASS
WHERE preattending_class_no IS NOT NULL;

--9
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT
ORDER BY CATEGORY ASC;

--10
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'N' 
    AND STUDENT_NO LIKE 'A2%'
    AND STUDENT_ADDRESS LIKE '%전주%'
ORDER BY STUDENT_NAME ASC;

