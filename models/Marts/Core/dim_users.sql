{{
  config(
    materialized='incremental'
  )
}}

WITH dim_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

renamed_casted AS (
    SELECT
        user_id
        , first_name
        , last_name
        , email
        , phone_number
        , created_at
        , updated_at
        , address_id
        , without_update
        , _fivetran_deleted
        , _fivetran_synced
    FROM dim_users
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}