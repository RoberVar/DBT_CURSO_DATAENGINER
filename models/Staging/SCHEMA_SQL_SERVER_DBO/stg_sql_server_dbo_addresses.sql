{{
  config(
     materialized='view',
     unique_key = 'address_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'addresses') }}

),

renamed as (

    select
        trim(address_id) as address_id
        ,country
        ,state
        ,case
            when len(zipcode) = 4
            then concat('0',zipcode)
            else zipcode
        end as zipcode
        ,address
        ,_fivetran_deleted
        ,_fivetran_synced

    from source

)

select * from renamed