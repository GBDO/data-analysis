# 데이터 분석을 위한 SQL 레시피

## DBMS <공통>

    Select
        User_id
        , CASE
            WHEN register_device = 1 THEN ‘데스크톱’
            WHEN register_device = 2 THEN ‘스마트폰’
            WHEN register_device = 3 THEN ‘애플리케이션’
            ELSE ‘ ’
        END AS device_name
    FROM mst_users;

    SELECT
        Stamp
        , substring(referrer from ‘https?://([^/]*)’) AS referrer_host #(PostgreSQL의 경우)
        # , host(referrer) AS referrer_host (BigQuery)
    FROM access_log;

    SELECT
        Stamp
        , url
        , substring(url from ‘//[^/]+([^?#]+)’) AS path #(PostgreSQL의 경우)
        , substring(url from ‘id=([^&]*)’) AS id #(PostgreSQL의 경우)
        ## , regexp_extract(url, ‘//[^/]+([^?#]+)’) AS path #(BigQuery)
        ## , regexp_extract(url, ‘id=(^&)*)’) AS id #(BigQuery)
    FROM access_log;

    SELECT
        Stamp
        , url
        , split_part(substring(url from ‘//[^/]+([^?#]+)’), ’/’, 2) AS path1 # (PostgreSQL의 경우)
        , split_part(substring(url from ‘//[^/]+([^?#]+)’), ’/’, 3) AS path2 # (PostgreSQL의 경우)
        ## , split(regexp_extract(url, '//[^/]+([^?#]+'), '/')[SAFE_ORDINAL(2)] AS path1 # BigQuery
        ## , split(regexp_extract(url, '//[^/]+([^?#]+'), '/')[SAFE_ORDINAL(3)] AS path2 # BigQuery

    FROM access_log;

    SELECT
        CURRENT_DATE AS dt # 모든 DBMS
        ,CURRENT_TIMESTAMP AS Stamp # PostgreSQL(타임존 O), BigQuery(타임존 X)
        ## ,LOCALTIMSTAMP AS stamp # 타임존을 적용하지 않은 PostgreSQL
    ;   

    SELECT
    ## PostgreSQL, BigQuery 'CAST(value AS type)' 사용
    CAST('2016-01-30' AS date) AS dt
    , CAST('2016-01-30 12:00:00' AS timestamp) AS stamp
    ## BigQuery 'type(value)' 사용
    ## date('2016-01-30') AS dt
    ## , timestamp('2016-01-30 12:00:00') AS stamp
    ##  PostgreSQL, BigQuery 'type 'value'' 사용
    ## date '2016-01-30' AS dt
    ## , timestamp '2016-01-30 12:00:00' AS stamp
    ##  PostgreSQL 'value::type' 사용
    ## '2016-01-30'::date AS dt
    ## , '2016-01-30 12:00:00'::timestamp AS stamp 
;

    SELECT
    stamp
    ## PostgreSQL, BigQuery EXTRACT 함수 사용
    ,EXTRACT(YEAR FROM stamp) AS year
    ,EXTRACT(MONTH FROM stamp) AS month
    ,EXTRACT(DAY FROM stamp) AS day
    ,EXTRACT(HOUR FROM stamp) AS hour
    FROM
    (SELECT CAST('2016-01-30 12:00:00' AS timestamp) AS stamp) AS t;


    SELECT
        stamp
        ## PostgreSQL substring 함수 사용
        , substring(stamp, 1, 4) AS year
        , substring(stamp, 6, 2) AS month
        , substring(stamp, 9, 2) AS day
        , substring(stamp, 12, 2) AS hour
        , substring(stamp, 1, 7) AS year_month
        ## PostgreSQL, BigQuery substr 함수 사용
        , substr(stamp, 1, 4) AS year
        , substr(stamp, 6, 2) AS month
        , substr(stamp, 9, 2) AS day
        , substr(stamp, 12, 2) AS hour
        , substr(stamp, 1, 7) AS year_month
    FROM
        ## PostgreSQL 문자열 자료형으로 text 사용
        (SELECT CAST('2016-01-30 12:00:00' AS text) AS stamp) AS t
        ## BigQuery 문자열 자료형으로 string 사용
        (SELECT CAST('2016-01-30 12:00:00' AS string) AS stamp) AS t
    ;
