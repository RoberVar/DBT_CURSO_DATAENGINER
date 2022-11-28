{{
  config(
     materialized='incremental',
     unique_key = 'user_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed as (

    select
        user_id,
        address_id,
        first_name,
        email,
        created_at,
        last_name,
        updated_at,
        phone_number,
        total_orders, 
        _fivetran_deleted,
        _fivetran_synced

    from source
    
)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}