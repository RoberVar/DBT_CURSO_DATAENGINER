{{
  config(
    materialized='incremental'
  )
}}

WITH fct_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events') }}
    ),

renamed_casted as (

    select
          event_id
        , page_url
        , event_type
        , user_id
        , product_id
        , session_id
        , created_at
        , order_id
        , _fivetran_deleted
        , _fivetran_synced

    from fct_events
)

select * from renamed_casted

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}