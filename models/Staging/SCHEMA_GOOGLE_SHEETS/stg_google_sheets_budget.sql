{{ config(
    materialized='view',
    unique_key = '_row'
    ) 
    }}


WITH stg_budget_products AS (
    SELECT * 
    FROM {{ source('google_sheets','budget') }}
    ),

renamed_casted AS (
    SELECT
          md5(_row) as budget_id
        , year(month)*100+month(month) as budget_yearmonth
        , quantity
        , product_id
        , _fivetran_synced
        , false as _fivetran_deleted
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted