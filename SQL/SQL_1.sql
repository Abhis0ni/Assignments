Q1. 
SELECT * FROM sample_dataset_1 
WHERE
    population > 100000 AND country_code = 'USA'
    ;

======================================================================================================================================================

Q2. 
SELECT name FROM sample_dataset_1 
WHERE
    population > 120000 AND country_code = 'USA'
    ;
======================================================================================================================================================

Q3. 
SELECT * FROM sample_dataset_1;

======================================================================================================================================================

Q4. 
SELECT * FROM sample_dataset_1
WHERE
    id = 1661
;

======================================================================================================================================================

Q5. 
SELECT * FROM sample_dataset_1 
WHERE
    country_code = 'JPN'
    ;

======================================================================================================================================================

Q6. 
SELECT name FROM sample_dataset_1 
WHERE
    country_code = 'JPN'
    ;

======================================================================================================================================================

Q7. 
SELECT city, state FROM sample_dataset_2;

======================================================================================================================================================

Q8. 
SELECT city FROM sample_dataset_2 
WHERE
    id % 2 = 0
GROUP BY city
    ;

======================================================================================================================================================

Q9. 
SELECT (COUNT(city) - COUNT(distinct(city))) as Difference
FROM sample_dataset_2;

======================================================================================================================================================

Q10. 
(SELECT city, LENGTH(city) as city_length from sample_dataset_2 
WHERE
    LENGTH(city) = (select min(LENGTH(city)) FROM sample_dataset_2)
    ORDER BY city LIMIT 1)
UNION ALL
(SELECT city, LENGTH(city) as city_length from sample_dataset_2 
WHERE
    LENGTH(city) = (select max(LENGTH(city)) FROM sample_dataset_2)
    ORDER BY city LIMIT 1)
;

======================================================================================================================================================

Q11. 
SELECT distinct(city) FROM sample_dataset_2
WHERE
    city LIKE ("a%")
    OR city like ("e%")
    OR city like ("i%")
    OR city like ("o%")
    OR city like ("u%")
;

======================================================================================================================================================

Q12. 
SELECT distinct(city) FROM sample_dataset_2
WHERE
    city LIKE ("%a")
    OR city like ("%e")
    OR city like ("%i")
    OR city like ("%o")
    OR city like ("%u")
;

======================================================================================================================================================

Q13. 
SELECT distinct(city) FROM sample_dataset_2
WHERE
    city Not LIKE ("a%")
    and city not like ("e%")
    and city not like ("i%")
    and city not like ("o%")
    and city not like ("u%")
;

======================================================================================================================================================

Q14. 
SELECT distinct(city) FROM sample_dataset_2
WHERE
    city Not LIKE ("%a")
    and city not like ("%e")
    and city not like ("%i")
    and city not like ("%o")
    and city not like ("%u")
;

======================================================================================================================================================

Q15. 
SELECT distinct(city) FROM sample_dataset_2
WHERE
    Left(city, 1) not in ("a", "i", "e", "o","u")
    OR
    right(city, 1) not in ("a", "i", "e", "o","u")
;

======================================================================================================================================================

Q16. 
SELECT distinct(city) FROM sample_dataset_2
WHERE
    Left(city, 1) not in ("a", "i", "e", "o","u")
    AND
    right(city, 1) not in ("a", "i", "e", "o","u")
;

======================================================================================================================================================

Q17 
SELECT * from product WHERE product_id in (SELECT product_id FROM sales 
WHERE
    sale_date >= '2019-01-01' and sale_date <= "2019-03-31")
    ;

======================================================================================================================================================

Q18.
SELECT author_id FROM views 
WHERE
    author_id = viewer_id
GROUP BY author_id
ORDER BY author_id;

======================================================================================================================================================

Q19. 
SELECT round(100 *
(SELECT COUNT(*) FROM delivery
    WHERE 
        order_date = customer_pref_delivery_date
) / COUNT(*), 2)

FROM delivery;

======================================================================================================================================================

Q20. 
SELECT ad_id, 
    round(
        (SUM(action='clicked')/ 
        (SUM(action='clicked') + SUM(action='viewed'))
        )*100, 2) as CTR 
FROM ads GROUP BY ad_id
ORDER BY CTR desc, ad_id ASC;

======================================================================================================================================================

Q21. 
SELECT employee_id, 
COUNT(employee_id) over(partition by team_id) as total_count
from employee ORDER BY employee_id
;

======================================================================================================================================================

