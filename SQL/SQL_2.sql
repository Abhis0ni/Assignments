Q51. 
SELECT name, population, gdp  FROM world
WHERE
    area >= 3000000 or population >= 25000000
;

======================================================================================================================================================

Q52. 
SELECT name FROM customer
WHERE
    referee_id != 2 or referee_id IS NULL
;

======================================================================================================================================================

Q53. 
SELECT name FROM customers
WHERE
    id not IN (SELECT customerid FROM orders)
;

======================================================================================================================================================

Q54. 
SELECT employee_id, 
COUNT(employee_id) over(partition by team_id) as total_count
from employee ORDER BY employee_id
;

======================================================================================================================================================

Q55. 
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

Q56. 
select player_id, device_id as first_login_device FROM (SELECT player_id, device_id, event_date,
rank() over(partition by player_id ORDER BY event_date ASC) as first_login
FROM activity ORDER BY player_id) as tmp
WHERE
    first_login = 1
;

======================================================================================================================================================

Q57. 
SELECT customer_number FROM (SELECT customer_number, COUNT(customer_number) as total_count FROM orders
GROUP BY customer_number
ORDER BY total_count DESC LIMIT 1) as tmp
;

======================================================================================================================================================

Q58. 
with CTE as (SELECT *, 
lag(free) over(order by free) as new_val
FROM cinema)

SELECT seat_id FROM CTE
WHERE
    new_val = 1
GROUP BY seat_id
;

======================================================================================================================================================

Q59. 
SELECT sales_id FROM orders
WHERE
    com_id = 1;

SELECT name FROM salesperson
WHERE
    sales_id NOT IN 
    (
    SELECT sales_id FROM orders
    WHERE
        com_id = (
                SELECT com_id FROM company
                WHERE
                    name = "red"
                )
    )
;

======================================================================================================================================================

Q60. 
SELECT *,
CASE
    when (x + y) <= z or (y + z) <= x or (z + x) <= y then "NO"
    else "YES"
end as triangle_bool
FROM triangle
;

======================================================================================================================================================

Q61. 
SELECT MIN(new_val) from (SELECT 
IFNULL(ABS(lag(x) over(order by x ASC)), 0) as new_val
FROM point) as tmp
WHERE
    new_val != 0
;

======================================================================================================================================================

Q62. 
SELECT actor_id, director_id FROM actor_director
GROUP BY actor_id, director_id
HAVING
    count(CONCAT(actor_id,director_id)) >= 3 ;

======================================================================================================================================================

Q63. 
SELECT p.product_name, s.year, s.price  FROM sales as s
JOIN (select * FROM product) as p ON p.product_id = s.product_id
;

======================================================================================================================================================

Q64. 
SELECT p.project_id, round(avg(e.experience_years), 2) as average_exp 
FROM project as p
JOIN (SELECT * from employee) as e ON
e.employee_id = p.employee_id
GROUP BY project_id;

======================================================================================================================================================

Q65. 
with CTE as (SELECT seller_id, sum(price) as total_price FROM sales
GROUP BY seller_id)
SELECT seller_id FROM CTE
WHERE
    total_price >= (SELECT max(total_price) FROM CTE)
;

======================================================================================================================================================

Q66. 
SELECT buyer_id FROM sales 
WHERE
    buyer_id NOT IN 
    (SELECT buyer_id FROM sales
    WHERE
        product_id IN (SELECT product_id FROM product WHERE product_name != "S8")
    GROUP BY buyer_id
    )
;

======================================================================================================================================================

Q67. 
with CTE as 
(SELECT visited_on,
SUM(total_amount) over (rows BETWEEN 6 preceding and current row) as sum_amount,
AVG(total_amount) over (rows BETWEEN 6 preceding and current row) as average_amount
FROM 
    (
        SELECT visited_on, sum(amount) as total_amount FROM  customer
        GROUP BY visited_on
    ) as tmp
)
SELECT * FROM CTE ORDER BY visited_on ASC
;

======================================================================================================================================================

Q68. 
SELECT gender, day, 
sum(score_points) over (partition by gender ORDER BY day rows between unbounded preceding and current row) as total_score
FROM scores;

======================================================================================================================================================

Q72. 
SELECT trans_month, country, COUNT(trans_month), SUM(state="approved") as total_approved, 
SUM(state="decline") as total_decline, SUM(amount)
FROM 
(
    SELECT id, country, state, amount, 
    left(trans_date,7) as trans_month FROM transactions
) tmp
GROUP BY trans_month, country;

======================================================================================================================================================

Q73. 
with CTE as (SELECT post_id, action_date, SUM(extra="spam") as spam_count,
CASE
    when post_id IN (SELECT post_id FROM removals) then 1
    else 0
end as removed
FROM actions
GROUP BY action_date, post_id
HAVING
    sum(extra="spam") != 0)
SELECT round(sum(total_percent)/count(*), 0) as average_daily_percent 
FROM 
    (
        SELECT sum(removed)/sum(spam_count) * 100 as total_percent FROM CTE
        GROUP BY action_date
    ) tmp
;

======================================================================================================================================================

Q74. 
with CTE as (SELECT player_id, event_date,
datediff(event_date, lag(event_date) over (partition by player_id ORDER BY event_date ASC)) as lag_date
FROM activity)
SELECT round(count(distinct(player_id)) / (select count(DISTINCT(player_id)) FROM activity), 2) as fraction
from CTE
WHERE
    lag_date = 1
;

======================================================================================================================================================

Q75. 
with CTE as (SELECT player_id, event_date,
datediff(event_date, lag(event_date) over (partition by player_id ORDER BY event_date ASC)) as lag_date
FROM activity)
SELECT round(count(distinct(player_id)) / (select count(DISTINCT(player_id)) FROM activity), 2) as fraction
from CTE
WHERE
    lag_date = 1
;


======================================================================================================================================================

Q76.
with tax_table as (SELECT company_id,
case
    when max(salary) < 1000 then 0
    when max(salary) BETWEEN 1000 and 10000 then 24/100
    else 49/100
end as tax_percent
FROM salaries
GROUP BY company_id)

SELECT s.company_id, s.employee_id, s.employee_name, 
round((s.salary - (s.salary * tax_table.tax_percent )), 0) as calculated_salary
FROM salaries as s
JOIN tax_table ON tax_table.company_id = s.company_id
;

======================================================================================================================================================

Q77. 
SELECT sa.sale_date, (SUM(sa.sold_num) - so.total_oranges) as diff FROM sales as sa
JOIN (SELECT sale_date, SUM(sold_num) as total_oranges FROM sales
WHERE
    fruit = "oranges"
GROUP BY sale_date) as so
ON
    so.sale_date = sa.sale_date
WHERE
    sa.fruit = "apples"
GROUP BY sale_date;

======================================================================================================================================================

Q78. 
SELECT sa.sale_date, (SUM(sa.sold_num) - so.total_oranges) as diff FROM sales as sa
JOIN (SELECT sale_date, SUM(sold_num) as total_oranges FROM sales
WHERE
    fruit = "oranges"
GROUP BY sale_date) as so
ON
    so.sale_date = sa.sale_date
WHERE
    sa.fruit = "apples"
GROUP BY sale_date;

======================================================================================================================================================

Q79. 
with CTE as (SELECT * FROM expression)
SELECT *,
CASE
    when operator = "<" and (left_operand < right_operand) = 1 then "true"
    when operator = ">" and (left_operand > right_operand) = 1 then "true"
    when operator = "=" and (left_operand = right_operand) = 1 then "true"
    else "false"
end as new_val
FROM CTE;

======================================================================================================================================================

Q80. 
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

Q81 
SELECT name FROM students
WHERE
    marks > 75
ORDER BY RIGHT(name, 3), id
;

======================================================================================================================================================

Q82. 
SELECT name FROM employee
ORDER BY name ASC
;

======================================================================================================================================================

Q83. 
SELECT name FROM employee
WHERE
    salary > 2000 and months < 10
ORDER BY employee_id ASC
;

======================================================================================================================================================

Q84.
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

Q85. 
SELECT extract(year FROM transaction_date) as year_, product_id, 
spend as curr_year_spend, 
lag(spend) over() as prev_year_spend,
round((spend/lag(spend) over() * 100) - 100, 2) as yoy_rate
FROM transactions;

======================================================================================================================================================

Q87.
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
	
Q90. 
with CTE as (SELECT server_id, status_time,
lead(status_time) over(partition by server_id ORDER BY status_time ASC) as new_time
FROM server)
SELECT sum(DATEDIFF( new_time, status_time )) as total_uptime_days FROM CTE;

======================================================================================================================================================

Q91. 
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

Q93. 
SELECT gender, day, 
sum(score_points) over (partition by gender ORDER BY day rows between unbounded preceding and current row) as total_score
FROM scores;

======================================================================================================================================================

Q94. 
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

Q96. 
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

Q97.
SELECT first_log.*, IFNULL(round((game_table.game_play / first_log.installs),1),0) as retention
FROM 
(
    select first_login, COUNT(first_login) as installs from 
    (
        SELECT player_id, MIN(event_date) as first_login FROM activity
        GROUP BY player_id
    )
first_login_count
GROUP BY first_login) first_log
LEFT JOIN 
(
    SELECT player_id,
    lag(event_date) over(partition by player_id) as game_date,
    event_date - lag(event_date) over(partition by player_id) as game_play
    FROM activity
) as game_table
ON 
game_table.game_date = first_log.first_login and game_play = 1

;

======================================================================================================================================================

Q100. 
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