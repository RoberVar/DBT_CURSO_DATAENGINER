  {% set query_sql %}
    SELECT DISTINCT {{column}} FROM {{table}}
    {% endset %}