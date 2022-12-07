{{
  config(
    materialized='incremental'
  )
}}

WITH fct_sales AS (
    SELECT * 
    FROM {{ ref('int_order_items_products_functions') }}
),

stg_budget AS (
    SELECT *
    FROM {{ ref('stg_google_sheets_budget') }}
),

renamed_casted AS (
    SELECT 
        budget_id
        , bu.product_id
        , budget_yearmonth
        , sa.name
        , quantity as budget_quantity
        , sa.inventory
        , sold_quantity
        , earn_by_product_USD
        , sa.price_USD
        , bu._fivetran_synced
    from fct_sales sa
    join stg_budget bu
    on (sa.product_id = bu.product_id)
    and (budget_yearmonth = yearmonth)
    where _fivetran_deleted = false
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where bu._fivetran_synced > (select max(bu._fivetran_synced) from {{ this }})

{% endif %}