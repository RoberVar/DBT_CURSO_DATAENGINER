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
        order_id
        ,delivered_at
        ,order_cost as order_cost_USD
        ,case
            when shipping_service = 'usps' then 'ups'
            else shipping_service
            end as shipping_service      
        ,promo_id
        ,estimated_delivery_at
        ,tracking_id
        ,shipping_cost as shipping_cost_USD
        ,address_id
        ,status
        ,created_at
        ,order_total as total_cost_USD
        ,datediff(day,created_at,delivered_at) as delivering_time
        ,user_id
        ,_fivetran_deleted
        ,_fivetran_synced

    from source

)

select * from renamed