{{
  config(
     materialized='view',
     unique_key = 'order_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        trim(order_id) as order_id
        , delivered_at
        , order_cost as order_cost_USD
        , shipping_service 
        , md5(promo_id) as promo_id
        , estimated_delivery_at
        , trim(tracking_id) as tracking_id
        , shipping_cost as shipping_cost_USD
        , trim(address_id) as address_id
        , status
        , created_at
        , order_total as total_cost_USD
        , datediff(day,created_at,delivered_at) as delivered_days
        , trim(user_id) as user_id
        , case
            when _fivetran_deleted is null
            then false
            else _fivetran_deleted
          end as _fivetran_deleted
        , _fivetran_synced

    from source
    order by user_id
)

select * from renamed