{{ config(materialized='table') }}

select
    msno,
    is_churn
from {{ ref('stg_churn_labels') }}
