WITH dim_date AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo_date') }}
    ),

renamed_casted AS (
    select
        fecha_forecast
        , id_date
        , anio
        , mes
        , desc_mes
        , id_anio_mes
        , dia_previo
        , anio_semana_dia
        , semana
    FROM dim_date
    )

SELECT * FROM renamed_casted