# Tableau

## Workbook

```text
kkbox_churn_retention_dashboard.twbx
```

## Dashboards

1. Executive Retention Overview (live BigQuery connection).
2. Churn Driver Analysis.
3. User Engagement Journey.
4. Revenue Risk & Subscription Health.
5. Retention Action Planner.
6. Statistical & Model Evidence.

## Data Inputs

All dashboards read from `data/processed/marts/*.parquet` exported as CSV. One dashboard reads live from BigQuery Sandbox to demonstrate cloud-warehouse fluency.

## Outputs in This Folder

```text
kkbox_churn_retention_dashboard.twbx
screenshots/   ← PNGs used in the case-study PDF
tableau_public_link.txt
```

## Design Reference

[07 Tableau Dashboard Design](../docs/07_tableau_dashboard_design.md).
