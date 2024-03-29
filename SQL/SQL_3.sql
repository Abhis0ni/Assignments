Q101. 
select distinct username, activity, startDate, endDate
from
    (select user.*,
           rank() over (partition by username order by startDate desc) as rnk,
           count(activity) over (partition by username) as num
    from user_activity user) new_table
    WHERE
        (num != 1 and rnk = 2) or (num = 1 and rnk = 1)
;

======================================================================================================================================================

Q103. 
SELECT name FROM students
WHERE
    marks > 75
ORDER BY RIGHT(name, 3), id
;

======================================================================================================================================================

Q104. 
SELECT name FROM employee
ORDER BY name ASC
;

======================================================================================================================================================

Q105.
SELECT name FROM employee
WHERE
    salary > 2000 and months < 10
ORDER BY employee_id ASC
;

======================================================================================================================================================

Q106. 
SELECT *,
CASE
    when a = b and b = c then "equilateral"
    when a = b and b != c and a+b > c then "isoceles"
    when a + b < c or b + c < a or c + a < b then "not a triangle"
    when a != b and b != c and a != c then "scalene"
    else "normal triangle"
end as triangle_value
from triangle;

======================================================================================================================================================

Q107. 
SELECT 
    round(
        AVG(salary) - 
            (
                SELECT AVG(salary) FROM employees_incorrect
            ),
        0) 
    as diff_salaries
FROM employees_correct;

======================================================================================================================================================

Q108.
with CTE as 
(
    SELECT *, (salary * months) as total_earnings FROM employees
)
SELECT 
    concat(total_earnings, " ", count(total_earnings)) as output_table 
FROM CTE
WHERE
    total_earnings = (SELECT max(total_earnings) FROM CTE)
GROUP BY total_earnings
;

======================================================================================================================================================

Q109. 
(SELECT CONCAT(name,"(",left(occupation, 1),")") FROM job
ORDER BY name)
UNION ALL
(SELECT 
CONCAT("There are a total of ",COUNT(occupation), " ", occupation, "s") 
from job
GROUP BY occupation)
;

======================================================================================================================================================

Q 111. 
SELECT n,
CASE
    when n not in (SELECT distinct(p) FROM nodes WHERE p is not NULL) then "Leaf"
    when p is NULL then "Root"
    else "Inner"
end as type_of_node
FROM nodes ORDER BY n;

======================================================================================================================================================

Q117. 
SELECT name FROM students
WHERE
    marks > 75
ORDER BY RIGHT(name, 3), id
;

======================================================================================================================================================

Q118. 
SELECT name FROM employee
ORDER BY name ASC
;

======================================================================================================================================================

Q119. 
SELECT name FROM employee
WHERE
    salary > 2000 and months < 10
ORDER BY employee_id ASC
;

======================================================================================================================================================

Q120. 
SELECT *,
CASE
    when a = b and b = c then "equilateral"
    when a = b and b != c and a+b > c then "isoceles"
    when a + b < c or b + c < a or c + a < b then "not a triangle"
    when a != b and b != c and a != c then "scalene"
    else "normal triangle"
end as triangle_value
from triangle;

======================================================================================================================================================

Q121. 
SELECT extract(year FROM transaction_date) as year_, product_id, 
spend as curr_year_spend, 
lag(spend) over() as prev_year_spend,
round((spend/lag(spend) over() * 100) - 100, 2) as yoy_rate
FROM transactions;

======================================================================================================================================================

Q 123.
SELECT extract(month FROM event_date) as month, COUNT(user_id) as MAU FROM user_actions
WHERE
    event_date BETWEEN "2022-06-01 00:00:00" and "2022-06-30 12:00:00" AND event_type = "sign-in"
    and user_id in 
    (
        SELECT user_id FROM user_actions 
        WHERE event_date BETWEEN "2022-06-01 00:00:00" and "2022-06-30 12:00:00" AND event_type != "sign-in"
    )
GROUP BY month
;

======================================================================================================================================================

Q 126. 
with CTE as (SELECT server_id, status_time,
lead(status_time) over(partition by server_id ORDER BY status_time ASC) as new_time
FROM server)
SELECT sum(DATEDIFF( new_time, status_time )) as total_uptime_days FROM CTE;

