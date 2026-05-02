# 08 Delivery Plan

## Timeline (6–7 weeks at ~25–30 hours per week)

| Week | Focus | Outputs |
|---|---|---|
| 1 | Setup and audit | Python venv, dbt project initialised, raw data downloaded, `01_raw_data_audit.ipynb` complete. |
| 2 | Staging + intermediate | All `stg_*` and `int_*` dbt models built and tested. |
| 3 | Marts + KPI | Core dimensional model and analytics marts built. KPI queries validated. |
| 4 | Statistical analysis + EDA | Hypothesis tests, confidence intervals, EDA notebook. **Start applying for grad-scheme roles.** |
| 5 | Modelling | Logistic regression baseline + LightGBM. Calibration and SHAP. Risk bands assigned. |
| 6 | BI and cloud | Six Tableau dashboards. Final marts pushed to BigQuery. Tableau Public link live. **Start applying for full Data/Business Analyst roles.** |
| 7 | Reporting and polish | Case-study PDF, GitHub README polish, A/B test doc, monitoring simulation. **Start LinkedIn outreach.** |

## Phases

### Phase 1 — Data Acquisition

- Download KKBox raw files from Kaggle.
- Store in `data/raw/` (gitignored).
- Audit row counts, columns, missing values, date ranges, label distribution, leakage windows.

### Phase 2 — dbt Warehouse Build

- Initialise `dbt_kkbox` with `dbt-duckdb` adapter.
- Build staging, intermediate, and core mart models.
- Add dbt tests for keys, nulls, accepted values, leakage windows.
- Generate `dbt docs` lineage site.

### Phase 3 — KPI and Statistical Analysis

- Compute KPIs for churn, retention, engagement, subscription, revenue.
- Run four planned hypothesis tests with confidence intervals and effect sizes.
- Persist results to `mart_statistical_tests`.

### Phase 4 — Predictive Modelling

- Train logistic regression baseline.
- Train LightGBM gradient boosting model.
- Time-based train / validation / holdout split.
- Evaluate AUC, log loss, recall, lift, calibration, top-decile capture.
- Persist results to `mart_model_performance` and per-user scores to `mart_user_risk_scores`.

### Phase 5 — Segmentation and Action Planning

- Cross risk bands with value tiers to define segments.
- Estimate revenue at risk per segment.
- Map segments to retention actions.
- Document action priority and ROI scenarios.

### Phase 6 — BI Delivery

- Export marts to Tableau-ready CSVs.
- Push final marts to BigQuery Sandbox.
- Build six Tableau dashboards (one connected live to BigQuery).
- Publish to Tableau Public.

### Phase 7 — Reporting and Portfolio

- Executive summary in `reports/executive_summary.md`.
- One-page report PDF in `reports/report.pdf`.
- Polish GitHub README and pin Tableau Public + dbt docs links.
- Write A/B test design doc and monitoring simulation.

## Job-Application Cadence

- **End of Week 4.** GitHub has dbt project + EDA notebook visible. Begin applying to graduate schemes.
- **End of Week 6.** Tableau Public live, dashboards complete. Begin applying to direct-hire analyst roles.
- **End of Week 7.** PDF case study and 30-second Loom walkthrough ready. Begin LinkedIn outreach to hiring managers.

## Final Outputs

- dbt project with lineage docs.
- Cleaned analytical Parquet datasets.
- Trained model artefacts and evaluation reports.
- Six Tableau dashboards published.
- Executive summary, case-study PDF, GitHub README.
- A/B test design and monitoring simulation.
