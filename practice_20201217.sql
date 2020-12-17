desc employee;

--1. EMPLOYEE 테이블에서 이름, 연봉(월급*12), 
--총수령액(보너스포함연봉), 실수령액(총 수령액-(월급*세금 3%))가 
--출력되도록 하시오
select emp_name, salary*12, salary +(salary * nvl(bonus,0)),
        salary +(salary * nvl(bonus,0)-(salary*0.03))
from employee;

--2. EMPLOYEE 테이블에서 이름, 입사일, 근무 일수(입사한지 몇일인가)를 
--출력해보시오.
select emp_name, hire_date, round(sysdate-hire_date)
from employee;

