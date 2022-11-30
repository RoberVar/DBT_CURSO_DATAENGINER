{{
  config(
    materialized='table'
  )
}}

WITH fct_orders_by_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

stg_users AS (
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
        , o.address_id
        , order_cost_USD
        , shipping_cost_USD
        , i.orders_by_user
        , i.total_user_cost_USD
        , i.first_ordered
        , i.last_ordered
        , (shipping_cost_USD + order_cost_USD) as order_total_USD
        , u.created_at as user_created_at
        , o.created_at as order_created_at

    FROM fct_orders_by_users o
    left join int_users_addresses u on o.user_id = u.user_id
    left join int_orders i on o.user_id = i.user_id
    group by u.user_id, u.first_name, u.last_name, o.address_id, order_cost_USD, shipping_cost_USD, order_total_USD, user_created_at, order_created_at
    )

SELECT * FROM renamed_casted