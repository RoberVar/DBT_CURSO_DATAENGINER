{{
  config(
    materialized='table'
  )
}}

WITH src_budget_products AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id
        , quantity
        , month as date
        , _fivetran_synced AS date_load
    FROM src_budget_products
    )

SELECT * FROM renamed_casted