{{ config(materialized='table') }}

select
    msno,
    city,
    age,
    age_band,
    gender,
    registered_via,
    registration_init_time,
    tenure_days
from {{ ref('int_user_member_profile') }}
