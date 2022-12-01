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
        , month
        , quantity
        , product_id
        , _fivetran_synced
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted