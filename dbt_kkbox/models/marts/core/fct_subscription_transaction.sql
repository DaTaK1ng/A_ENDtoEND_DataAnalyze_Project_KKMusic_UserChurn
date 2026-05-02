{{ config(materialized='table') }}

select
    msno,
    transaction_date,
    membership_expire_date,
    payment_method_id,
    payment_plan_days,
    plan_list_price,
    actual_amount_paid,
    is_auto_renew,
    is_cancel,
    discount_rate,
    price_per_day
from {{ ref('stg_transactions') }}
