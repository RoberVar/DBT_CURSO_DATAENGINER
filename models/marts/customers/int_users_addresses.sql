{{
  config(
    materialized='incremental'
  )
}}

WITH int_users_addresses AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_addresses') }}
),

stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
),

renamed_casted AS (
    SELECT
          u.user_id
        , u.address_id
        , concat(u.first_name,' ',u.last_name) as name
        , a.address
        , u.phone_number
        , u.email
        , a.country
        , a.state
        , a.zipcode
        , u.created_at as user_created_at
        , u.updated_at as user_updated_at
        , u.without_update as user_without_update
        , u._fivetran_synced as user_ft_synced
        , a._fivetran_synced as address_ft_synced

    FROM int_users_addresses a
    left join stg_users u
    on a.address_id = u.address_id
    where user_id is not null
    and u._fivetran_deleted = false
    and a._fivetran_deleted = false
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where user_ft_synced > (select max(user_ft_synced) from {{ this }})
  or address_ft_synced > (select max(address_ft_synced) from {{ this }})

{% endif %}