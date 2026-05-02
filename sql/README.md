# SQL

Ad-hoc query scratch space. Production SQL lives in the dbt project at `dbt_kkbox/models/`.

## Use Cases

- Exploratory queries before promoting logic to a dbt model.
- One-off data quality checks.
- KPI sanity verifications.
- Sample SQL snippets used in the case-study PDF.

## Convention

- Each file starts with a comment block: purpose, author, date.
- Files target DuckDB syntax, but stay ANSI-compatible where possible so they port to Snowflake / BigQuery.

## See Also

[06 Database Design](../docs/06_database_design.md) for the full dbt warehouse structure.
