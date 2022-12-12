{{
  config(
    materialized='incremental'
  )
}}

WITH dim_order_items AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
    ),

renamed_casted AS (
    SELECT
        order_id
        ,product_id
        ,quantity
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM dim_order_items
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}