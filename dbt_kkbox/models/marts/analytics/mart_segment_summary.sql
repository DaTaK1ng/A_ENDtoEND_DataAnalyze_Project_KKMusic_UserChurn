{{ config(materialized='table') }}

-- Pre-aggregated KPIs by segment for Tableau dashboards.
-- Segments: city tier × age band × auto-renew status.
-- Suppresses segments with n < 30 to avoid noisy CIs.

with feats as (
    select * from {{ ref('mart_user_churn_features') }}
),

with_segments as (
    select
        case
            when city in (1, 5, 6, 13, 22) then 'tier_1'
            when city in (4, 11, 14, 15, 18) then 'tier_2'
            else 'tier_3'
        end                                          as city_tier,
        age_band,
        case when latest_is_auto_renew = 1 then 'auto_renew_on' else 'auto_renew_off' end as auto_renew_status,
        is_churn,
        coalesce(latest_amount_paid, 0)              as expected_revenue,
        listen_seconds_w30
    from feats
),

aggregated as (
    select
        city_tier,
        age_band,
        auto_renew_status,
        count(*)                                     as user_count,
        sum(is_churn)                                as churned_count,
        avg(is_churn)::double                        as churn_rate,
        sqrt(avg(is_churn) * (1 - avg(is_churn)) / nullif(count(*), 0)) as churn_rate_se,
        avg(expected_revenue)                        as avg_expected_revenue,
        sum(expected_revenue * is_churn)             as revenue_at_risk,
        avg(listen_seconds_w30)                      as avg_listen_seconds_w30
    from with_segments
    group by 1, 2, 3
),

with_ci as (
    select
        *,
        greatest(churn_rate - 1.96 * churn_rate_se, 0.0) as churn_rate_ci_low,
        least   (churn_rate + 1.96 * churn_rate_se, 1.0) as churn_rate_ci_high
    from aggregated
    where user_count >= 30
)

select * from with_ci
