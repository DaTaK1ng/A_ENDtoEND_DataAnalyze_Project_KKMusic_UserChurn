{{ config(materialized='view') }}

with members as (
    select * from {{ ref('stg_members') }}
),

with_bands as (
    select
        msno,
        city,
        age,
        case
            when age is null then 'unknown'
            when age < 20 then '<20'
            when age < 30 then '20-29'
            when age < 40 then '30-39'
            when age < 50 then '40-49'
            when age < 60 then '50-59'
            else '60+'
        end as age_band,
        gender,
        registered_via,
        registration_init_time,
        date_diff('day', registration_init_time, date '{{ var("observation_cutoff") }}') as tenure_days
    from members
)

select * from with_bands
