# 10 Modeling and Evaluation

## Scope (light ML)

Two models, no ensembling, no exhaustive tuning. Priority is **interpretability + business action**, not leaderboard accuracy.

## Target

Binary classification: `is_churn` from `mart_user_churn_features`.

## Train / Validation / Holdout Split

Time-based split, not random:

```text
Train       :  2017-01 transactions and earlier
Validation  :  2017-02
Holdout     :  2017-03 (also used as month-1 deployment simulation)
Drift check :  2017-04 (used as month-2 deployment simulation)
```

This avoids leakage and produces realistic performance estimates.

## Feature Set

From `mart_user_churn_features`:

- profile features (city, age band, gender, channel, tenure),
- transaction features (auto-renew, cancellation count, discount rate, price per day, days since last transaction, plan length),
- engagement features over 7 / 15 / 30 / 60-day windows,
- engineered: engagement drop, payment recency, subscription gap count.

Categorical encoding: target-encoded for high-cardinality (`city`, `payment_method_id`); one-hot for low-cardinality.

## Models

### Baseline — Logistic Regression

- L2 regularisation, `class_weight='balanced'`.
- Standardised numerical features.
- Coefficients exported to `mart_model_performance`.

### Production Candidate — LightGBM

- Gradient boosting on tree learners.
- Hyperparameters: light grid (`num_leaves`, `min_data_in_leaf`, `learning_rate`); 5-fold CV on training period only.
- Early stopping on validation log loss.
- `class_weight` calibrated via `scale_pos_weight`.

## Calibration

Isotonic regression on validation set so predicted probabilities can be used directly for revenue-at-risk and risk-band thresholds.

## Evaluation Metrics

| Metric | Why |
|---|---|
| AUC | Threshold-free ranking quality. |
| Log loss | Calibrated probability quality. |
| Recall at top decile | Operational: how many churners caught if we act on top 10%. |
| Lift at top decile | Compares to random targeting. |
| Calibration curve | Probabilities trustworthy for revenue-at-risk. |
| Brier score | Aggregate calibration. |
| Confusion matrix at chosen threshold | Decision-ready metrics. |

## Interpretability

- Logistic regression: standardised coefficients with confidence intervals.
- LightGBM: SHAP values — global feature importance and per-segment force plots.
- Output to `mart_user_risk_scores`: top-3 SHAP drivers per user feed the action planner.

## Risk Bands

| Band | Probability range | Suggested action |
|---|---|---|
| Critical | ≥ 0.80 | Personalised retention offer + CS contact. |
| High | 0.55 – 0.80 | Targeted discount on renewal. |
| Medium | 0.30 – 0.55 | Re-engagement push notification. |
| Low | < 0.30 | No active intervention. |

## Outputs

- `mart_user_risk_scores` — one row per user with probability, band, top SHAP drivers.
- `mart_model_performance` — per-model metric row.
- `notebooks/05_model_training_and_evaluation.ipynb`.
- Plots: ROC curve, lift chart, calibration curve, SHAP summary.
