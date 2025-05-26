{{ config(
    materialized='table',
    schema='staging',
    alias='stg_drivers'
) }}

with driver_data as (

    select
        d.driver_id,
        d.name,
        d.region,
        ds.shift_date,
        ds.hours_worked
    from {{ source('raw', 'drivers') }} d
    left join {{ source('raw', 'driver_shifts') }} ds
        on d.driver_id = ds.driver_id

),

cleaned as (
    select
        driver_id,
        split_part(name, ' ', 1) as first_name,
        split_part(name, ' ', array_size(split(name, ' '))) as last_name,
        region,
        shift_date,
        hours_worked,
        case
            when hours_worked > 8 then true
            else false
        end as overworked
    from driver_data
)

select * from cleaned
