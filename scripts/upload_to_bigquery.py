"""Upload final mart tables to BigQuery Sandbox for the cloud demo.

Prerequisites:
  1. Create a free GCP account and enable BigQuery Sandbox.
  2. Create a service account with role `BigQuery Admin`.
  3. Download its JSON key to `secrets/gcp-key.json`.
  4. Copy `env.example` to `.env` and fill in `GCP_PROJECT_ID`.
  5. Install BigQuery deps:
        pip install google-cloud-bigquery pandas-gbq db-dtypes
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

import duckdb
import pandas as pd
from dotenv import load_dotenv

try:
    from google.cloud import bigquery
except ImportError:
    print("google-cloud-bigquery not installed. Run: pip install google-cloud-bigquery pandas-gbq db-dtypes")
    sys.exit(1)

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DUCKDB_PATH = PROJECT_ROOT / "data" / "processed" / "kkbox.duckdb"

load_dotenv(PROJECT_ROOT / ".env")

GCP_PROJECT = os.environ.get("GCP_PROJECT_ID")
DATASET     = os.environ.get("BIGQUERY_DATASET", "kkbox_marts")
KEY_PATH    = PROJECT_ROOT / os.environ.get("GOOGLE_APPLICATION_CREDENTIALS",
                                            "secrets/gcp-key.json")

UPLOAD_TABLES = [
    "mart_segment_summary",
    "mart_dashboard_monthly",
    "mart_user_risk_scores",
    "mart_statistical_tests",
    "mart_model_performance",
]


def main() -> int:
    if not GCP_PROJECT:
        print("GCP_PROJECT_ID is not set in .env")
        return 1
    if not KEY_PATH.exists():
        print(f"Service account key not found at {KEY_PATH}")
        return 1

    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = str(KEY_PATH)

    client = bigquery.Client(project=GCP_PROJECT)
    dataset_ref = bigquery.Dataset(f"{GCP_PROJECT}.{DATASET}")
    dataset_ref.location = "EU"

    try:
        client.create_dataset(dataset_ref, exists_ok=True)
        print(f"Dataset {GCP_PROJECT}.{DATASET} ready.")
    except Exception as exc:
        print(f"Failed to create / find dataset: {exc}")
        return 1

    con = duckdb.connect(str(DUCKDB_PATH), read_only=True)

    for table in UPLOAD_TABLES:
        try:
            df: pd.DataFrame = con.execute(f"select * from analytics.{table}").df()
        except duckdb.Error as exc:
            print(f"  skipped {table}: {exc}")
            continue

        full_table_id = f"{GCP_PROJECT}.{DATASET}.{table}"
        job = client.load_table_from_dataframe(
            df, full_table_id,
            job_config=bigquery.LoadJobConfig(
                write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
            ),
        )
        job.result()
        print(f"  uploaded {table}: {len(df):,} rows -> {full_table_id}")

    con.close()
    print("Done.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
