{{ config(materialized='table') }}

-- Monthly KPI rollup driven by transaction history. Used by the
-- Executive Retention Overview dashboard to plot trends over time.

with txns as (
    select * from {{ ref('fct_subscription_transaction') }}
),

monthly as (
    select
        date_trunc('month', transaction_date)             as month,
        count(distinct msno)                              as transacting_users,
        count(*)                                          as transaction_count,
        sum(actual_amount_paid)                           as total_revenue,
        avg(is_auto_renew)::double                        as auto_renew_rate,
        avg(is_cancel)::double                            as cancellation_rate,
        avg(discount_rate)                                as avg_discount_rate,
        avg(price_per_day)                                as avg_price_per_day,
        avg(payment_plan_days)                            as avg_plan_days
    from txns
    group by 1
)

select * from monthly order by month
