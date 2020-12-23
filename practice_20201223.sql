show user;

--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)
select category 학과, trunc(avg(capacity)) 평균
from tb_department
group by category
order by 2 desc;

--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)
select department_no 학과 , count(*) 학생수 
from tb_student
where absence_yn ='N'
group by department_no
order by 2 desc;

--3. 과목별 지정된 교수가 2명이상이 과목번호와 교수인원수를 조회
select class_no 과목번호, count(professor_no) 교수인원수
from tb_class_professor
group by class_no
having count(professor_no) >= 2;

--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 
--과목수가 10개 이상인 행의 학과번호, 과목구분(class_type), 과목수를 조회(전공선택만 조회)
select department_no 학과번호, class_type 과목구분, count(*) 과목수
from tb_class
group by department_no, class_type
having count(*) >= 10 and class_type = '전공선택';


--@실습문제 : join @chun

--1. 학번, 학생명, 학과명 조회
select S.student_no 학번,
        S.student_name 학생명, 
        D.department_name 학과명
from tb_student S join tb_department D
    on S.department_no = D.department_no;
    --using(department_no);
    
--2. 학번, 학생명, 담당교수명 조회 (담당교수가 없는 학생도 포함해서 조회할것.)
desc tb_professor; 
desc tb_student; 

select S.student_no 학번, S.student_name 학생명, P.professor_name 담당교수명
from tb_student S left join tb_professor P
    on S.coach_professor_no = P.professor_no;

--3. 수업번호, 수업명, 교수번호, 교수명 조회
select class_no 수업번호, 
        C.class_name 수업명, 
        professor_no 교수번호,
        P.professor_name 교수명
from tb_class C join tb_class_professor CP
        using(class_no)
        join tb_professor P
    using(professor_no);


--4. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수)
select G.term_no 학기,
        student_no 학번,
        S.student_name 학생명,
        C.class_name 수업명,
        G.point 점수
from tb_grade G join tb_student S
    using(student_no)
    join tb_class C
    using(class_no)
where S.student_name = '송박선';
    
--5. 학생별 과목별 전체 평점(소수점이하 첫째자리 버림) 조회 (학번, 학생명, 평점)
select student_no 학번, S.student_name 학생명, C.class_name 과목명, trunc(avg(G.point),2) 학점
from tb_student S join tb_class C
    using(department_no)
    join tb_grade G
    using(student_no)
group by student_no, S.student_name, C.class_name
order by 1;
