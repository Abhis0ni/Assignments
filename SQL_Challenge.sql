1) Select * from CITY where COUNTRYCODE='USA' and POPULATION>100000;

2) Select NAME from CITY where COUNTRYCODE='USA' and POPULATION>120000;

3) Select * from CITY;

4) Select * from CITY where ID=1661;

5) Select * from CITY where COUNTRYCODE='JPN';

6) Select NAME from CITY where COUNTRYCODE='JPN';

7) Select CITY,STATE from STATION;

8) Select distinct CITY from STATION where ID%2=0;

9) Select (count(CITY) - count(distinct CITY)) as Diff from STATION;

10) Select CITY,length(CITY) as "City_length" from STATION order by length(CITY) asc,CITY asc limit 1 
    union all 
    Select CITY,length(CITY) as "City_length" from STATION order by length(CITY) desc,CITY asc limit 1;
    
11) Select distinct CITY from STATION where Left(CITY,1) in ('a','e','i','o','u');

12) Select distinct CITY from STATION where Right(CITY,1) in ('a','e','i','o','u');

13) Select distinct CITY from STATION where Left(CITY,1) not in ('a','e','i','o','u');

14) Select distinct CITY from STATION where Right(CITY,1) not in ('a','e','i','o','u');

15) Select distinct CITY from STATION where (Right(CITY,1) not in ('a','e','i','o','u')) or (Left(CITY,1) not in ('a','e','i','o','u'));

16) Select distinct CITY from STATION where (Right(CITY,1) not in ('a','e','i','o','u')) and (Left(CITY,1) not in ('a','e','i','o','u'));

17) Select P.product_id,P.product_name from Product P inner join Sales S 
    on P.product_id=S.product_id
    where S.sale_date between '20190101' and '20210331';
    
18) Select distinct auther_id as id from Views where auther_id=viewer_id order by auther_id;

19) Select (count(*)/(Select count(*) from Delivery)*100) as "Immediate_percentage" from Delivery where order_date=customer_pref_delivery_date;

20) Select ad_id, (case when Clicked+Viewed=0 then 0 else (Clicked/(Clicked+Viewed))*100) as CTR 
    (Select ad_id,(Select count(*) from Ads where action='Clicked' and ad_id=A.ad_id) as "Clicked",
    (Select count(*) from Ads where action='Viewed' and ad_id=A.ad_id) as "Viewed" from Ads A)
