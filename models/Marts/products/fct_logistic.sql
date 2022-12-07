{{
  config(
    materialized='incremental'
  )
}}

WITH fct_logistic AS (
    SELECT * 
    FROM {{ ref('int_order_items_products') }}
),

stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

renamed_casted AS (
    SELECT distinct
          o.order_id
        , tracking_id 
        , address_id
        , product_id
        , name
        , inventory
        , price_USD
        , status
        , shipping_service
        , created_at as order_created_at
        , estimated_delivery_at
        , delivered_at
        , delivered_days
        , o._fivetran_synced as orders_ft_synced
        , l.order_items_ft_synced
        , l.products_ft_synced

    FROM fct_logistic l
    left join stg_orders o
    on o.order_id = l.order_id
    where _fivetran_deleted = false
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where l.order_items_ft_synced > (select max(l.order_items_ft_synced) from {{ this }}
  or l.products_ft_synced > (select max(l.products_ft_synced) from {{ this }})

{% endif %}