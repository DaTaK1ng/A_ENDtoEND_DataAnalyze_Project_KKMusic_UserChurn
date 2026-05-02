{{ config(materialized='view') }}

-- For each user, aggregate listening behaviour over rolling windows
-- ending at the engagement_window_end variable. Four window sizes:
-- 7, 15, 30, 60 days. The "engagement_drop" feature compares the
-- last 15-day window against the 15 days before that.

with logs as (
    select * from {{ ref('stg_user_logs') }}
    where listen_date <= date '{{ var("engagement_window_end") }}'
),

window_flags as (
    select
        msno,
        listen_date,
        total_seconds,
        total_plays,
        num_unique,
        completion_rate,
        case when listen_date >= date '{{ var("engagement_window_end") }}' - interval 7 day  then 1 else 0 end as in_w7,
        case when listen_date >= date '{{ var("engagement_window_end") }}' - interval 15 day then 1 else 0 end as in_w15,
        case when listen_date >= date '{{ var("engagement_window_end") }}' - interval 30 day then 1 else 0 end as in_w30,
        case when listen_date >= date '{{ var("engagement_window_end") }}' - interval 60 day then 1 else 0 end as in_w60,
        case
            when listen_date <  date '{{ var("engagement_window_end") }}' - interval 15 day
             and listen_date >= date '{{ var("engagement_window_end") }}' - interval 30 day
            then 1 else 0
        end as in_prev_w15
    from logs
),

aggregated as (
    select
        msno,
        sum(in_w7)                                                          as active_days_w7,
        sum(in_w15)                                                         as active_days_w15,
        sum(in_w30)                                                         as active_days_w30,
        sum(in_w60)                                                         as active_days_w60,

        sum(case when in_w7  = 1 then total_seconds else 0 end)             as listen_seconds_w7,
        sum(case when in_w15 = 1 then total_seconds else 0 end)             as listen_seconds_w15,
        sum(case when in_w30 = 1 then total_seconds else 0 end)             as listen_seconds_w30,
        sum(case when in_w60 = 1 then total_seconds else 0 end)             as listen_seconds_w60,

        sum(case when in_w7  = 1 then total_plays else 0 end)               as plays_w7,
        sum(case when in_w15 = 1 then total_plays else 0 end)               as plays_w15,
        sum(case when in_w30 = 1 then total_plays else 0 end)               as plays_w30,

        sum(case when in_w15 = 1 then num_unique else 0 end)                as unique_songs_w15,
        sum(case when in_w30 = 1 then num_unique else 0 end)                as unique_songs_w30,

        avg(case when in_w15 = 1 then completion_rate end)                  as avg_completion_rate_w15,
        avg(case when in_w30 = 1 then completion_rate end)                  as avg_completion_rate_w30,

        sum(case when in_w15      = 1 then total_seconds else 0 end)        as recent_w15_seconds,
        sum(case when in_prev_w15 = 1 then total_seconds else 0 end)        as prior_w15_seconds
    from window_flags
    group by msno
),

with_drop as (
    select
        *,
        case
            when prior_w15_seconds > 0
            then (recent_w15_seconds - prior_w15_seconds) / prior_w15_seconds
            else null
        end as engagement_drop_w15
    from aggregated
)

select * from with_drop
