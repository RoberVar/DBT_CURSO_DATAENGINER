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
        user_id
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
        , u.date_load as user_data_load
        , u.without_update as user_without_update
        , u._fivetran_deleted
        , u._fivetran_synced
        , a._fivetran_deleted
        , a._fivetran_synced

    FROM int_users_addresses u
    left join dim_addresses a on a.user_id = u.user_id
    group by u.user_id
    )

SELECT * FROM renamed_casted