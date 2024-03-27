select distinct (d.department_name),
                emp_hire.first_name || ' ' || emp_hire.last_name,
                to_char(emp_hire.salary, '$99,999.00'),
                c.country_name || ', ' || l.city || ', ' ||
                l.street_address as DEPARTMENT_ADDRESS
  from departments d
  left join (select distinct (e.employee_id),
                             months_between(sysdate, e.hire_date) hire_time,
                             e.first_name,
                             e.last_name,
                             e.salary,
                             e.job_id
               from employees e) emp_hire
    on d.manager_id = emp_hire.employee_id
  left join locations l
    on l.location_id = d.location_id
  left join countries c
    on l.country_id = c.country_id
 where d.manager_id is null
    or emp_hire.hire_time >= 6
   and (select count(*)
          from employees e
          left join job_history h
            on h.employee_id = e.employee_id
         where e.department_id = d.department_id
           and (h.job_id in ('IT_PROG', 'SA_MAN') or
               e.job_id in ('IT_PROG', 'SA_MAN'))) = 0
