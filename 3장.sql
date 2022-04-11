#출처 : 데이터 분석을 위한 SQL 레시피

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
        ## ,LOCALTIMSTAMP AS stamp # 타임존을 적용하지 않은 PostgreSQL;   

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
    ## , '2016-01-30 12:00:00'::timestamp AS stamp ;

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
        (SELECT CAST('2016-01-30 12:00:00' AS string) AS stamp) AS t;


    SELECT
        abs(x1 - x2) AS abs
        , sqrt(power(x1-x2, 2)) AS rms
    FROM loaction_1d;

# 7-9 카테고리별 순위 최상위 상품을 추출하는 쿼리
    SELECT DISTINCT
        category,
        FIRST_VALUE(product_id)
            OVER(PARTITION BY category ORDER BY score DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
        AS product_id
    FROM popular_products;

# 7-10 행으로 저장된 지표 값을 열로 변환하는 쿼리
    SELECT
        dt,
        MAX(CASE WHEN indicator = 'impressions' THEN val END) AS impressions,
        MAX(CASE WHEN indicator = 'sessions' THEN val END) AS sessions,
        MAX(CASE WHEN indicator = 'users' THEN val END) AS users
    FROM daily_kpi
    GROUP BY dt
    ORDER BY dt;

# 7-15 PostgreSQL에서 쉼표로 구분된 데이터를 행으로 전개하는 쿼리
    SELECT
        purchase_id,
        regexp_split_to_table(product_ids,',') AS product_id
    FROM purchase_log;

# 7-16 일련 번호를 가진 피벗 테이블을 만드는 쿼리
    SELECT *
    FROM (
        SELECT 1 AS idx
        UNION ALL SELECT 2 AS idx
        UNION ALL SELECT 3 AS idx
    ) AS pivot;

# 7-17 split_part 함수의 사용 예
    SELECT
        split_part('A001,A002,A003',',',1) AS part_1,
        split_part('A001,A002,A003',',',2) AS part_2,
        split_part('A001,A002,A003',',',3) AS part_3;

# 7-18 문자 수의 차이를 사용해 상품 수를 계산하는 쿼리
    SELECT
        purchase_id,
        product_ids,
        1 + char_length(product_ids)
          - char_length(replace(product_ids, ',',''))
        AS product_num
    FROM
       purchase_log;

# 7-19 피벗 테이블을 사용해 문자열을 행으로 전개하는 쿼리
    SELECT
        l.product_id,
        l.product_ids,
        p.idx,
        split_part(l.product_ids, ',',p.idx) AS product_id
    FROM
        purchase_log AS loaction_1d
       JOIN
         (SELECT 1 AS idx
         UNION ALL SELECT 2 AS idx
         UNION ALL SELECT 3 AS idx
         ) AS p
         ON p.idx <=
            (1 + char_length(l.product_ids)
               - char_length(replace(l.product_ids,',','')));

# 8-4 상관 서브쿼리로 여러 개의 테이블을 가로로 정렬하는 쿼리
    SELECT
        m.categorty_id,
        m.name,
        (SELECT s.sales
        FROM category_sales AS s
        WHERE m.category_id = s.category_id
        ) AS sales,
        (SELECT r.product_id
        FROM product_sale_ranking AS r
        WHERE m.category_id = r.category_id
        ORDER BY sales DESC
        LIMIT 1
        ) AS top_sale_product
    FROM
        mst_categories AS m;