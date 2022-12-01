{{
  config(
    materialized='table'
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
        , u._fivetran_deleted as user_ft_deleted
        , u._fivetran_synced as user_ft_synced
        , a._fivetran_deleted as address_ft_deleted
        , a._fivetran_synced as address_ft_synced

    FROM int_users_addresses a
    left join stg_sql_server_dbo_users u
    on a.address_id = u.address_id
    where user_id is not null
    )

SELECT * FROM renamed_casted