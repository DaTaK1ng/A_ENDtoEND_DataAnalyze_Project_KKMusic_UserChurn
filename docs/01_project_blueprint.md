# 01 Project Blueprint

## Aim

Use real KKBox subscription data to identify churn risk early, explain its drivers, quantify revenue exposure, and recommend targeted retention actions.

## Dataset Positioning

Source: WSDM Cup 2018 KKBox Churn Prediction Challenge. Data comes from KKBox, a real music streaming subscription company.

This project reframes the dataset as a business analytics case for product, pricing, CRM, and revenue teams — not a pure modelling competition.

## Business Questions

1. Which users show early-warning signals of churn before membership expiry?
2. Is churn driven mainly by weak engagement, payment friction, discount dependency, or subscription design?
3. Which segments combine high churn probability with high revenue value?
4. Which churn drivers are statistically reliable?
5. How should retention actions be prioritised across product, pricing, and CRM?

## Analytical Scope

- **Profile.** city, age, gender, registration channel, tenure.
- **Transactions.** payment method, plan length, price, paid amount, auto-renew, cancellation.
- **Listening.** active days, play counts, completion behaviour, listening seconds.
- **Labels.** churn or retained after subscription expiry.

## Methodology

1. Ingest raw CSVs into DuckDB via dbt sources.
2. Build staging, intermediate, and mart layers using dbt models.
3. Engineer user-level features for modelling and segmentation.
4. Define KPIs across churn, retention, engagement, subscription, and revenue.
5. Run hypothesis tests and confidence intervals on key drivers.
6. Train baseline logistic regression and LightGBM. Calibrate. Apply SHAP.
7. Score users; assign risk bands; map to retention actions.
8. Replicate final marts to BigQuery; build six Tableau dashboards.
9. Document A/B test design and model monitoring simulation.

## Where Enterprise-Style SQL Is Used

SQL is the engine of this project, executed via dbt-duckdb. Detailed schema is in [06 Database Design](06_database_design.md).

1. **Three-layer warehouse.** staging / intermediate / marts, mirroring real analytics platforms.
2. **dbt models.** Modular `.sql` files compiled into a DAG with auto-generated lineage and tests.
3. **Window functions.** `ROW_NUMBER` for latest transaction per user, `LAG` for behaviour deltas, `SUM OVER` for rolling engagement.
4. **Time-window aggregations.** 7 / 15 / 30 / 60-day engagement metrics via conditional aggregation.
5. **CTEs and refs.** Layered transformations using `WITH` and dbt `ref()` to keep models composable.
6. **KPI marts.** Churn rate, retention, auto-renew rate, revenue at risk computed in SQL.
7. **Dashboard marts.** Pre-aggregated tables so Tableau never queries raw 410M-row logs.
8. **Data quality tests.** dbt tests for unique keys, not-null, accepted ranges, leakage windows.

## Outputs

- dbt project with lineage and docs site.
- Cleaned datasets in Parquet.
- KPI framework and computed metrics.
- Statistical test outputs.
- Trained models with churn probabilities and risk bands.
- Segment summaries and revenue-at-risk estimates.
- Six Tableau dashboards.
- Final business report and one-page case-study PDF.

## Success Criteria

The project should demonstrate:

- business problem framing,
- dimensional data modelling with dbt,
- enterprise-style SQL,
- KPI design,
- statistical inference,
- predictive modelling and calibration,
- Tableau storytelling,
- experiment design and post-deployment thinking.

## Portfolio Summary

End-to-end subscription churn analytics on real KKBox data, combining dbt warehouse modelling, KPI design, hypothesis testing, predictive analytics, A/B test design, and Tableau storytelling.
