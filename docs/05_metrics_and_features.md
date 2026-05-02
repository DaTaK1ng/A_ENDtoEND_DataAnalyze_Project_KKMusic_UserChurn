# 05 Metrics and Features

## KPI Groups

### Churn and Retention

| KPI | Definition |
|---|---|
| Churn Rate | churned users / labelled users in window |
| Retention Rate | 1 − Churn Rate |
| High-Risk Users | count where churn probability ≥ chosen threshold |
| Churn Probability | model-predicted score |

### Engagement

- Active listening days.
- Total and average daily listening seconds.
- Unique songs played.
- Completion rate = `num_100 / (num_25 + num_50 + num_75 + num_985 + num_100)`.
- Recent engagement drop = (last 15-day metric − prior 15-day metric) / prior.

### Subscription and Payment

- Auto-renew rate.
- Cancellation rate.
- Average plan days.
- Discount rate = 1 − `actual_amount_paid` / `plan_list_price`.
- Price per day = `actual_amount_paid` / `payment_plan_days`.
- Transaction frequency.
- Subscription gap count.

### Revenue Risk

- Expected monthly revenue per user.
- Revenue at Risk = churn probability × expected revenue.
- Risk-adjusted revenue = expected revenue − revenue at risk.
- Segment revenue exposure.
- Retention ROI scenario (cost of action vs revenue saved).

### Statistical Metrics

- Churn-rate confidence interval (Wilson or bootstrap).
- Difference in churn rate between groups.
- p-value.
- Effect size (Cohen's h for proportions, Cohen's d for means).

## Feature Groups

### Profile Features

city, gender, age band, registration channel, tenure (days since registration).

### Transaction Features

- transaction count, latest payment method, latest auto-renew flag,
- cancellation count, discount rate, price per day,
- days since last transaction, plan length distribution.

### Engagement Features (windows: 7 / 15 / 30 / 60 days)

active days, listening seconds, completed plays, partial plays, completion rate, unique songs, engagement drop.

## Hypothesis Tests

| # | Question | Test |
|---|---|---|
| 1 | Do auto-renew users churn less? | Two-proportion z-test (or chi-square). |
| 2 | Do churned users show stronger engagement decline? | Mann-Whitney U + bootstrap CI. |
| 3 | Do heavy-discount users churn more? | Chi-square on discount band × churn. |
| 4 | Do registration channels differ in retention? | Chi-square on channel × churn. |

Outputs: confidence intervals, p-values, effect sizes, business interpretation.

## Model Evaluation

- AUC.
- Log loss.
- Precision, recall, F1 at chosen threshold.
- Lift chart.
- Top-decile churn capture.
- Calibration curve.
- SHAP-based feature importance.

Accuracy alone is unreliable because churn is class-imbalanced.
