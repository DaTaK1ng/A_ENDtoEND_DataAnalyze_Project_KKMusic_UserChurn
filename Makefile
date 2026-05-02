PYTHON ?= python3
VENV   := .venv
PIP    := $(VENV)/bin/pip
PY     := $(VENV)/bin/python
DBT    := $(VENV)/bin/dbt
JUPYTER := $(VENV)/bin/jupyter

.PHONY: help setup install preflight download audit dbt-build dbt-test dbt-docs train export-tableau clean

help:
	@echo "make setup           - Create venv and install all dependencies"
	@echo "make preflight       - Verify env, imports, and raw files"
	@echo "make download        - Download raw data via Kaggle CLI (v2-only, ~2.6GB)"
	@echo "make audit           - Run notebook 01 to audit raw files"
	@echo "make dbt-build       - Run all dbt models and tests"
	@echo "make dbt-test        - Run dbt tests only"
	@echo "make dbt-docs        - Build and serve dbt documentation site"
	@echo "make train           - Run notebook 05 to train churn models"
	@echo "make export-tableau  - Export marts to CSV for Tableau"
	@echo "make clean           - Remove dbt build artefacts and caches"

setup:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PY) -m ipykernel install --user --name kkbox-churn --display-name "Python (kkbox-churn)"

install: setup

preflight:
	$(PY) scripts/preflight_check.py

download:
	bash scripts/download_data.sh

audit:
	$(JUPYTER) nbconvert --to notebook --execute notebooks/01_raw_data_audit.ipynb --inplace

dbt-build:
	cd dbt_kkbox && ../$(DBT) deps
	cd dbt_kkbox && ../$(DBT) build

dbt-run:
	cd dbt_kkbox && ../$(DBT) run

dbt-test:
	cd dbt_kkbox && ../$(DBT) test

dbt-docs:
	cd dbt_kkbox && ../$(DBT) docs generate
	cd dbt_kkbox && ../$(DBT) docs serve

train:
	$(JUPYTER) nbconvert --to notebook --execute notebooks/05_model_training.ipynb --inplace

export-tableau:
	$(PY) scripts/export_marts_to_csv.py

clean:
	rm -rf dbt_kkbox/target dbt_kkbox/dbt_packages dbt_kkbox/logs
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name .ipynb_checkpoints -exec rm -rf {} +
