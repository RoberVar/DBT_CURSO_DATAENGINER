{{
  config(
     materialized='view',
     unique_key = 'promo_id'
  )
}}

with source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        md5(promo_id) as promo_id
        ,trim(promo_id) as description
        ,discount
        ,status
        ,_fivetran_deleted
        ,_fivetran_synced

    from source

)

select * from renamed

union all select
        md5('')
        ,'no_promo'
        ,0
        ,'inactive'
        ,'false'
        ,sysdate()