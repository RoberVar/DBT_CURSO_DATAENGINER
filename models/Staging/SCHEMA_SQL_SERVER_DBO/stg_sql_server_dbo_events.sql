{{
  config(
     materialized='view',
     unique_key = 'event_id'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
         trim(event_id) as event_id
        , page_url
        , event_type
        , trim(user_id) as user_id
        , trim(product_id) as product_id
        , trim(session_id) as session_id
        , created_at
        , trim(order_id) as order_id
        , _fivetran_deleted
        , _fivetran_synced
    FROM src_events
    )

SELECT * FROM renamed_casted