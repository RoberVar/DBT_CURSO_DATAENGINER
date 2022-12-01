WITH dim_order_items AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
    ),

renamed_casted AS (
    SELECT
        user_id unique
        , first_name
        , last_name
        , email
        , phone_number
        , created_at_utc
        , updated_at_utc
        , address_id
        , date_load
    FROM stg_sql_server_dbo_order_items
    )

SELECT * FROM renamed_casted