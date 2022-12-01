{{
  config(
    materialized='table'
  )
}}

WITH fct_marketing AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

int_users_addresses AS (
    SELECT * 
    FROM {{ ref('int_users_addresses') }}
),

int_orders_total AS (
    SELECT * 
    FROM {{ ref('int_orders') }}
),

renamed_casted AS (
    SELECT
        u.user_id
        ,u.name
        , i.address
        , order_cost_USD
        , shipping_cost_USD
        , i.orders_by_user
        , i.total_user_cost_USD
        , i.first_ordered
        , i.last_ordered
        , (shipping_cost_USD + order_cost_USD) as order_total_USD
        , u.created_at as user_created_at
        , m.created_at as order_created_at

    FROM fct_marketing m
    left join int_users_addresses u on m.user_id = u.user_id
    left join int_orders i on m.user_id = i.user_id
    )

SELECT * FROM renamed_casted