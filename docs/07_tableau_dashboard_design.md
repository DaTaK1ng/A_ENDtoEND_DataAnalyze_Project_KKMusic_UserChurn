# 07 Tableau Dashboard Design

## Goal

Six dashboards that explain churn, quantify revenue exposure, validate evidence, and prescribe action.

## Data Sources

All dashboards read from `mart_*` Parquet exports. One dashboard (Executive Overview) connects live to BigQuery to demonstrate cloud BI.

## Global Filters

time period, city, age band, gender, registration channel, plan duration, auto-renew status, risk band, segment.

## Dashboard 1 — Executive Retention Overview

Purpose: overall retention health for executives.

KPI cards: churn rate, retention rate, high-risk users, revenue at risk, auto-renew rate.
Charts: monthly churn trend, risk band distribution, churn by city.

## Dashboard 2 — Churn Driver Analysis

Purpose: explain why users churn.

Charts: churn by auto-renew, churn by cancellation history, churn by discount band, churn by engagement-drop quintile, SHAP-based feature importance.

## Dashboard 3 — User Engagement Journey

Purpose: behavioural signal in the weeks before expiry.

Charts: engagement trend over the last 60 days, active days by churn status, listening seconds by risk band, completion rate vs churn probability, engagement-drop box plot.

## Dashboard 4 — Revenue Risk & Subscription Health

Purpose: financial exposure prioritisation.

Charts: revenue at risk by segment, high-value × high-risk quadrant, plan price and discount distribution, payment method risk, subscription health metrics.

## Dashboard 5 — Retention Action Planner

Purpose: turn analytics into actions.

Charts: recommended action by segment, user count by action, revenue at risk by action, expected uplift scenario, retention ROI estimate.

## Dashboard 6 — Statistical & Model Evidence

Purpose: credibility layer.

Charts: hypothesis test summary, churn-rate confidence intervals, p-value cards, model comparison table, lift chart, calibration curve, prediction probability distribution.

## Story Flow

1. What is the churn problem?
2. Where is risk concentrated?
3. Why do users churn?
4. Which users get prioritised?
5. How strong is the evidence?
6. What actions follow?

## Publishing

- `tableau/kkbox_churn_retention_dashboard.twbx` committed to repo.
- Public link on Tableau Public.
- Static screenshots in `tableau/screenshots/` for the case-study PDF.
