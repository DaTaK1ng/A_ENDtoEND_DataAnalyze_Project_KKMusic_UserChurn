{{ config(materialized='view') }}

with v2 as (
    select * from read_csv_auto('{{ var("raw_data_path") }}/user_logs_v2.csv', header=true)
),

cleaned as (
    select
        msno,
        strptime(cast(date as varchar), '%Y%m%d')::date as listen_date,
        cast(num_25 as integer) as num_25,
        cast(num_50 as integer) as num_50,
        cast(num_75 as integer) as num_75,
        cast(num_985 as integer) as num_985,
        cast(num_100 as integer) as num_100,
        cast(num_unq as integer) as num_unique,
        cast(total_secs as double) as total_seconds,
        (cast(num_25 as integer) + cast(num_50 as integer)
            + cast(num_75 as integer) + cast(num_985 as integer)
            + cast(num_100 as integer)) as total_plays,
        case
            when (cast(num_25 as integer) + cast(num_50 as integer)
                + cast(num_75 as integer) + cast(num_985 as integer)
                + cast(num_100 as integer)) > 0
            then cast(num_100 as double) / (cast(num_25 as integer) + cast(num_50 as integer)
                + cast(num_75 as integer) + cast(num_985 as integer)
                + cast(num_100 as integer))
            else null
        end as completion_rate
    from v2
)

select * from cleaned
