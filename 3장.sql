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

