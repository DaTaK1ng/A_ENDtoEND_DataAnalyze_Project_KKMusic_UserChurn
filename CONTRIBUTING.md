# Contributing

Thanks for contributing.

## Local Setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Data Policy

- Do not commit raw KKBox data files.
- Do not commit processed outputs (`data/processed/*`).
- Keep secrets in `.env` / `secrets/` only (both gitignored).

## Before Opening a PR

```bash
cd dbt_kkbox
DBT_PROFILES_DIR=. dbt deps
DBT_PROFILES_DIR=. dbt parse
cd ..
```

If data is available locally, also run:

```bash
make dbt-build
```

## Notebook Hygiene

- Keep notebooks committed without execution outputs.
- Prefer deterministic execution order.
- Use the `Python (kkbox-churn)` kernel from `.venv`.
