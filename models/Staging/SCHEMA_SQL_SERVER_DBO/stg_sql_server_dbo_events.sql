{{
  config(
     materialized='incremental',
     unique_key = 'event_id'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
         event_id
        ,page_url
        ,event_type
        ,user_id
        ,product_id
        ,session_id
        ,created_at
        ,order_id
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_events
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}