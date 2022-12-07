{{
  config(
    materialized='view'
  )
}}

WITH int_order_items_products_functions AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
),

stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
),

stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),


renamed_casted AS (
    SELECT distinct
        p.product_id
        , p.name
        , p.price_USD
        , p.inventory
        , (year(o.created_at)*100+month(o.created_at)) as yearmonth
        , sum(oi.quantity) as sold_quantity
        , sum(oi.quantity * p.price_USD) as earn_by_product_USD

    FROM int_order_items_products_functions oi
    left join stg_products p
    on oi.product_id = p.product_id
    left join stg_orders o
    on oi.order_id = o.order_id
    where oi._fivetran_deleted = false
    and p._fivetran_deleted = false

    group by p.product_id, yearmonth, p.name, p.price_USD, p.inventory
    order by p.product_id
    )

SELECT * FROM renamed_casted