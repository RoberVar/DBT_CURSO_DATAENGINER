{{
  config(
     materialized='incremental',
     unique_key = 'product_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        product_id,
        inventory,
        price,
        name,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed