{{ config(materialized='view') }}

with v2 as (
    select * from read_csv_auto('{{ var("raw_data_path") }}/train_v2.csv', header=true)
),

cleaned as (
    select
        msno,
        cast(is_churn as integer) as is_churn
    from v2
)

select * from cleaned
