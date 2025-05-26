{{ config(
    materialized='table',
    schema='analysis',
    alias='deliveries_rep'
) }}

with source as (
    select * from {{ source('raw', 'deliveries') }}
),

cleaned as (
    select
        delivery_id,
        package_id,
        driver_id,
        lower(status) as status,
        delivery_time,
        scheduled_time,
        case
            when lower(status) = 'delivered' and delivery_time <= scheduled_time then true
            else false
        end as on_time
    from source
)

select * from cleaned
