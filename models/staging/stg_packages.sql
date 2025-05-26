{{ config(
    materialized='table',
    schema='staging',
    alias='stg_packages'
) }}

with source as (
    select * from {{ source('raw', 'packages') }}
),

cleaned as (
    select
        package_id,
        customer_id,
        initcap(origin_hub) as origin_hub,
        initcap(destination_city) as destination_city,
        weight,
        case
            when weight < 1.0 then 'Light'
            when weight < 3.0 then 'Medium'
            else 'Heavy'
        end as weight_category
    from source
)

select * from cleaned
