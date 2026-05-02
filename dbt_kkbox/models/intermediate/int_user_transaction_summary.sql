{{ config(materialized='view') }}

with txns as (
    select * from {{ ref('stg_transactions') }}
    where transaction_date <= date '{{ var("observation_cutoff") }}'
),

ranked as (
    select
        *,
        row_number() over (partition by msno order by transaction_date desc) as rn_desc,
        row_number() over (partition by msno order by transaction_date asc)  as rn_asc
    from txns
),

latest as (
    select
        msno,
        transaction_date            as latest_transaction_date,
        membership_expire_date      as latest_expire_date,
        payment_method_id           as latest_payment_method_id,
        payment_plan_days           as latest_plan_days,
        plan_list_price             as latest_list_price,
        actual_amount_paid          as latest_amount_paid,
        is_auto_renew               as latest_is_auto_renew,
        is_cancel                   as latest_is_cancel,
        discount_rate               as latest_discount_rate,
        price_per_day               as latest_price_per_day
    from ranked
    where rn_desc = 1
),

aggregates as (
    select
        msno,
        count(*)                                              as transaction_count,
        sum(is_cancel)                                        as cancellation_count,
        sum(is_auto_renew)::double / nullif(count(*), 0)      as auto_renew_rate,
        avg(discount_rate)                                    as avg_discount_rate,
        avg(price_per_day)                                    as avg_price_per_day,
        avg(payment_plan_days)                                as avg_plan_days,
        sum(actual_amount_paid)                               as total_amount_paid
    from txns
    group by msno
)

select
    a.msno,
    a.transaction_count,
    a.cancellation_count,
    a.auto_renew_rate,
    a.avg_discount_rate,
    a.avg_price_per_day,
    a.avg_plan_days,
    a.total_amount_paid,
    l.latest_transaction_date,
    l.latest_expire_date,
    l.latest_payment_method_id,
    l.latest_plan_days,
    l.latest_list_price,
    l.latest_amount_paid,
    l.latest_is_auto_renew,
    l.latest_is_cancel,
    l.latest_discount_rate,
    l.latest_price_per_day,
    date_diff('day', l.latest_transaction_date, date '{{ var("observation_cutoff") }}') as days_since_last_transaction
from aggregates a
left join latest l using (msno)
