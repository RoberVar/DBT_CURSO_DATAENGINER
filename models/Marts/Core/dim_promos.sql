WITH dim_promos AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_promos') }}
    ),

renamed_casted AS (
    select
        promo_id
        ,description
        ,discount
        ,status
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM dim_promos
    )

SELECT * FROM renamed_casted