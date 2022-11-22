{{
  config(
     materialized='incremental',
     unique_key = 'address_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'addresses') }}

),

renamed as (

    select
        address_id,
        country,
        state,
        zipcode,
        address,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed