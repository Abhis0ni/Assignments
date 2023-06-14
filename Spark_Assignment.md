a. Read the data, show it and Count the number of records.
>>> dfCase = spark.read.option("header",True).option("inferSchema",True).csv("/user/input/Case.csv")
>>> dfRegion = spark.read.option("header",True).option("inferSchema",True).csv("/user/input/Region.csv")
>>> dfTimeProvince = spark.read.option("header",True).option("inferSchema",True).csv("/user/input/TimeProvince.csv")

>>> dfCase.show()
+--------+--------+---------------+-----+--------------------+---------+---------+----------+
| case_id|province|           city|group|      infection_case|confirmed| latitude| longitude|
+--------+--------+---------------+-----+--------------------+---------+---------+----------+
| 1000001|   Seoul|     Yongsan-gu| true|       Itaewon Clubs|      139|37.538621|126.992652|
| 1000002|   Seoul|      Gwanak-gu| true|             Richway|      119| 37.48208|126.901384|
| 1000003|   Seoul|        Guro-gu| true| Guro-gu Call Center|       95|37.508163|126.884387|
| 1000004|   Seoul|   Yangcheon-gu| true|Yangcheon Table T...|       43|37.546061|126.874209|
| 1000005|   Seoul|      Dobong-gu| true|     Day Care Center|       43|37.679422|127.044374|
| 1000006|   Seoul|        Guro-gu| true|Manmin Central Ch...|       41|37.481059|126.894343|
| 1000007|   Seoul|from other city| true|SMR Newly Planted...|       36|        -|         -|
| 1000008|   Seoul|  Dongdaemun-gu| true|       Dongan Church|       17|37.592888|127.056766|
| 1000009|   Seoul|from other city| true|Coupang Logistics...|       25|        -|         -|
| 1000010|   Seoul|      Gwanak-gu| true|     Wangsung Church|       30|37.481735|126.930121|
| 1000011|   Seoul|   Eunpyeong-gu| true|Eunpyeong St. Mar...|       14| 37.63369|  126.9165|
| 1000012|   Seoul|   Seongdong-gu| true|    Seongdong-gu APT|       13| 37.55713|  127.0403|
| 1000013|   Seoul|      Jongno-gu| true|Jongno Community ...|       10| 37.57681|   127.006|
| 1000014|   Seoul|     Gangnam-gu| true|Samsung Medical C...|        7| 37.48825| 127.08559|
| 1000015|   Seoul|        Jung-gu| true|Jung-gu Fashion C...|        7|37.562405|126.984377|
| 1000016|   Seoul|   Seodaemun-gu| true|  Yeonana News Class|        5|37.558147|126.943799|
| 1000017|   Seoul|      Jongno-gu| true|Korea Campus Crus...|        7|37.594782|126.968022|
| 1000018|   Seoul|     Gangnam-gu| true|Gangnam Yeoksam-d...|        6|        -|         -|
| 1000019|   Seoul|from other city| true|Daejeon door-to-d...|        1|        -|         -|
| 1000020|   Seoul|   Geumcheon-gu| true|Geumcheon-gu rice...|        6|        -|         -|
+--------+--------+---------------+-----+--------------------+---------+---------+----------+
only showing top 20 rows

>>> dfRegion.show()
+-----+--------+-------------+---------+----------+-----------------------+------------------+----------------+-------------+------------------------+-------------------+------------------+
| code|province|         city| latitude| longitude|elementary_school_count|kindergarten_count|university_count|academy_ratio|elderly_population_ratio|elderly_alone_ratio|nursing_home_count|
+-----+--------+-------------+---------+----------+-----------------------+------------------+----------------+-------------+------------------------+-------------------+------------------+
|10000|   Seoul|        Seoul|37.566953|126.977977|                    607|               830|              48|         1.44|                   15.38|                5.8|             22739|
|10010|   Seoul|   Gangnam-gu|37.518421|127.047222|                     33|                38|               0|         4.18|                   13.17|                4.3|              3088|
|10020|   Seoul|  Gangdong-gu|37.530492|127.123837|                     27|                32|               0|         1.54|                   14.55|                5.4|              1023|
|10030|   Seoul|   Gangbuk-gu|37.639938|127.025508|                     14|                21|               0|         0.67|                   19.49|                8.5|               628|
|10040|   Seoul|   Gangseo-gu|37.551166|126.849506|                     36|                56|               1|         1.17|                   14.39|                5.7|              1080|
|10050|   Seoul|    Gwanak-gu| 37.47829|126.951502|                     22|                33|               1|         0.89|                   15.12|                4.9|               909|
|10060|   Seoul|  Gwangjin-gu|37.538712|127.082366|                     22|                33|               3|         1.16|                   13.75|                4.8|               723|
|10070|   Seoul|      Guro-gu|37.495632| 126.88765|                     26|                34|               3|          1.0|                   16.21|                5.7|               741|
|10080|   Seoul| Geumcheon-gu|37.456852|126.895229|                     18|                19|               0|         0.96|                   16.15|                6.7|               475|
|10090|   Seoul|     Nowon-gu|37.654259|127.056294|                     42|                66|               6|         1.39|                    15.4|                7.4|               952|
|10100|   Seoul|    Dobong-gu|37.668952|127.047082|                     23|                26|               1|         0.95|                   17.89|                7.2|               485|
|10110|   Seoul|Dongdaemun-gu|37.574552|127.039721|                     21|                31|               4|         1.06|                   17.26|                6.7|               832|
|10120|   Seoul|   Dongjak-gu|37.510571|126.963604|                     21|                34|               3|         1.17|                   15.85|                5.2|               762|
|10130|   Seoul|      Mapo-gu|37.566283|126.901644|                     22|                24|               2|         1.83|                   14.05|                4.9|               929|
|10140|   Seoul| Seodaemun-gu|37.579428|126.936771|                     19|                25|               6|         1.12|                   16.77|                6.2|               587|
|10150|   Seoul|    Seocho-gu|37.483804|127.032693|                     24|                27|               1|          2.6|                   13.39|                3.8|              1465|
|10160|   Seoul| Seongdong-gu|37.563277|127.036647|                     21|                30|               2|         0.97|                   14.76|                5.3|               593|
|10170|   Seoul|  Seongbuk-gu|37.589562|  127.0167|                     29|                49|               6|         1.02|                   16.15|                6.0|               729|
|10180|   Seoul|    Songpa-gu| 37.51462|127.106141|                     40|                51|               1|         1.65|                    13.1|                4.1|              1527|
|10190|   Seoul| Yangcheon-gu|37.517189|126.866618|                     30|                43|               0|         2.26|                   13.55|                5.5|               816|
+-----+--------+-------------+---------+----------+-----------------------+------------------+----------------+-------------+------------------------+-------------------+------------------+
only showing top 20 rows

>>> dfTimeProvince.show()
+----------+----+-----------------+---------+--------+--------+
|      date|time|         province|confirmed|released|deceased|
+----------+----+-----------------+---------+--------+--------+
|2020-01-20|  16|            Seoul|        0|       0|       0|
|2020-01-20|  16|            Busan|        0|       0|       0|
|2020-01-20|  16|            Daegu|        0|       0|       0|
|2020-01-20|  16|          Incheon|        1|       0|       0|
|2020-01-20|  16|          Gwangju|        0|       0|       0|
|2020-01-20|  16|          Daejeon|        0|       0|       0|
|2020-01-20|  16|            Ulsan|        0|       0|       0|
|2020-01-20|  16|           Sejong|        0|       0|       0|
|2020-01-20|  16|      Gyeonggi-do|        0|       0|       0|
|2020-01-20|  16|       Gangwon-do|        0|       0|       0|
|2020-01-20|  16|Chungcheongbuk-do|        0|       0|       0|
|2020-01-20|  16|Chungcheongnam-do|        0|       0|       0|
|2020-01-20|  16|     Jeollabuk-do|        0|       0|       0|
|2020-01-20|  16|     Jeollanam-do|        0|       0|       0|
|2020-01-20|  16| Gyeongsangbuk-do|        0|       0|       0|
|2020-01-20|  16| Gyeongsangnam-do|        0|       0|       0|
|2020-01-20|  16|          Jeju-do|        0|       0|       0|
|2020-01-21|  16|            Seoul|        0|       0|       0|
|2020-01-21|  16|            Busan|        0|       0|       0|
|2020-01-21|  16|            Daegu|        0|       0|       0|
+----------+----+-----------------+---------+--------+--------+
only showing top 20 rows

>>> dfCase.count()
174
>>> dfRegion.count()
244
>>> dfTimeProvince.count()
2771
