{{
  config(
    materialized='table'
  )
}}

WITH int_logistic AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

stg_sql_server_dbo_order_items AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
),

stg_sql_server_dbo_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
),

/*stg_sql_server_dbo_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheets_budget') }}
),*/

renamed_casted AS (
    SELECT
         trim(l.order_id) as order_id
        , l.delivered_at as order_delivered_at
        , l.shipping_service 
        , l.estimated_delivery_at
        , trim(l.tracking_id) as tracking_id
        , l.shipping_cost_USD
        , trim(l.address_id) as address_id
        , l.status
        , l.created_at as order_created_at
        , datediff(day,order_created_at,order_delivered_at) as delivered_days
        , l._fivetran_deleted
        , l._fivetran_synced
        , trim(p.product_id) as product_id
        , p.inventory
        , p.price_USD
        , p.name
        /*, trim(b.budget_id) as budget_id
        , b.month
        , b.quantity
        , b.product_id*/

    FROM int_logistic l
    left join stg_sql_server_dbo_order_items oi on oi.order_id = l.order_id
    left join stg_sql_server_dbo_products p on p.product_id = oi.product_id
    --left join stg_sql_server_dbo_budget b on b.product_id = p.product_id
    )

SELECT * FROM renamed_casted