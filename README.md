# NCAA Predictions Data Collection

This repository automatically collects NCAA predictions data from [The Prediction Tracker](https://www.thepredictiontracker.com/) on a regular schedule.

## Automated Schedule

The data collection runs **automatically twice daily** via GitHub Actions:

- **10:00 AM Eastern** (14:00 UTC) - Morning update
- **5:00 PM Eastern** (21:00 UTC) - Evening update

## How It Works

1. **Data Source**: Downloads the latest NCAA predictions CSV from `https://www.thepredictiontracker.com/ncaapredictions.csv`
2. **Processing**: Validates the downloaded data and creates timestamped files
3. **Storage**: Saves files in the `data/` directory with format `ncaapredictions_YYYYMMDD_[10am|5pm].csv`
4. **Version Control**: Automatically commits and pushes new data files to the repository

## Features

- ✅ **Automatic scheduling** - Runs twice daily without manual intervention
- ✅ **Error handling** - Retries failed downloads and validates data integrity
- ✅ **Manual triggering** - Can be run manually via GitHub Actions
- ✅ **Data retention** - Automatically cleans up files older than 30 days
- ✅ **Change detection** - Only commits when new data is actually different
- ✅ **Detailed logging** - Provides comprehensive job summaries and status reports

## Manual Execution

You can manually trigger the data collection:

1. Go to the [Actions tab](../../actions) in this repository
2. Select "Update NCAA Predictions CSV" workflow
3. Click "Run workflow"
4. Optionally enable "Force update" to commit even if no changes are detected

## Data Format

The collected CSV files contain NCAA game predictions with various prediction models and metrics. Each row represents a game with predictions from multiple sources.

## File Structure

```
data/
├── ncaapredictions_20250828_10am.csv    # Morning collection
├── ncaapredictions_20250828_5pm.csv     # Evening collection
└── ...                                   # Historical data
```

## Monitoring

The workflow provides detailed status information:
- Download success/failure with retry attempts
- File validation results
- Change detection and commit statistics
- Data retention cleanup logs

## Troubleshooting

If the automated collection fails:

1. Check the [Actions tab](../../actions) for error details
2. Verify the data source is accessible
3. Manually trigger the workflow to test
4. Review the job summary for specific error information

The workflow is designed to be resilient with automatic retries and comprehensive error handling.