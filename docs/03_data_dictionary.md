# 03 Data Dictionary

Four analytical areas: profile, transactions, listening, labels.

## Members — `members_v3.csv`

Grain: one row per user.

| Field | Type | Description |
|---|---|---|
| `msno` | string | Anonymised user ID. Primary key. |
| `city` | int | City code. Categorical. |
| `bd` | int | Age field. Many erroneous values (0, negative, > 100); cleaned in staging. |
| `gender` | string | `male`, `female`, or empty; empty mapped to `unknown`. |
| `registered_via` | int | Registration channel code. |
| `registration_init_time` | int | Registration date encoded as `YYYYMMDD`; parsed to DATE in staging. |

Use: segmentation, tenure calculation, channel quality.

## Transactions — `transactions_v2.csv`

Grain: one row per transaction or subscription event.

| Field | Type | Description |
|---|---|---|
| `msno` | string | User ID. |
| `payment_method_id` | int | Payment method code. |
| `payment_plan_days` | int | Plan duration in days. |
| `plan_list_price` | int | List price (TWD). |
| `actual_amount_paid` | int | Actual amount paid (TWD). |
| `is_auto_renew` | int | Auto-renew flag (0/1). |
| `transaction_date` | int | `YYYYMMDD`; parsed to DATE in staging. |
| `membership_expire_date` | int | `YYYYMMDD`; parsed to DATE in staging. |
| `is_cancel` | int | Cancellation flag (0/1). |

Use: payment patterns, auto-renew analysis, discount dependency, revenue.

## User Logs — `user_logs_v2.csv`

Grain: one row per user per listening date.

| Field | Type | Description |
|---|---|---|
| `msno` | string | User ID. |
| `date` | int | `YYYYMMDD`; parsed to DATE in staging. |
| `num_25` | int | Plays completed up to 25%. |
| `num_50` | int | Plays completed 25–50%. |
| `num_75` | int | Plays completed 50–75%. |
| `num_985` | int | Plays completed 75–98.5%. |
| `num_100` | int | Plays completed fully. |
| `num_unq` | int | Unique songs played that day. |
| `total_secs` | float | Total listening seconds. |

Use: engagement, completion quality, behaviour change before churn.

## Labels — `train_v2.csv`

Grain: one row per labelled user.

| Field | Type | Description |
|---|---|---|
| `msno` | string | User ID. |
| `is_churn` | int | 1 = churned within 30 days post-expiry, 0 = retained. |

Use: model target and KPI denominator.

## Note on v1 vs v2

If you also download v1 files (`transactions.csv`, `user_logs.csv`, `train.csv`), the staging models union them automatically. Column names in `user_logs.csv` differ slightly (`num_unique`, `total_seconds`); staging normalises them to v2 names.
