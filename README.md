# 📊 GAM License Audit & Optimization Script

## Overview

This project uses **GAMADV-XTD3** to audit Google Workspace license usage across an organization.
The goal is to quickly identify **unused or underutilized licenses** so IT can reclaim seats, reduce spend, and stay compliant.

As an IT Admin, this script helps answer a very common question:

> “How many licenses are we paying for that nobody is actually using?”

---

## What This Script Does

* Pulls a **license summary report** (total vs assigned licenses)
* Exports a **per-user license list** for deeper audits
* Attempts to calculate **unused licenses** automatically when supported
* Outputs clean CSV reports for finance, IT leadership, or audits

---

## Why This Is Useful (Real IT Impact)

* Saves money by identifying unused paid licenses
* Helps with **quarterly cost reviews**
* Useful during **SOC 2 / ISO audits**
* Prevents license sprawl as the company scales
* Eliminates manual checking in the Admin Console

---

## Files Generated

| File                   | Purpose                                |
| ---------------------- | -------------------------------------- |
| `license_totals_*.csv` | Overall license counts                 |
| `user_licenses_*.csv`  | Per-user license assignments           |
| `license_unused_*.csv` | Calculated unused seats (if available) |

---

## Requirements

* Google Workspace Admin account
* **GAMADV-XTD3** installed and authenticated
* Bash shell (macOS or Linux)
* Python 3 (for optional unused-seat calculation)

---

## How to Run

```bash
chmod +x gam_license_audit.sh
./gam_license_audit.sh ./gam_reports
```

Reports will be saved in the `gam_reports/` directory.

---

## Example Use Case

> Finance asks IT why Google Workspace costs increased last quarter.
> Run this script, identify unused Business Plus licenses, reclaim them, and immediately reduce spend.

---

## Future Enhancements

* Slack or email alerts when unused licenses exceed a threshold
* Automatic license removal for suspended users
* Scheduled weekly or monthly audits via cron
* Dashboard visualization using Google Sheets

---

## Key Skills Demonstrated

* Google Workspace administration
* License cost optimization
* Automation mindset
* Audit readiness
* Bash + GAM scripting
