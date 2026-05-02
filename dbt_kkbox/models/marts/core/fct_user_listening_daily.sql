{{ config(materialized='table') }}

select
    msno,
    listen_date,
    num_25,
    num_50,
    num_75,
    num_985,
    num_100,
    total_plays,
    num_unique,
    total_seconds,
    completion_rate
from {{ ref('stg_user_logs') }}
