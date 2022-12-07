{{
  config(
    materialized='table'
  )
}}

{% set event_types = obtener_valores(ref('stg_sql_server_dbo_events'),'event_type') %}

WITH int_events_functions AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_events') }}
),

renamed_casted AS (
    SELECT 
        user_id
        ,{%- for event_type in event_types   %}
        coalesce(sum(case when event_type = '{{event_type}}' then 1 end), 0) as {{event_type}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
        , product_id
        , page_url
        , event_type
        , event_id
        , order_id
        , session_id
        , (year(created_at)*100+month(created_at)) as yearmonth
        , _fivetran_synced

    FROM int_events_functions e
    where e._fivetran_deleted = false
    group by user_id
        , product_id
        , page_url
        , event_type
        , event_id
        , order_id
        , session_id
        , yearmonth
        , _fivetran_synced
    )

SELECT * FROM renamed_casted