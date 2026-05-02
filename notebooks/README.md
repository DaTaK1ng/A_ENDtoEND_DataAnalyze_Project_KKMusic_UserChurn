# Notebooks

Jupyter notebooks for analysis steps that sit outside dbt (audit, statistics, modelling, monitoring).

## Notebooks

```text
01_raw_data_audit.ipynb
02_eda_churn_drivers.ipynb
03_statistical_tests.ipynb
05_model_training.ipynb
06_segment_revenue_risk.ipynb
07_model_monitoring_sim.ipynb
```

## Conventions

- Notebooks read from `data/processed/kkbox.duckdb`.
- Re-runnable end-to-end with no manual cell ordering.
- Plots saved to `reports/dashboard_screenshots/` for the case-study PDF.

## Execution Order

1. `01_raw_data_audit.ipynb`
2. `02_eda_churn_drivers.ipynb`
3. `03_statistical_tests.ipynb`
4. `05_model_training.ipynb`
5. `06_segment_revenue_risk.ipynb`
6. `07_model_monitoring_sim.ipynb`
