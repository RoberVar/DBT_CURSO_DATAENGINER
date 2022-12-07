WITH dim_addresses AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_addresses') }}
    ),

renamed_casted AS (
    select
        address_id
        ,country
        ,state
        ,zipcode
        ,address
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM stg_sql_server_dbo_addresses
    )

SELECT * FROM renamed_casted