{{
  config(
     materialized='view',
     unique_key = 'product_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        trim(product_id) as product_id
        , inventory
        , price as price_USD
        , name
        , _fivetran_deleted
        , _fivetran_synced

    from source

)

select * from renamed