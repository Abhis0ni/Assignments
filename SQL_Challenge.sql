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
    
11) 
