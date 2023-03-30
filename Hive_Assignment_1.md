**1) Create internal table**

CREATE TABLE SALES_ORDER_CSV
     (ORDERNUMBER int,
     QUANTITYORDERED INT,
     PRICEEACH DOUBLE,
     ORDERLINENUMBER INT,
     SALES DOUBLE,
     STATUS STRING,
     QTR_ID INT,
     MONTH_ID INT,
     YEAR_ID INT,
     PRODUCTLINE STRING,
     MSRP INT,
     PRODUCTCODE STRING,
     PHONE STRING,
     CITY STRING,
     STATE STRING,
     POSTALCODE STRING,
     COUNTRY STRING,
     TERRITORY STRING,
     CONTACTLASTNAME STRING,
     CONTACTFIRSTNAME STRING,
     DEALSIZE STRING)
     row format delimited
     fields terminated by ','
     stored as textfile
     tblproperties ("skip.header.line.count"="1");

2)
