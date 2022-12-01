WITH dim_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_users') }}
    ),

renamed_casted AS (
    SELECT
        user_id unique
        , first_name
        , last_name
        , email
        , phone_number
        , created_at
        , updated_at
        , address_id
        , date_load
    FROM stg_sql_server_dbo_users
    )

SELECT * FROM renamed_casted