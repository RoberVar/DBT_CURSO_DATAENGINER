{{
  config(
    materialized='incremental'
  )
}}

WITH fct_weborders AS (
    SELECT * 
    FROM {{ ref('int_order_items_products_functions') }}
),

int_events_functions AS (
    SELECT *
    FROM {{ ref('int_events_functions') }}
),

renamed_casted AS (
    SELECT 
        user_id
        , e.product_id
        , page_url
        , event_type
        , event_id
        , e.order_id
        , session_id
        , e.yearmonth as event_yearmonth
        , oip.name
        , oip.price_USD
        , oip.inventory
        , sold_quantity
        , earn_by_product_USD
        , e._fivetran_synced as event_ft_synced

    from int_events_functions e
    left join int_order_items_products_functions oip
    on e.product_id = oip.product_id
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where event_ft_synced > (select max(event_ft_synced) from {{ this }})

{% endif %}