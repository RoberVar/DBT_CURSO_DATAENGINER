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
        , case
            when promo_id = 'task-force'
            then 'taskforce'
            when promo_id = 'instruction set'
            then 'instructionset'
            else promo_id
          end as description
        , discount
        , status
        , _fivetran_deleted
        , _fivetran_synced

    from source

)

select * from renamed

union all select
        md5('')
        ,'nopromo'
        ,0
        ,'inactive'
        ,'false'
        ,sysdate()