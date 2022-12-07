WITH fct_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_orders') }}
    ),

renamed_casted as (

    select
        order_id
        , delivered_at
        , order_cost_USD
        , shipping_service 
        , promo_id
        , estimated_delivery_at
        , tracking_id
        , shipping_cost_USD
        , address_id
        , status
        , created_at
        , total_cost_USD
        , delivered_days
        , user_id
        , _fivetran_deleted
        , _fivetran_synced

    from fct_orders
)

select * from renamed_casted