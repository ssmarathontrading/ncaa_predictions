#!/bin/bash

# NCAA Predictions Data Status Check
# This script checks the status of the automated data collection

echo "=== NCAA Predictions Data Collection Status ==="
echo "Date: $(date)"
echo

# Check if data directory exists
if [ ! -d "data" ]; then
    echo "❌ ERROR: Data directory not found"
    exit 1
fi

echo "📊 Data Directory Status:"
ls -la data/
echo

# Count total files
file_count=$(find data/ -name "ncaapredictions_*.csv" -type f | wc -l)
echo "📈 Total data files: $file_count"

# Check for today's files
today=$(date +%Y%m%d)
morning_file="data/ncaapredictions_${today}_10am.csv"
evening_file="data/ncaapredictions_${today}_5pm.csv"

echo
echo "🕐 Today's Data Collection Status ($today):"

if [ -f "$morning_file" ]; then
    size=$(stat -c%s "$morning_file" 2>/dev/null || echo "unknown")
    modified=$(stat -c%y "$morning_file" 2>/dev/null || echo "unknown")
    echo "  ✅ Morning file (10am): Found ($size bytes, modified: $modified)"
else
    echo "  ⏳ Morning file (10am): Not found (may not be time yet or collection failed)"
fi

if [ -f "$evening_file" ]; then
    size=$(stat -c%s "$evening_file" 2>/dev/null || echo "unknown")
    modified=$(stat -c%y "$evening_file" 2>/dev/null || echo "unknown")
    echo "  ✅ Evening file (5pm): Found ($size bytes, modified: $modified)"
else
    echo "  ⏳ Evening file (5pm): Not found (may not be time yet or collection failed)"
fi

# Check for recent files (last 3 days)
echo
echo "📅 Recent Data Files (last 3 days):"
find data/ -name "ncaapredictions_*.csv" -type f -mtime -3 -exec ls -lh {} \; | sort -r

# Check current time vs scheduled times
current_hour=$(date -u +%H)
current_minute=$(date -u +%M)
current_time_minutes=$((current_hour * 60 + current_minute))

# Scheduled times in UTC: 14:00 (840 minutes) and 21:00 (1260 minutes)
next_10am_minutes=840
next_5pm_minutes=1260

echo
echo "⏰ Schedule Information:"
echo "  Current time (UTC): $(date -u +'%H:%M')"
echo "  Next scheduled runs (UTC):"
echo "    - 14:00 (10 AM Eastern)"
echo "    - 21:00 (5 PM Eastern)"

if [ $current_time_minutes -lt $next_10am_minutes ]; then
    minutes_until=$((next_10am_minutes - current_time_minutes))
    echo "  ⏳ Next run in: $((minutes_until / 60))h $((minutes_until % 60))m (10 AM Eastern)"
elif [ $current_time_minutes -lt $next_5pm_minutes ]; then
    minutes_until=$((next_5pm_minutes - current_time_minutes))
    echo "  ⏳ Next run in: $((minutes_until / 60))h $((minutes_until % 60))m (5 PM Eastern)"
else
    # After 21:00, next run is tomorrow at 14:00
    minutes_until=$((1440 + next_10am_minutes - current_time_minutes))
    echo "  ⏳ Next run in: $((minutes_until / 60))h $((minutes_until % 60))m (10 AM Eastern tomorrow)"
fi

echo
echo "🔗 Manual Trigger: Go to GitHub Actions > 'Update NCAA Predictions CSV' > 'Run workflow'"
echo "=== End Status Check ==="