{{
  config(
    materialized='table'
  )
}}

--{% set descriptions = obtener_valores(ref('stg_sql_server_dbo_promos'),'description') %}

WITH int_orders_users_promos_functions AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
),

stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
),

stg_promos AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
),

renamed_casted AS (
    SELECT
        u.user_id
        , count(order_id) as orders_by_user
        , cast(sum(total_cost_USD) as number(8,2)) as total_user_cost_USD
        , max(o.created_at) as last_ordered
        , min(o.created_at) as first_ordered
        , sum(p.discount) as discount_customer_USD
        , cast(avg(total_cost_USD) as number(8,2)) as average_user_cost_USD
        
        /*,{%- for description in descriptions   %}
        coalesce(sum(case when description = '{{description}}' then 1 end), 0) as {{description}}
        {%- if not loop.last %},{% endif -%}
        {% endfor %}*/

    FROM int_orders_users_promos_functions o
    left join stg_users u
    on o.user_id = u.user_id
    left join stg_promos p
    on p.promo_id = o.promo_id
    where u._fivetran_deleted = false
    and o._fivetran_deleted = false
    group by u.user_id
    order by u.user_id
    )

SELECT * FROM renamed_casted