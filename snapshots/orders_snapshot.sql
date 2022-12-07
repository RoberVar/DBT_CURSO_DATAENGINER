{% snapshot orders_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='timestamp',
      updated_at='_fivetran_synced',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ source('sql_server_dbo', 'orders') }}

{% endsnapshot %}