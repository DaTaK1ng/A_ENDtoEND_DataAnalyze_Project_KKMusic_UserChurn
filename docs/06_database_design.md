# 06 Database Design

## Goal

A dbt warehouse on DuckDB that mirrors enterprise dimensional modelling. Same SQL is portable to Snowflake or BigQuery via adapter swap.

## dbt Project Structure

```text
dbt_kkbox/
├── dbt_project.yml
├── profiles.yml
├── models/
│   ├── staging/
│   │   ├── _stg__sources.yml
│   │   ├── _stg__models.yml
│   │   ├── stg_members.sql
│   │   ├── stg_transactions.sql
│   │   ├── stg_user_logs.sql
│   │   └── stg_churn_labels.sql
│   ├── intermediate/
│   │   ├── int_user_member_profile.sql
│   │   ├── int_user_transaction_summary.sql
│   │   └── int_user_engagement_windows.sql
│   └── marts/
│       ├── core/
│       │   ├── dim_user.sql
│       │   ├── fct_subscription_transaction.sql
│       │   ├── fct_user_listening_daily.sql
│       │   └── fct_churn_label.sql
│       └── analytics/
│           ├── mart_user_churn_features.sql
│           ├── mart_user_risk_scores.sql
│           ├── mart_segment_summary.sql
│           ├── mart_dashboard_monthly.sql
│           ├── mart_statistical_tests.sql
│           └── mart_model_performance.sql
├── macros/
├── seeds/
└── tests/
```

## Layer Roles

### Staging — minimal cleaning

- Lowercase snake_case column names.
- Type casting and date parsing.
- Union v1 + v2 files where applicable.
- One model per source table.

### Intermediate — reusable transformations

- User-level profile cleaning.
- Transaction summary per user.
- Engagement aggregation across rolling windows.
- Not exposed to Tableau directly.

### Marts — business-ready

#### Core (dimensional model)

- `dim_user` — one row per user; profile dimensions.
- `fct_subscription_transaction` — one row per transaction event.
- `fct_user_listening_daily` — one row per user per day.
- `fct_churn_label` — one row per labelled user.

#### Analytics (pre-aggregated outputs)

| Mart | Grain | Use |
|---|---|---|
| `mart_user_churn_features` | one row per user | Modelling input. |
| `mart_user_risk_scores` | one row per scored user | Model output: probability, risk band, action. |
| `mart_segment_summary` | one row per segment × risk band | Tableau churn / retention by segment. |
| `mart_dashboard_monthly` | one row per month × KPI | Executive trend dashboard. |
| `mart_statistical_tests` | one row per hypothesis test | Test name, groups, CI, p-value, effect size. |
| `mart_model_performance` | one row per model | AUC, log loss, recall, lift, calibration. |

## dbt Tests

| Test type | Examples |
|---|---|
| Schema tests | `unique`, `not_null`, `accepted_values`, `relationships` |
| Generic tests | unique key on each grain; auto-renew flag in {0, 1} |
| Custom tests | no transaction date after `membership_expire_date`; engagement window end ≤ expiry; segment minimum sample size for CI |

## Tableau Strategy

Tableau connects only to mart layer Parquet exports. Raw 410M-row logs are never queried by the BI tool.

## Cloud Demo

Final analytics marts (`mart_segment_summary`, `mart_dashboard_monthly`, `mart_user_risk_scores`) are exported to BigQuery Sandbox. One Tableau dashboard reads from BigQuery via live connection to demonstrate cloud fluency.

## Lineage and Docs

`dbt docs generate && dbt docs serve` produces an interactive lineage graph and column-level documentation. Screenshots are committed to `tableau/screenshots/`.
