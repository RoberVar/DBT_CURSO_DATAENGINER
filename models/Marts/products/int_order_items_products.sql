{{
  config(
    materialized='incremental'
  )
}}

WITH int_order_items_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
),

stg_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
),

renamed_casted AS (
    SELECT distinct
        l.order_id
        , p.product_id
        , p.name
        , p.inventory
        , p.price_USD
        , l.quantity
        , p._fivetran_synced as products_ft_synced
        , l._fivetran_synced as order_items_ft_synced

    FROM int_order_items_products l
    left join stg_products p
    on p.product_id = l.product_id
    where p._fivetran_deleted = false
    and l._fivetran_deleted = false
    order by p.name
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where p._fivetran_synced > (select max(_fivetran_synced) from {{ this }}
  or l._fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}