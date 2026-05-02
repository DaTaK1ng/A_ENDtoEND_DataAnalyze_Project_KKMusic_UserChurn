# 12 Tech Stack

## Goal

Mirror a real modern data stack on a single laptop, at zero cost, while staying portable to enterprise warehouses (Snowflake, BigQuery, Databricks).

## Stack Overview

```text
[Source]            [Warehouse]         [Transform]      [Analyse]        [BI]              [Cloud demo]
KKBox CSV files  →  DuckDB (.duckdb)  →  dbt-duckdb   →  Python / Jupyter  →  Tableau Public  →  BigQuery Sandbox
                                          (SQL models)    sklearn, SHAP                          (final marts only)
```

## Component Roles

### DuckDB — local analytical engine

- Single-file embedded OLAP database.
- Reads CSV and Parquet directly without ETL.
- Runs ANSI SQL with full window function support on 410M-row logs in seconds on a laptop.
- Replaces the role of Snowflake / BigQuery for local development.

### dbt-core + dbt-duckdb — SQL transformation framework

- Industry-standard tool for warehouse modelling (used by Workday, Stripe, HubSpot, Intercom).
- Models are written as `.sql` files and compiled into a DAG.
- Auto-generated lineage, tests, and docs.
- Same SQL runs unchanged on Snowflake or BigQuery by switching the adapter — proves portability.

### Python (3.11+) — modelling and statistics

- pandas, numpy: light data manipulation outside dbt.
- scikit-learn: logistic regression, gradient boosting, calibration.
- statsmodels, scipy.stats: hypothesis tests, confidence intervals.
- SHAP: model interpretability.
- jupyter: notebooks for EDA, statistics, and modelling.

### Tableau Public — business storytelling

- Six dashboards consume `mart_*` tables exported as CSV.
- Public link allows recruiters to interact without installing Tableau.

### BigQuery Sandbox — cloud demo layer

- Free, no credit card required.
- Final mart tables (≤ 100MB) are uploaded for one Tableau dashboard with a live cloud connection.
- Demonstrates cloud-warehouse fluency for CV keyword coverage.

### Git + GitHub — version control and portfolio surface

- Public repo serves as primary portfolio link.
- README, dbt docs site, and Tableau Public link are the recruiter entry points.

## Why This Stack

| Decision | Reason |
|---|---|
| DuckDB over PostgreSQL | Faster on analytical queries; no server to manage. |
| dbt over raw `.sql` files | Industry standard; lineage and tests come free. |
| dbt-duckdb adapter | Same project portable to Snowflake / BigQuery. |
| Tableau Public over Power BI | Free public hosting; recruiters can click directly. |
| BigQuery Sandbox over Snowflake trial | Permanent free tier, no card, simpler auth. |
| LightGBM / sklearn over deep learning | Tabular churn data; interpretability is the priority. |

## Local Setup (one-time)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install duckdb dbt-core dbt-duckdb pandas scikit-learn lightgbm shap statsmodels jupyter
```

Initialise the dbt project:

```bash
dbt init dbt_kkbox --adapter duckdb
```

## Repository Layout

```text
kkbox-churn-retention-analysis/
├── README.md
├── project_full_workflow.md
├── data/raw/                   ← KKBox CSVs (not committed)
├── data/processed/             ← Parquet outputs from dbt
├── dbt_kkbox/                  ← dbt project (added during build phase)
├── notebooks/                  ← Jupyter analysis
├── sql/                        ← Ad-hoc query scratch
├── tableau/                    ← .twbx workbook + screenshots
├── reports/                    ← Case study, slides, PDF
└── docs/                       ← Project specifications
```

## Hiring-Signal Mapping

| Project artefact | CV keyword unlocked |
|---|---|
| dbt project | dbt, modular SQL, data lineage, dimensional modelling |
| DuckDB engine | OLAP, columnar, modern data tooling |
| dbt-duckdb portability | Snowflake, BigQuery (transferable) |
| BigQuery Sandbox marts | GCP, cloud data warehouse |
| Tableau Public | Tableau, dashboard storytelling |
| Python notebooks | pandas, scikit-learn, SHAP, statsmodels |
| A/B test design doc | experimentation, causal reasoning |
| Monitoring simulation | model drift, PSI, MLOps awareness |
