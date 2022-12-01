{{
  config(
    materialized='table'
  )
}}

WITH int_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
),

renamed_casted AS (
    SELECT
        u.user_id
        , count(order_id) as orders_by_user
        , cast(sum(total_cost_USD) as number(8,2)) as total_user_cost_USD
        , max(o.created_at) as last_ordered
        , min(o.created_at) as first_ordered

    FROM int_orders o
    left join stg_sql_server_dbo_users u on o.user_id = u.user_id
    group by u.user_id
    )

SELECT * FROM renamed_casted