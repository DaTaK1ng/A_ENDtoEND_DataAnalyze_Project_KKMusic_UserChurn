# 11 A/B Test Design and Model Monitoring

This document closes the loop from "predict churn" to "intervene and verify". The A/B test is a paper design, not a real deployment — it demonstrates experimental thinking expected of an analyst.

## Part 1 — A/B Test Design

### Hypothesis

> Offering a 30% renewal discount to users in the **High risk band** (predicted churn probability between 0.55 and 0.80) reduces their 30-day churn rate by at least 6 percentage points (from 28% to 22%).

### Population

- Users 30 days before `membership_expire_date`.
- Predicted churn probability ∈ [0.55, 0.80].
- Active in last 60 days (excludes already-disengaged users).

### Treatment

- Treatment group: receive a personalised 30%-off renewal email + in-app banner.
- Control group: receive standard renewal reminder only.

### Randomisation

- Unit: `msno` (user ID).
- 50 / 50 split.
- Stratified by city and tenure band to balance covariates.

### Sample-Size Calculation

- Baseline churn rate: 0.28
- Minimum detectable effect (MDE): 0.06 (absolute)
- Significance: α = 0.05 (two-sided)
- Power: 1 − β = 0.80
- Required sample size per arm: ~915 users (two-proportion z-test).
- Total sample needed: ~1,830 users (round up to 2,000 for buffer).

### Duration

- 4 weeks, covering one billing cycle.
- Weekly checks against stopping rules.

### Primary Metric

30-day post-expiry retention rate.

### Guardrail Metrics

- ARPU (revenue per active user) — protect against discount cannibalisation.
- Refund / complaint rate.
- Auto-renew rate change.
- Net revenue per user including discount cost.

### Stopping Rules

- Early stop if two-sided p < 0.01 in either direction.
- Stop if guardrail breach: ARPU drop > 10% or complaint rate up > 5%.

### Analysis Plan

- Primary: two-proportion z-test on retention.
- Confidence intervals: 95% on retention difference.
- Heterogeneous effects: subgroup analysis by tenure band, city tier, plan length.
- Net revenue calculation: `(retention uplift × monthly ARPU) − discount cost`.

### Decision Rule

Roll out broadly only if:

1. Retention uplift ≥ 4pp at p < 0.05, **and**
2. Net revenue per user > 0 after discount cost, **and**
3. No guardrail breach.

## Part 2 — Model Monitoring Simulation

The dataset's time dimension lets us simulate post-deployment monitoring without a real production system.

### Setup

- Train on data ending 2017-02.
- Score users monthly for March and April 2017.
- Track metrics across the simulated months.

### Monitoring Metrics

| Metric | Definition | Threshold |
|---|---|---|
| Recall at top decile | Among top 10% predicted, share that actually churned. | Alert if drops > 10% relative to training value. |
| AUC | On batch with realised labels. | Alert if drops > 0.05. |
| Population Stability Index (PSI) | On predicted probability distribution vs training distribution. | Alert if > 0.20. |
| Feature drift (PSI per feature) | Per-feature distribution shift. | Investigate top-3 features with PSI > 0.10. |
| Score distribution mean and variance | Tracks calibration drift. | Alert on > 2σ deviation. |

### Retraining Cadence

- Default: monthly retrain.
- Trigger early retrain if PSI > 0.25 or recall@10 drops > 15%.

### Outputs

- `notebooks/07_model_monitoring_simulation.ipynb`.
- `mart_model_monitoring` table with monthly metric rows.
- Tableau Dashboard 6 surfaces these metrics.

## Why This Document Matters for the CV

It demonstrates that the analyst:

- thinks about post-deployment risk, not just modelling,
- understands experimental design (sample size, MDE, guardrails),
- can quantify business impact, not only statistical significance,
- speaks the language used by Product, CRM, and Data Science teams.
