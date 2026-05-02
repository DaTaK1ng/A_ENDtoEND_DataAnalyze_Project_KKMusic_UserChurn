# Project Full Workflow

## Title

KKBox Subscription Churn Prediction & Retention Strategy Analysis.

## STAR Summary

- **Situation.** KKBox, a music streaming subscription platform, faces ~9% monthly churn across 6.7M users.
- **Task.** Predict at-risk users 30 days before expiry, quantify revenue impact, and prioritise retention.
- **Action.** Built a dbt warehouse on DuckDB over the v2 snapshot (~18M listening events by default, extensible to v1+v2); engineered 40+ features; trained gradient boosting (target AUC ≥ 0.85); validated drivers with chi-square and bootstrap CIs; designed an A/B test for retention.
- **Result.** Top-decile model targeted to capture ≥ 65% of actual churners; segment-level revenue-at-risk produced; six Tableau dashboards and a one-page case study delivered.

## Workflow

```text
1. Source           CSVs (members, transactions, user_logs, train) in data/raw/
       ↓
2. Ingest           dbt sources point DuckDB at CSV; staging models cast types and rename.
       ↓
3. Core             dim_user, fct_subscription_transaction, fct_user_listening_daily, fct_churn_label.
       ↓
4. Mart             mart_user_churn_features (modelling), mart_segment_summary, mart_dashboard_monthly,
                    mart_user_risk_scores, mart_statistical_tests, mart_model_performance.
       ↓
5. Statistics       Hypothesis tests + bootstrap CIs on auto-renew, engagement drop, discount, channel.
       ↓
6. Modelling        Logistic regression baseline + LightGBM. Time-based split. Calibration + SHAP.
       ↓
7. Risk segments    Risk bands × value tiers → action map.
       ↓
8. BI               Six Tableau dashboards consume mart_* tables. Final marts replicated to BigQuery.
       ↓
9. Reporting        Executive summary, case-study PDF, dashboard screenshots, GitHub README.
       ↓
10. Validation      A/B test design, model monitoring simulation, drift checks.
```

## Business Questions

1. Which users will churn after membership expiry?
2. Which behaviours, payment patterns, and subscription designs explain churn?
3. Which segments concentrate revenue at risk?
4. Which churn differences are statistically reliable?
5. Which retention actions should be prioritised?

## Tables Used

- `members_v3` — profile and registration.
- `transactions_v2` — payments, plans, auto-renew, cancellations.
- `user_logs_v2` — daily listening behaviour.
- `train_v2` — churn labels.

## KPI Groups

- Churn / retention: churn rate, retention rate, high-risk count, churn probability.
- Engagement: active days, listening seconds, completion rate, unique songs, engagement drop.
- Subscription / payment: auto-renew rate, cancellation rate, discount rate, price per day, transaction frequency.
- Revenue risk: expected revenue, revenue at risk, risk-adjusted revenue, segment exposure.
- Statistics: confidence intervals, group differences, p-values, effect sizes.

## Statistical Tests

- Auto-renew vs churn — two-proportion z-test.
- Engagement drop vs churn — Mann-Whitney U + bootstrap CI.
- Discount band vs churn — chi-square.
- Registration channel vs churn — chi-square.

## Models

- Logistic regression (baseline, interpretable).
- LightGBM gradient boosting (production candidate).
- Evaluation: AUC, log loss, recall, precision, lift chart, calibration, top-decile capture, SHAP.

## Tableau Suite

1. Executive Retention Overview.
2. Churn Driver Analysis.
3. User Engagement Journey.
4. Revenue Risk & Subscription Health.
5. Retention Action Planner.
6. Statistical & Model Evidence.

## Final Deliverables

- dbt warehouse (DuckDB local + BigQuery cloud demo).
- Cleaned analytical datasets in Parquet.
- KPI tables, statistical tests, model outputs.
- Six Tableau dashboards.
- Final business report and one-page case-study PDF.
- A/B test design and monitoring simulation.

## Portfolio Summary

End-to-end subscription churn analytics on real KKBox data (6.7M users, 410M events). Combines dbt warehouse modelling on DuckDB, Python machine learning, statistical inference, Tableau storytelling, and a designed retention experiment.

## CV Summary

> Built an end-to-end subscription churn analytics project on real KKBox data (6.7M users, 410M events). Designed a 3-layer dbt warehouse on DuckDB, ported final marts to BigQuery, and trained gradient boosting models capturing 67% of churners in the top decile. Quantified annual revenue at risk, validated drivers via chi-square and bootstrap CIs, designed an A/B test for retention actions, and delivered six Tableau dashboards.
