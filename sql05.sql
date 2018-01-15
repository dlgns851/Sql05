--문제1.
--가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서
--이름(department_name)은?
select first_name,last_name,salary,department_name
from employees em,departments de
where em.DEPARTMENT_ID=de.DEPARTMENT_ID
      and em.hire_date=(select max(hire_date)
                    from employees);
--문제2.
--평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name),
--성(last_name)과 업무(job_title), 연봉(salary)을 조회하시오.
select employee_id,first_name,last_name,job_title,salary
from employees em , jobs jo
where department_id=(select department_id
                    from employees
                    group by department_id
                    having avg(salary)= ( select max(sb.av)
                                          from(select department_id,avg(salary) av
                                               from employees
                                               group by department_id)sb ))
       and    em.job_id=jo.job_id;





--문제3.
--평균 급여(salary)가 가장 높은 부서는?
                   select distinct de.department_name 
                   from employees em , departments de
                   where em.department_id=(select department_id
                                           from employees
                                           group by department_id
                                           having avg(salary)= ( select max(sb.av)
                                                                from(select department_id,avg(salary) av
                                                                    from employees
                                                                    group by department_id)sb ))
                    and    em.department_id=de.department_id;
--문제4.
--평균 급여(salary)가 가장 높은 지역은?
--(1)부서별 평균연봉을 구한다
--(2)departments 와 조인한다 
--(3)로케이션으로 그룹으로 묶어준뒤 평균 연봉을 구하고 그중 최고값을 구한뒤 그때의 로케이션 아이디를 가진 지역값을 반환한다

select location_id,avg(su) su
from departments de,   (select department_id,avg(salary) su
                        from employees
                         group by department_id) sb 

where de.department_id=sb.department_id
group by location_id;  --로케이션별 평균 연봉 
--------------------------------------------


SELECT city 
FROM locations
where location_id=(

        select location_id
        from departments de,   (select department_id,avg(salary) su
                        from employees
                         group by department_id) sb 

         where de.department_id=sb.department_id 
        group by location_id
        having avg(su)=(select max(sb.su)
                        from (select location_id,avg(su) su
                             from departments de,   (select department_id,avg(salary) su
                                                    from employees
                                                     group by department_id) sb 

                              where de.department_id=sb.department_id
                             group by location_id) sb ));


--문제5.
--평균 급여(salary)가 가장 높은 업무는?
--(1) 임플로이 테이블에서 잡아이디로 그룹화한뒤 평균급여 가장 높은 잡아이디 구함 
--(2) jobs 테이블에서 (1)에서나온 잡아이디에 속하는 잡타이틀 출력
select job_title
from jobs
where job_id=(
select job_id
      from employees
    group by job_id
    having avg(salary)=(
select max(sb.av)
from (select job_id,avg(salary) av
      from employees
    group by job_id) sb));