======================================================================================================================================================

Q127. 
with CTE as (SELECT *,
timestampdiff(minute,transaction_timestamp,lag(transaction_timestamp) over()) 
as minutes_diff
FROM transactions)

SELECT count(minutes_diff) as payment_count FROM CTE
GROUP BY minutes_diff
HAVING
    abs(CTE.minutes_diff) <= 10
;

======================================================================================================================================================

Q129. 
SELECT gender, day, 
sum(score_points) over (partition by gender ORDER BY day rows between unbounded preceding and current row) as total_score
FROM scores;


======================================================================================================================================================

Q130.
with country_phone as (SELECT p.*, c.name as country_name FROM person p JOIN
(SELECT name, 
CASE
    WHEN LENGTH(country_code) < 3 then CONCAT("0", country_code)
    else country_code
end as new_code
FROM country) as c 
ON
    left(p.phone_number, 3) = c.new_code
)

SELECT country_name, sum(total_dur)/sum(total_count) as final FROM (SELECT cp.country_name, (2 * cal.duration) as total_dur,  (2 * count(cp.country_name)) as total_count FROM calls as cal
JOIN
    country_phone as cp
ON
    cal.caller_id = cp.id
GROUP BY cp.country_name, duration) as tmp
GROUP BY country_name ORDER BY final DESC LIMIT 1

======================================================================================================================================================

Q132. 
with CTE as 
(
    SELECT distinct(full_table.pay_date), round(AVG(full_table.amount), 0) as avg_pay, 
    full_table.department_id, avg_table.company_avg_pay 
    FROM 
    (
        SELECT s.*, e.department_id FROM salary s
        JOIN
            (SELECT * FROM employee) as e
        ON
            e.employee_id = s.employee_id
    ) full_table
    JOIN
        (SELECT pay_date, round(AVG(amount),0) as company_avg_pay FROM salary
        GROUP BY pay_date) as avg_table
    ON
        avg_table.pay_date = full_table.pay_date
    GROUP BY full_table.pay_date, full_table.department_id, 
    avg_table.company_avg_pay
)

SELECT pay_date, department_id,
CASE
    When avg_pay > company_avg_pay then "Higher"
    when avg_pay < company_avg_pay then "lower"
    when avg_pay = company_avg_pay then "same"
end as new_table_val
FROM CTE
GROUP BY pay_date, department_id, avg_pay
ORDER BY department_id, pay_date
;

======================================================================================================================================================

Q 133. 
SELECT extract(month FROM event_date) as month, COUNT(user_id) as MAU FROM user_actions
WHERE
    event_date BETWEEN "2022-06-01 00:00:00" and "2022-06-30 12:00:00" AND event_type = "sign-in"
    and user_id in 
    (
        SELECT user_id FROM user_actions 
        WHERE event_date BETWEEN "2022-06-01 00:00:00" and "2022-06-30 12:00:00" AND event_type != "sign-in"
    )
GROUP BY month
;

======================================================================================================================================================

Q137. 
select distinct username, activity, startDate, endDate
from
    (select user.*,
           rank() over (partition by username order by startDate desc) as rnk,
           count(activity) over (partition by username) as num
    from user_activity user) new_table
    WHERE
        (num != 1 and rnk = 2) or (num = 1 and rnk = 1)
;

======================================================================================================================================================

Q138. 
select distinct username, activity, startDate, endDate
from
    (select user.*,
           rank() over (partition by username order by startDate desc) as rnk,
           count(activity) over (partition by username) as num
    from user_activity user) new_table
    WHERE
        (num != 1 and rnk = 2) or (num = 1 and rnk = 1)
;

======================================================================================================================================================

Q139. 
SELECT name FROM students
WHERE
    marks > 75
ORDER BY RIGHT(name, 3), id
;

======================================================================================================================================================

Q140. 
SELECT name FROM employee
ORDER BY name ASC
;

======================================================================================================================================================

Q141.
SELECT name FROM employee
WHERE
    salary > 2000 and months < 10
ORDER BY employee_id ASC
;

======================================================================================================================================================

