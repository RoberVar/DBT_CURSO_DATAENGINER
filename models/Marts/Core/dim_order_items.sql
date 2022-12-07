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