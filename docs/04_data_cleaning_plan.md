# 04 Data Cleaning Plan

## Principle

Raw files are immutable. All cleaning is expressed as dbt models (SQL) so transformations are reproducible, testable, and version-controlled.

## Pipeline (executed by `dbt build`)

```text
data/raw/*.csv  →  dbt sources  →  staging  →  intermediate  →  marts  →  data/processed/*.parquet
```

## Step 1 — Raw Data Audit

A standalone notebook (`notebooks/01_raw_data_audit.ipynb`) records:

- file existence and size,
- row counts,
- column types,
- missing values,
- duplicates,
- date ranges,
- label distribution,
- leakage risks (data dated after `membership_expire_date`).

## Step 2 — Staging Models

Location: `dbt_kkbox/models/staging/`.

| Model | Purpose |
|---|---|
| `stg_members` | Lowercase snake_case columns, parse `registration_init_time`, keep types stable. |
| `stg_transactions` | Union of `transactions.csv` and `transactions_v2.csv`; parse dates; cast booleans. |
| `stg_user_logs` | Union of v1 and v2; rename `num_unq`/`num_unique` and `total_secs`/`total_seconds` to canonical names. |
| `stg_churn_labels` | Union of `train.csv` and `train_v2.csv`. |

Tests at this layer: `unique` on grain keys, `not_null` on IDs and dates, `accepted_values` on flags.

## Step 3 — Intermediate Cleaning

Location: `dbt_kkbox/models/intermediate/`.

| Model | Logic |
|---|---|
| `int_user_member_profile` | Treat unrealistic `bd` (≤ 0 or > 100) as null; create age bands; map `gender` nulls to `unknown`. |
| `int_user_transaction_summary` | Sort by user / date; deduplicate; compute discount rate, price per day, days since last transaction; flag latest plan, latest auto-renew. |
| `int_user_engagement_windows` | Aggregate `stg_user_logs` to user level over 7 / 15 / 30 / 60-day windows ending at the user's expiry-date snapshot; compute active days, listening seconds, completion rate, unique songs, engagement drop. |

## Step 4 — Mart Layer

Location: `dbt_kkbox/models/marts/`.

`mart_user_churn_features` joins profile, transaction summary, engagement windows, and churn label into a single user-level row used for modelling.

Other marts feed Tableau and statistical analysis (see [06 Database Design](06_database_design.md)).

## Step 5 — Outputs

dbt-duckdb writes all tables (staging views, intermediate views, core tables, marts) to a single DuckDB database file:

```text
data/processed/kkbox.duckdb
```

After modelling notebooks finish, Tableau-ready CSVs are exported via `scripts/export_marts_to_csv.py` to:

```text
data/processed/tableau/
├── tableau_user_summary.csv
├── tableau_segment_summary.csv
├── tableau_dashboard_monthly.csv
├── tableau_user_risk_scores.csv
├── tableau_statistical_tests.csv
├── tableau_model_performance.csv
└── tableau_model_monitoring.csv
```

## Key Risks

- Do not include any data dated after the user's `membership_expire_date` in features. Enforced by a dbt test.
- Do not load 410M-row raw logs into Tableau. Tableau only reads marts.
- Verify segment sample size before reporting confidence intervals; suppress segments with n < 30.
