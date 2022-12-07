WITH fct_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheets_budget') }}
    ),

renamed_casted as (

    select
          budget_id
        , month
        , quantity
        , product_id
        , _fivetran_synced

    from fct_budget
)

select * from renamed_casted