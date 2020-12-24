
--@실습문제

--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
select to_char(to_date('2020년 12월 25일', 'yyyy"년" mm"월" dd"일"'),'day')요일
from dual;

--2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.
select E.emp_name 사원명, E.emp_no 주민번호, D.dept_title 부서명, J.job_name 직급명
from employee E join department D
        on E.dept_code = D.dept_id 
        join job J
        using(job_code)
where substr(E.emp_no,1,1) = 7 and substr(E.emp_no,8,1) = 2 and E.emp_name like '전%';

--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.

select E.emp_id 사번, E.emp_name 사원명,
        extract(year from sysdate) - (decode(substr(emp_no,8,1),1,1900,2,1900,2000)+ substr(emp_no, 1, 2)) 나이,
        D.dept_title 부서명, J.job_name 직급명
from employee E join department D
        on E.dept_code = D.dept_id 
        join job J
        using(job_code)
where extract(year from sysdate) - (decode(substr(emp_no,8,1),1,1900,2,1900,2000) + substr(emp_no, 1, 2))
        = (select min(extract(year from sysdate) - (decode(substr(emp_no,8,1),1,1900,2,1900,2000) + substr(emp_no, 1, 2)))
                from employee);
                

--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select E.emp_id 사번 ,E.emp_name 사원명, D.dept_title 부서명
from employee E join department D
    on E.dept_code = D.dept_id
where emp_name like '%형%';

--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
select E.emp_name 사원명, J.job_name 직급명, E.dept_code 부서코드, D.dept_title 부서명
from employee E join department D
        on E.dept_code = D.dept_id
        join job J
        using(job_code)
where dept_title like '해외%';

--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

select E.emp_name 사원명, E.bonus 보너스포인트, D.dept_title 부서명, N.national_name 근무지역명
from employee E join department D
        on E.dept_code = D.dept_id
    join location L 
        on D.location_id = L.local_code
    join nation N
    using(national_code)
where E.bonus is not null;

--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select E.emp_name 사원명, J.job_name 직급명, D.dept_title 부서명, N.national_name 근무지역명
from employee E join job J 
        using(job_code)
    join department D
        on E.dept_code = D.dept_id
    join location L
        on D.location_id = L.local_code
    join nation N
        using(national_code)
where E.dept_code = 'D2';

--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
select E.emp_name 사원명, J.job_name 직급명, E.salary 급여 ,E.salary*12 연봉
from employee E join sal_grade SG
        using(sal_level)
    join job J
        using(job_code)
where E.salary > SG.max_sal;

--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.
select E.emp_name 사원명, D.dept_title 부서명, L.local_name 지역명, N.national_name 근무지역명
from employee E join department D
        on E.dept_code = D.dept_id
    join location L
        on D.location_id = L.local_code
    join nation N
        using(national_code)
where national_code in('KO','JP');

--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용
select A.emp_name 사원명, A.dept_code 부서코드, B.emp_name 동료이름
from employee A join employee B
     on a.dept_code = b.dept_code
where A.emp_name != B.emp_name;

--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select E.emp_name 사원명, J.job_name 직급명, E.salary 급여
from employee E join job J
    using(job_code)
where E.bonus is null and J.job_name in('차장','사원');

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.

--1
select count(decode(quit_yn,'N',1,null)) 재직, count(decode(quit_yn,'Y',1,null)) 퇴사
from employee;

--2
select decode(quit_yn, 'N', '재직', '퇴직') 상태, count(*) 인원수
from employee
group by decode(quit_yn, 'N', '재직', '퇴직');

