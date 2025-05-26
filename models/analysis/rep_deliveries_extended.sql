{{ config(
    materialized='table',
    schema='analysis',
    alias='deliveries_extended'
) }}

with deliveries as (
    select * from {{ ref('stg_deliveries') }}
),

packages as (
    select * from {{ ref('stg_packages') }}
),

drivers as (
    select
        driver_id,
        first_name,
        last_name,
        region,
        overworked
    from {{ ref('stg_drivers') }}
)

select
    d.delivery_id,
    d.status,
    d.on_time,
    d.delivery_time,

    p.package_id,
    p.weight,
    p.weight_category,
    p.origin_hub,
    p.destination_city,

    dr.region,
    dr.first_name,
    dr.last_name,
    dr.overworked

from deliveries d

left join packages p
    on d.package_id = p.package_id

left join drivers dr
    on d.driver_id = dr.driver_id
