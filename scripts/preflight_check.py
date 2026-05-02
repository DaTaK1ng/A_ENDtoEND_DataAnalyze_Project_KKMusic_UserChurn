"""Preflight checks for local reproducibility.

Run:
    python scripts/preflight_check.py
"""
from __future__ import annotations

import importlib
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = PROJECT_ROOT / "data" / "raw"
DBT_DIR = PROJECT_ROOT / "dbt_kkbox"


def check_python() -> bool:
    v = sys.version_info
    ok = (v.major, v.minor) == (3, 11)
    print(f"Python version: {v.major}.{v.minor}.{v.micro} ({'OK' if ok else 'WARN'})")
    if not ok:
        print("  Recommended version is Python 3.11 for full reproducibility.")
    return True


def check_imports() -> bool:
    modules = [
        "duckdb",
        "pandas",
        "numpy",
        "scipy",
        "statsmodels",
        "sklearn",
        "lightgbm",
        "dbt",
        "jupyter",
    ]
    ok = True
    for m in modules:
        try:
            importlib.import_module(m)
            print(f"Import {m:12s}: OK")
        except Exception as exc:  # noqa: BLE001
            ok = False
            print(f"Import {m:12s}: FAIL ({exc})")
    return ok


def check_raw_files() -> bool:
    files = ["members_v3.csv", "transactions_v2.csv", "user_logs_v2.csv", "train_v2.csv"]
    ok = True
    for name in files:
        p = RAW_DIR / name
        exists = p.exists() and p.stat().st_size > 0
        print(f"Raw file {name:20s}: {'OK' if exists else 'MISSING'}")
        ok = ok and exists
    return ok


def main() -> int:
    print("== KKBox preflight check ==")
    print(f"Project root: {PROJECT_ROOT}")
    print(f"dbt dir     : {DBT_DIR}")
    print(f"raw dir     : {RAW_DIR}")
    print()

    ok = True
    ok &= check_python()
    ok &= check_imports()
    ok &= check_raw_files()

    print()
    print("Result:", "PASS" if ok else "FAIL")
    if not ok:
        print("Fix missing dependencies/files, then rerun.")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