Q142. 
SELECT *,
CASE
    when a = b and b = c then "equilateral"
    when a = b and b != c and a+b > c then "isoceles"
    when a + b < c or b + c < a or c + a < b then "not a triangle"
    when a != b and b != c and a != c then "scalene"
    else "normal triangle"
end as triangle_value
from triangle;

======================================================================================================================================================

Q143. 
SELECT 
    round(
        AVG(salary) - 
            (
                SELECT AVG(salary) FROM employees_incorrect
            ),
        0) 
    as diff_salaries
FROM employees_correct;


======================================================================================================================================================

Q144.
with CTE as 
(
    SELECT *, (salary * months) as total_earnings FROM employees
)
SELECT 
    concat(total_earnings, " ", count(total_earnings)) as output_table 
FROM CTE
WHERE
    total_earnings = (SELECT max(total_earnings) FROM CTE)
GROUP BY total_earnings
;

======================================================================================================================================================

Q145. 
(SELECT CONCAT(name,"(",left(occupation, 1),")") FROM job
ORDER BY name)
UNION ALL
(SELECT 
CONCAT("There are a total of ",COUNT(occupation), " ", occupation, "s") 
from job
GROUP BY occupation)
;


======================================================================================================================================================

Q 147. 
SELECT n,
CASE
    when n not in (SELECT distinct(p) FROM nodes WHERE p is not NULL) then "Leaf"
    when p is NULL then "Root"
    else "Inner"
end as type_of_node
FROM nodes ORDER BY n;


======================================================================================================================================================

Q149. 
SELECT x, y FROM val
    WHERE
        x in (SELECT y FROM val)
        AND
        y in (SELECT x FROM val)
        AND
        x <= y
LIMIT 1, 3;

======================================================================================================================================================

Q153. 
with new_table as 
(
    SELECT *, 
    ifnull
    (
        datediff(transaction_date, 
                lag(transaction_date) over(partition by user_id)),
    1) as lag_date
    FROM amazon
)

SELECT user_id FROM new_table
GROUP BY user_id, lag_date
having
    count(user_id) >= 3 and new_table.lag_date = 1
ORDER BY user_id ASC
;

======================================================================================================================================================

Q154. 
SELECT COUNT(person) as unique_relationships from 
(
    SELECT person, COUNT(person) as person_count FROM 
    (
        (SELECT concat(payer_id, recipient_id) as person FROM payments WHERE payer_id < recipient_id)
        UNION ALL
        (SELECT concat(recipient_id, payer_id) as person FROM payments where recipient_id < payer_id )
    ) nt
    GROUP BY person
) pt
WHERE
    person_count >= 2
;

======================================================================================================================================================

Q155. 
SELECT extract(month FROM login_date) as current_month, COUNT(user_id) as reactivations FROM 
(
    SELECT user_id, login_date,
    datediff(login_date, lag(login_date) over(partition by user_id)) as lag_date
    FROM user_login
) as react_table
WHERE
    lag_date >= 31
GROUP BY current_month
;

======================================================================================================================================================

Q156.
SELECT user_id FROM 
(
    SELECT user_id, spend,
    lag(transaction_date) over(partition by user_id) as lag_num
    FROM transactions
) as nt
WHERE
    lag_num is NULL and spend >= 50;

======================================================================================================================================================

Q158. 
with new_table as 
(
    SELECT *, 
    ifnull
    (
        datediff(transaction_date, 
                lag(transaction_date) over(partition by user_id)),
    1) as lag_date
    FROM amazon
)

SELECT user_id FROM new_table
GROUP BY user_id, lag_date
having
    count(user_id) >= 3 and new_table.lag_date = 1
ORDER BY user_id ASC
;

======================================================================================================================================================

Q159. 
SELECT employee_id, salary, over_under FROM
(
    SELECT employee_id, salary, title,
    CASE
        when (AVG(salary) over(partition by title)/salary) > 2 then "Overpaid"
        when (AVG(salary) over(partition by title)/salary) < 0.5 then "Underpaid"
        else "Correct"
    end as over_under
    FROM accenture
) as nt
WHERE
    over_under != "Correct"
;

======================================================================================================================================================