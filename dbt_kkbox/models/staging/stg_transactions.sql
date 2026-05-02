{{ config(materialized='view') }}

with v2 as (
    select * from read_csv_auto('{{ var("raw_data_path") }}/transactions_v2.csv', header=true)
),

unioned as (
    select * from v2
    -- If you also downloaded transactions.csv (v1), the following block automatically appends it.
    -- DuckDB's read_csv_auto returns no rows if the file does not exist? No: it errors.
    -- We therefore guard with a TRY pattern: read v1 only when it is part of sources via dbt source().
    -- For safety, leave v2-only by default.
),

cleaned as (
    select
        msno,
        cast(payment_method_id as integer) as payment_method_id,
        cast(payment_plan_days as integer) as payment_plan_days,
        cast(plan_list_price as integer) as plan_list_price,
        cast(actual_amount_paid as integer) as actual_amount_paid,
        cast(is_auto_renew as integer) as is_auto_renew,
        strptime(cast(transaction_date as varchar), '%Y%m%d')::date as transaction_date,
        strptime(cast(membership_expire_date as varchar), '%Y%m%d')::date as membership_expire_date,
        cast(is_cancel as integer) as is_cancel,
        case
            when cast(plan_list_price as integer) > 0
            then 1.0 - (cast(actual_amount_paid as double) / cast(plan_list_price as double))
            else 0.0
        end as discount_rate,
        case
            when cast(payment_plan_days as integer) > 0
            then cast(actual_amount_paid as double) / cast(payment_plan_days as integer)
            else null
        end as price_per_day
    from unioned
)

select * from cleaned
