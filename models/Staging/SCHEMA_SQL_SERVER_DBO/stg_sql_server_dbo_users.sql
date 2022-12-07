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
        trim(user_id) as user_id
        , trim(address_id) as address_id
        , first_name
        , last_name
        , email
        , phone_number
        , created_at::timestamp_ltz
        , updated_at::timestamp_ltz
        , datediff(day,created_at,updated_at) as without_update
        , _fivetran_deleted
        , _fivetran_synced

    from source
    
)

select * from renamed