{{
  config(
    materialized='table'
  )
}}

WITH fct_customers AS (
    SELECT * 
    FROM {{ ref('int_orders_users_promos_functions') }}
),

int_users_addresses AS (
    SELECT * 
    FROM {{ ref('int_users_addresses') }}
),

renamed_casted AS (
    SELECT distinct
        iu.user_id
        ,iu.name
        , iu.address
        , iu.phone_number
        , iu.email
        , iu.country
        , iu.state
        , iu.zipcode
        , c.orders_by_user
        , c.discount_customer_USD
        , c.first_ordered
        , c.last_ordered
        , total_user_cost_USD
        , c.average_user_cost_USD
        , user_created_at
        , user_updated_at
        , user_without_update

    FROM fct_customers c
    left join int_users_addresses iu on c.user_id = iu.user_id
    order by user_id
    )

SELECT * FROM renamed_casted