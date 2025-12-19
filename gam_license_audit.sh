#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${1:-./gam_reports}"
TS="$(date +"%Y%m%d-%H%M%S")"
mkdir -p "$OUT_DIR"

echo "==> Writing reports to: $OUT_DIR"

# 1) License totals (fast)
# Documented: gam print licenses ... [countsonly] :contentReference[oaicite:2]{index=2}
LICENSE_TOTALS_CSV="$OUT_DIR/license_totals_$TS.csv"
gam redirect csv "$LICENSE_TOTALS_CSV" print licenses countsonly

echo "==> Created: $LICENSE_TOTALS_CSV"

# 2) Per-user licenses (helpful for audits/cleanup)
# If your GAM build supports one-license-per-row, this makes parsing easier. :contentReference[oaicite:3]{index=3}
USER_LICENSES_CSV="$OUT_DIR/user_licenses_$TS.csv"
gam redirect csv "$USER_LICENSES_CSV" print users fields primaryEmail,suspended,ou licenses

echo "==> Created: $USER_LICENSES_CSV"

# 3) Optional: quick “unused seats” calc if columns exist (best-effort)
# This section tries to detect common columns like totalSeats/maxSeats/inUse/assigned.
UNUSED_REPORT="$OUT_DIR/license_unused_$TS.csv"

python3 - <<'PY' "$LICENSE_TOTALS_CSV" "$UNUSED_REPORT"
import csv, sys, re

src, out = sys.argv[1], sys.argv[2]

def norm(s): return re.sub(r'[^a-z0-9]+','', (s or '').lower())

with open(src, newline='') as f:
    rows = list(csv.DictReader(f))

if not rows:
    print("No rows found in license totals CSV, skipping unused calc.")
    sys.exit(0)

# Find likely fields
headers = rows[0].keys()
hmap = {norm(h): h for h in headers}

# Common possibilities
total_candidates = ["totalseats","maxseats","maximumnumberofseats","numberofseats","totallicenses","seats"]
used_candidates  = ["inuse","usedseats","assigned","licensesinuse","inuselicense","inusecount"]

def pick(cands):
    for c in cands:
        if c in hmap: return hmap[c]
    return None

total_col = pick(total_candidates)
used_col  = pick(used_candidates)

if not total_col or not used_col:
    print("Could not confidently find total/used columns. Leaving raw totals only.")
    sys.exit(0)

def to_int(x):
    try:
        return int(str(x).strip())
    except:
        return None

with open(out, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["skuIdOrName", "total", "used", "unused"])
    for r in rows:
        total = to_int(r.get(total_col))
        used  = to_int(r.get(used_col))
        if total is None or used is None:
            continue
        # Pick a decent label
        label = r.get("skuId") or r.get("skuName") or r.get("sku") or r.get("productId") or "UNKNOWN"
        w.writerow([label, total, used, total - used])

print(f"Wrote unused report: {out}")
PY

if [[ -f "$UNUSED_REPORT" ]]; then
  echo "==> Created: $UNUSED_REPORT"
else
  echo "==> Unused calc skipped (columns didn’t match). You still have the raw totals CSV."
fi

echo "Done."
