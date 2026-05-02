{{ config(materialized='view') }}

with raw as (
    select * from read_csv_auto('{{ var("raw_data_path") }}/members_v3.csv', header=true)
),

cleaned as (
    select
        msno,
        cast(city as integer) as city,
        case
            when cast(bd as integer) between 10 and 80 then cast(bd as integer)
            else null
        end as age,
        case
            when lower(coalesce(gender, '')) in ('male', 'female') then lower(gender)
            else 'unknown'
        end as gender,
        cast(registered_via as integer) as registered_via,
        strptime(cast(registration_init_time as varchar), '%Y%m%d')::date as registration_init_time
    from raw
)

select * from cleaned
