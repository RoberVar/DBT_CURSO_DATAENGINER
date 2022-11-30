{{
  config(
     materialized='view',
     unique_key = 'user_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed as (

    select
        user_id
        ,address_id
        ,first_name
        ,email
        ,created_at
        ,last_name
        ,updated_at
        ,phone_number
        ,datediff(day,created_at,updated_at) as without_update
        ,_fivetran_deleted
        ,_fivetran_synced

    from source
    
)

select * from renamed