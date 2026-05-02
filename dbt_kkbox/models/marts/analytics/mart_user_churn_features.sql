{{ config(materialized='table') }}

-- The main modelling input. One row per labelled user.
-- Joins profile, transaction summary, engagement windows, and churn label.
-- Only includes users present in the churn label table to avoid cross-population leakage.

with labels as (
    select * from {{ ref('fct_churn_label') }}
),

user_profile as (
    select * from {{ ref('int_user_member_profile') }}
),

txn as (
    select * from {{ ref('int_user_transaction_summary') }}
),

engage as (
    select * from {{ ref('int_user_engagement_windows') }}
),

joined as (
    select
        l.msno,
        l.is_churn,

        -- profile
        u.city,
        u.age,
        u.age_band,
        u.gender,
        u.registered_via,
        u.registration_init_time,
        u.tenure_days,

        -- transactions
        t.transaction_count,
        t.cancellation_count,
        t.auto_renew_rate,
        t.avg_discount_rate,
        t.avg_price_per_day,
        t.avg_plan_days,
        t.total_amount_paid,
        t.latest_transaction_date,
        t.latest_expire_date,
        t.latest_payment_method_id,
        t.latest_plan_days,
        t.latest_list_price,
        t.latest_amount_paid,
        t.latest_is_auto_renew,
        t.latest_is_cancel,
        t.latest_discount_rate,
        t.latest_price_per_day,
        t.days_since_last_transaction,

        -- engagement
        coalesce(e.active_days_w7,  0) as active_days_w7,
        coalesce(e.active_days_w15, 0) as active_days_w15,
        coalesce(e.active_days_w30, 0) as active_days_w30,
        coalesce(e.active_days_w60, 0) as active_days_w60,
        coalesce(e.listen_seconds_w7,  0) as listen_seconds_w7,
        coalesce(e.listen_seconds_w15, 0) as listen_seconds_w15,
        coalesce(e.listen_seconds_w30, 0) as listen_seconds_w30,
        coalesce(e.listen_seconds_w60, 0) as listen_seconds_w60,
        coalesce(e.plays_w7,  0) as plays_w7,
        coalesce(e.plays_w15, 0) as plays_w15,
        coalesce(e.plays_w30, 0) as plays_w30,
        coalesce(e.unique_songs_w15, 0) as unique_songs_w15,
        coalesce(e.unique_songs_w30, 0) as unique_songs_w30,
        e.avg_completion_rate_w15,
        e.avg_completion_rate_w30,
        e.engagement_drop_w15,

        -- engineered convenience flag
        case when coalesce(e.active_days_w15, 0) = 0 then 1 else 0 end as is_inactive_w15
    from labels l
    left join user_profile u on l.msno = u.msno
    left join txn          t on l.msno = t.msno
    left join engage       e on l.msno = e.msno
)

select * from joined
