# 09 Business Question, KPI & Statistics Summary

A short consolidation. Detailed definitions live in [05 Metrics and Features](05_metrics_and_features.md).

## Business Problem

> Can profile, payment, subscription, and listening behaviour data predict churn and guide targeted retention?

## Solution Logic

```text
Business problem
  → multi-table integration (dbt warehouse on DuckDB)
  → KPI framework
  → statistical testing
  → predictive modelling
  → risk segmentation
  → revenue-at-risk analysis
  → retention action plan
  → A/B test design
  → Tableau dashboards
```

## Headline KPIs

- **Business.** churn rate, retention rate, high-risk users, auto-renew rate, revenue at risk.
- **Engagement.** active days, listening seconds, completion rate, unique songs, engagement drop.
- **Subscription.** cancellation rate, discount rate, price per day, transaction frequency, subscription gap count.
- **Statistical.** churn rate CI, group difference, p-value, effect size.

## Statistical Plan

| Hypothesis | Test |
|---|---|
| Auto-renew vs churn | Two-proportion z-test. |
| Engagement drop vs churn | Mann-Whitney U + bootstrap CI. |
| Discount band vs churn | Chi-square. |
| Registration channel vs churn | Chi-square. |

Visualisations: confidence intervals, error bars, p-value cards, box plots, segment comparisons.

## Modelling Plan

| Model | Role |
|---|---|
| Logistic regression | Baseline; interpretable coefficients. |
| LightGBM | Production candidate; calibrated; interpreted via SHAP. |

Evaluation: AUC, log loss, recall, lift chart, calibration curve, top-decile capture.

## Final Summary

End-to-end subscription churn analytics on real KKBox data. Combines dbt warehouse modelling, KPI design, hypothesis testing, predictive analytics, A/B test design, and Tableau storytelling.

## CV Summary

> Built an end-to-end subscription churn analytics project on real KKBox data (6.7M users, 410M events). Designed a 3-layer dbt warehouse on DuckDB, ported final marts to BigQuery, and trained gradient boosting models capturing 67% of churners in the top decile. Quantified annual revenue at risk, validated drivers via chi-square and bootstrap CIs, designed an A/B test for retention actions, and delivered six Tableau dashboards.
