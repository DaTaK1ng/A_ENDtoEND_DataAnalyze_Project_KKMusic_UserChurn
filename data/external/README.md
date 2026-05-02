# External Data

Optional supporting reference tables. Loaded as dbt seeds.

## Examples

- city lookup (city code to readable name),
- calendar table for dashboard time hierarchies,
- campaign calendar for promotional periods,
- confidence-level reference table for statistical reporting.

## Convention

- Small, static CSVs (≤ 5 MB each).
- Loaded via `dbt seed` from `dbt_kkbox/seeds/`.
