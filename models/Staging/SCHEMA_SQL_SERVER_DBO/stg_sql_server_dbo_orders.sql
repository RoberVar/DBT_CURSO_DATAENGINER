{{
  config(
     materialized='incremental',
     unique_key = 'order_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        delivered_at,
        order_cost,
        shipping_service,
        promo_id,
        estimated_delivery_at,
        tracking_id,
        shipping_cost,
        address_id,
        status,
        created_at,
        order_total,
        user_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %} 