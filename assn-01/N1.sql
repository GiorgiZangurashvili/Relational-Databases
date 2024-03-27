select e.first_name,
       e.last_name,
       nvl(decode(instr(e.email, '@'),
                  0,
                  e.email,
                  substr(e.email, 1, instr(e.email, '@'))),
           '-') email_until,
       to_char(e.hire_date, 'DD-MON-YYYY') Hire_Date,
       emp_c.e_count employee_count,
       emp_c.dist_job distinct_job_id,
       e.employee_id,
       emp_c.emp_avg_sal
  from employees e
  join (select m.manager_id,
               count(distinct m.employee_id) e_count,
               count(distinct m.job_id) dist_job,
               avg(m.salary) emp_avg_sal
          from employees m
         group by m.manager_id) emp_c
    on e.employee_id = emp_c.manager_id
  join (select e.department_id, avg(e.salary) avg_sal
          from employees e
         group by e.department_id) avg_dep_sal
    on e.department_id = avg_dep_sal.department_id
 where emp_c.e_count >= 3
   and e.salary > avg_dep_sal.avg_sal
 order by decode(e.employee_id, 120, 0, 108, 2, 1), 5 desc