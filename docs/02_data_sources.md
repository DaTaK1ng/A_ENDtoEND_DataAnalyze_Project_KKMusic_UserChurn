# 02 Data Sources

## Primary Dataset

WSDM Cup 2018 — KKBox Churn Prediction Challenge.

- Official site: <https://wsdm-cup-2018.kkbox.events/>
- Kaggle: <https://www.kaggle.com/c/kkbox-churn-prediction-challenge>
- Data page: <https://www.kaggle.com/competitions/kkbox-churn-prediction-challenge/data>

## Credibility

Real subscription data from KKBox, a music streaming company. Released through WSDM Cup 2018, a recognised data mining conference.

## Files We Need (v2-only, ~2.6 GB total)

| File | Size | Purpose | Required? |
|---|---:|---|:---:|
| `members_v3.csv` | ~400 MB | User profile (~6.7M users) | ✅ Required |
| `transactions_v2.csv` | ~150 MB | Subscription events for March 2017 expiry users | ✅ Required |
| `user_logs_v2.csv` | ~2 GB | Daily listening behaviour (~18M events) | ✅ Required |
| `train_v2.csv` | ~30 MB | Churn labels for ~970K users | ✅ Required |

## Files We Skip and Why

| File | Skip reason |
|---|---|
| `sample_submission_zero.csv`, `sample_submission_v2.csv` | Unlabeled test users for the Kaggle competition leaderboard. No churn label, no analytical value. |
| `transactions.csv` (v1) | Older subset; v2 covers our analysis window. |
| `user_logs.csv` (v1) | 28 GB; v2 is ~14× smaller and self-contained. Skip unless desktop has the disk space. |
| `train.csv` (v1) | Older labels; v2 is the corrected version used in the competition's second round. |

## Data Resulting Scale

| Asset | Rows |
|---:|---:|
| Members | ~6.7M |
| Transactions (v2) | ~1.4M |
| Listening events (v2) | ~18M |
| Labelled users (v2) | ~970K |

## Why Not the Train/Test Split?

The Kaggle competition splits into `train_v2.csv` (with labels) and `sample_submission_v2.csv` (no labels). That split is a competition rule, not an analytical requirement.

For business analytics we need users with known churn outcomes. We therefore use only `train_v2.csv` (labelled) and create our own time-based train / validation / holdout split inside the modelling notebook (see [10 Modeling and Evaluation](10_modeling_and_evaluation.md)).

## Access

Download requires:

1. Kaggle account.
2. Competition rule acceptance.
3. Kaggle API token at `~/.kaggle/kaggle.json`.

## Quick Download

```bash
mkdir -p data/raw && cd data/raw
kaggle competitions download -c kkbox-churn-prediction-challenge -f members_v3.csv.7z
kaggle competitions download -c kkbox-churn-prediction-challenge -f transactions_v2.csv.7z
kaggle competitions download -c kkbox-churn-prediction-challenge -f user_logs_v2.csv.7z
kaggle competitions download -c kkbox-churn-prediction-challenge -f train_v2.csv.7z
7z x "*.7z" && rm *.7z
```

A scripted version is in [`scripts/download_data.sh`](../scripts/download_data.sh).

## Optional: Add v1 Files Later

If you want to expand later to ~410M listening events (the headline KKBox number), download `user_logs.csv` and union it with v2 in `stg_user_logs`. The dbt model already supports the union pattern.
