"""Export DuckDB mart tables to Tableau-ready CSV files.

Run after `dbt build` and after the modelling notebooks have written
the Python-produced marts (mart_user_risk_scores, mart_statistical_tests,
mart_model_performance, mart_model_monitoring).
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

import duckdb

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DUCKDB_PATH = PROJECT_ROOT / "data" / "processed" / "kkbox.duckdb"
OUT_DIR = PROJECT_ROOT / "data" / "processed" / "tableau"

EXPORTS = {
    "tableau_user_summary":          "select * from analytics.mart_user_churn_features",
    "tableau_segment_summary":       "select * from analytics.mart_segment_summary",
    "tableau_dashboard_monthly":     "select * from analytics.mart_dashboard_monthly",
    "tableau_user_risk_scores":      "select * from analytics.mart_user_risk_scores",
    "tableau_statistical_tests":     "select * from analytics.mart_statistical_tests",
    "tableau_model_performance":     "select * from analytics.mart_model_performance",
    "tableau_model_monitoring":      "select * from analytics.mart_model_monitoring",
}


def main() -> int:
    if not DUCKDB_PATH.exists():
        print(f"DuckDB file not found at {DUCKDB_PATH}. Run `dbt build` first.")
        return 1

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(DUCKDB_PATH), read_only=True)

    written = 0
    for name, query in EXPORTS.items():
        out_path = OUT_DIR / f"{name}.csv"
        try:
            con.execute(f"COPY ({query}) TO '{out_path}' (FORMAT CSV, HEADER TRUE)")
            written += 1
            print(f"  wrote {out_path.relative_to(PROJECT_ROOT)}")
        except duckdb.Error as exc:
            print(f"  skipped {name}: {exc}")

    con.close()
    print(f"\nExported {written}/{len(EXPORTS)} marts to {OUT_DIR.relative_to(PROJECT_ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
