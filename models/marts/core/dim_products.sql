{{
  config(
    materialized='incremental'
  )
}}

WITH dim_products AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_products') }}
    ),

renamed_casted AS (
    select
        product_id
        , inventory
        , price_USD
        , name
        , _fivetran_deleted
        , _fivetran_synced
    FROM dim_products
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}