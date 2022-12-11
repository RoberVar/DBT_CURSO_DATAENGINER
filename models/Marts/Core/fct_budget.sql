{{
  config(
    materialized='incremental'
  )
}}

WITH fct_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheets_budget') }}
    ),

renamed_casted as (

    select
          budget_id
        , budget_yearmonth
        , quantity
        , product_id
        , _fivetran_synced
        , _fivetran_deleted

    from fct_budget
)

select * from renamed_casted

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}