Q22. 
SELECT ct.country_id, ct.country_name, wt.new_state
FROM
countries as ct
RIGHT JOIN (SELECT country_id, CASE
when AVG(weather_state) <= 15 then "cold"
when AVG(weather_state) >= 25 then "hot"
else "warm"
end as new_state
FROM weather
WHERE day >= "2019-11-01" and day <= "2019-11-30"
GROUP BY country_id) as wt ON ct.country_id=wt.country_id
ORDER BY wt.new_state
;

======================================================================================================================================================

Q23. 
with CTE as (SELECT  p.product_id, p.price, o.units FROM prices p  JOIN unit_sold o on o.product_id = p.product_id
WHERE
    o.purchase_date BETWEEN p.start_date AND p.end_date)
SELECT round(sum(price * units)/sum(units), 2) as average_selling_price FROM CTE
GROUP BY product_id
;

======================================================================================================================================================

Q24. 
select player_id, event_date as first_login_date FROM (SELECT player_id, event_date,
rank() over(partition by player_id ORDER BY event_date ASC) as first_login
FROM activity ORDER BY player_id) as tmp
WHERE
    first_login = 1
;

======================================================================================================================================================

Q25. 
select player_id, device_id as first_login_device FROM (SELECT player_id, device_id, event_date,
rank() over(partition by player_id ORDER BY event_date ASC) as first_login
FROM activity ORDER BY player_id) as tmp
WHERE
    first_login = 1
;

======================================================================================================================================================

Q26. 
SELECT p.product_name, o.total_units FROM products as p INNER JOIN (SELECT product_id, SUM(unit) as total_units FROM orders
WHERE
    order_date >= "2020-02-01" and order_date <= "2020-02-28"
GROUP BY product_id) as o on p.product_id = o.product_id
WHERE o.total_units >= 100
    ;

======================================================================================================================================================

Q27. 
SELECT user_id, name, mail FROM users
WHERE
    mail REGEXP "^[a-zA-Z]+[a-zA-Z0-9_.\-]*@leetcode.com$"
;

======================================================================================================================================================

Q28. 
with CTE as (SELECT new_o.customer_id, new_o.month, sum(p.price * new_o.quantity) as total_spent FROM products p
JOIN 
    (
        SELECT customer_id, product_id, quantity, 
        CASE
            when order_date >= "2020-06-01" and order_date <= "2020-06-30" then "june"
            when order_date >= "2020-07-01" and order_date <= "2020-07-31" then "july"
            else "ignore"
        end as month
        FROM orders 
        WHERE
            order_date >= "2020-06-01" and order_date <= "2020-07-30"
    ) as new_o on p.product_id = new_o.product_id
GROUP BY new_o.customer_id,  new_o.month
HAVING
    sum(p.price * new_o.quantity) >= 100)
SELECT customer_id, name FROM customers
WHERE
    customer_id = (SELECT customer_id FROM CTE
GROUP BY customer_id
HAVING count(customer_id) > 1)
;

======================================================================================================================================================

Q29. 
SELECT title FROM content
WHERE
    kids_content = "Y" and content_type = "Movies" and content_id in (SELECT content_id FROM tv_program
WHERE
    program_date >= "2020-06-01 00:00" and program_date <= "2020-06-30 12:00")
ORDER BY title
;

======================================================================================================================================================

Q30. 
SELECT q.id, q.year, IFNULL(npv_table.npv, 0) as npv_value FROM queries q
LEFT JOIN
(SELECT * FROM npv) as npv_table
ON
    npv_table.id = q.id and npv_table.year = q.year
;

======================================================================================================================================================

Q31. 
SELECT q.id, q.year, IFNULL(npv_table.npv, 0) as npv_value FROM queries q
LEFT JOIN
(SELECT * FROM npv) as npv_table
ON
    npv_table.id = q.id and npv_table.year = q.year
;

======================================================================================================================================================

Q32. 
SELECT IFNULL(e_uni.unique_id, NULL) as uniq_id, e.name FROM employee_uni as e_uni
RIGHT JOIN
    (
        SELECT * FROM employees
    ) as e
ON
    e.id = e_uni.id
    ;

======================================================================================================================================================

Q33. 
SELECT u.name, IFNULL(r.total_distance, 0) FROM users u
LEFT JOIN
(
    SELECT user_id, SUM(distance) as total_distance FROM rides
    GROUP BY user_id
) as r on r.user_id = u.id
ORDER BY total_distance DESC, u.name ASC
;

======================================================================================================================================================

Q34. 
SELECT p.product_name, o.total_units FROM products as p INNER JOIN (SELECT product_id, SUM(unit) as total_units FROM orders
WHERE
    order_date >= "2020-02-01" and order_date <= "2020-02-28"
GROUP BY product_id) as o on p.product_id = o.product_id
WHERE o.total_units >= 100
    ;

======================================================================================================================================================

Q35. 
(SELECT name FROM users
WHERE
    user_id IN
(SELECT user_id FROM movie_rating
GROUP BY user_id
HAVING
    count(user_id) = (SELECT MAX(mvr.total_count) FROM (SELECT user_id, count(user_id) as total_count FROM movie_rating
GROUP BY user_id) as mvr))
GROUP BY name
ORDER BY name ASC LIMIT 1)
UNION ALL
(SELECT title FROM movies
WHERE
    movie_id IN
(SELECT movie_id FROM movie_rating
GROUP BY movie_id
HAVING
    AVG(rating) = (SELECT MAX(mvr.total_rating) FROM (SELECT movie_id, AVG(rating) as total_rating FROM movie_rating
WHERE
    created_at >= "2020-02-01" and created_at <= "2020-02-28"
GROUP BY movie_id) as mvr))
GROUP BY title
ORDER BY title ASC LIMIT 1
)
;

======================================================================================================================================================

Q36. 
SELECT u.name, IFNULL(r.total_distance, 0) FROM users u
LEFT JOIN
(
    SELECT user_id, SUM(distance) as total_distance FROM rides
    GROUP BY user_id
) as r on r.user_id = u.id
ORDER BY total_distance DESC, u.name ASC
;

======================================================================================================================================================

Q37. 
SELECT IFNULL(e_uni.unique_id, NULL) as uniq_id, e.name FROM employee_uni as e_uni
RIGHT JOIN
    (
        SELECT * FROM employees
    ) as e
ON
    e.id = e_uni.id
    ;

======================================================================================================================================================

Q38. 
	SELECT id, name FROM (SELECT name, id, department_id FROM students
HAVING
    department_id not IN (SELECT id from departments)
) as tmp;

======================================================================================================================================================

Q39. 

WITH CTE as (
    (select from_id as person1, to_id as person2, duration
    from calls)
    UNION ALL
    (select to_id as person1, from_id as person2, duration
    from calls)
)

select person1, person2, count(*), sum(duration)
from CTE
where person1 < person2
GROUP BY person1, person2
;

======================================================================================================================================================

Q40. 
with CTE as (SELECT  p.product_id, p.price, o.units FROM prices p  JOIN unit_sold o on o.product_id = p.product_id
WHERE
    o.purchase_date BETWEEN p.start_date AND p.end_date)
SELECT round(sum(price * units)/sum(units), 2) as average_selling_price FROM CTE
GROUP BY product_id
;

======================================================================================================================================================

Q41. 
SELECT w.name, sum((w.units * p.total_volume)) as total_cubic_feet FROM warehouse w 
JOIN (SELECT product_id, (width * height * length) as total_volume FROM products) as p
ON
    p.product_id = w.product_id
GROUP BY w.name
;

======================================================================================================================================================

Q42.
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

Q43. 
with CTE as (SELECT player_id, event_date,
datediff(event_date, lag(event_date) over (partition by player_id ORDER BY event_date ASC)) as lag_date
FROM activity)
SELECT round(count(distinct(player_id)) / (select count(DISTINCT(player_id)) FROM activity), 2) as fraction
from CTE
WHERE
    lag_date = 1
;


======================================================================================================================================================


Q44. 
SELECT name FROM employee
WHERE
    id = (SELECT managerid FROM employee
GROUP BY managerid
HAVING
    COUNT(managerid) >= 5
    );

======================================================================================================================================================

Q45. 
SELECT dp.dept_name, IFNULL(s.total_students, 0) as total_students FROM department as dp 
LEFT JOIN 
(SELECT dept_id, count(dept_id) as total_students
FROM student
GROUP BY dept_id) as s 
ON
    dp.dept_id = s.dept_id
;

======================================================================================================================================================

Q46. 
with CTE as (SELECT customer_id, COUNT(customer_id) as total_count FROM customer
WHERE
    product_key IN (SELECT * from product)
GROUP BY customer_id)
SELECT customer_id from CTE
WHERE
    total_count = (SELECT max(total_count) FROM CTE)
GROUP BY customer_id
;

======================================================================================================================================================

Q49. 
SELECT mgt.student_id, e.course_id, e.grade FROM enrollments e
JOIN (SELECT student_id, max(grade) as max_grade FROM enrollments
GROUP BY student_id) as mgt
ON
    mgt.student_id = e.student_id and mgt.max_grade = e.grade
ORDER BY student_id;

======================================================================================================================================================