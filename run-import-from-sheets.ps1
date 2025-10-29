<#
Run Google Sheets -> Supabase import with safety checks.
Usage:
  - Ensure your .env.local or environment variables contain:
      NEXT_PUBLIC_SUPABASE_URL or SUPABASE_URL
      SUPABASE_SERVICE_ROLE_KEY or SUPABASE_SERVICE_KEY
      GOOGLE_SHEETS_ID
      GOOGLE_SERVICE_ACCOUNT_EMAIL
      GOOGLE_SERVICE_ACCOUNT_KEY (with embedded newlines encoded as \n)

  - Share the Google Sheet with the service account email (GOOGLE_SERVICE_ACCOUNT_EMAIL).
  - Run from repo root in PowerShell (Windows):
      pwsh ./scripts/run-import-from-sheets.ps1

What this script does:
  1) Loads .env.local if present (does not override already set env vars)
  2) Displays key variables (hides secrets) and asks for confirmation
  3) Runs `node ./utils/import-from-sheets.js` and writes a timestamped log to `reports/import-sheets-*.log`
  4) Returns exit code from the node process

This script intentionally does not run destructive SQL. Run against a staging DB first.
#>

param(
    [switch]$Staging,
    [switch]$DryRun
)

Set-StrictMode -Version Latest

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $scriptRoot\..\ | Out-Null

# Load .env.local if exists (simple parser)
$envFile = Join-Path (Get-Location) '.env.local'
if (Test-Path $envFile) {
    Write-Host "Loading $envFile"
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*#") { return }
        if ($_ -match "^\s*$") { return }
        $parts = $_ -split '='; if ($parts.Count -lt 2) { return }
        $k = $parts[0].Trim(); $v = ($parts[1..($parts.Count - 1)] -join '=').Trim();
        if (-not [string]::IsNullOrEmpty($env:$($k))) { return } # don't override existing env var
        $env:$k = $v
    }
}

# Helper to mask secret values for display
function Mask($s) {
    if (-not $s) { return '<missing>' }
    if ($s.Length -le 8) { return '********' }
    return $s.Substring(0, 4) + '...' + $s.Substring($s.Length - 4)
}

# Key env vars (fallbacks supported by script)
$SUPABASE_URL = $env:NEXT_PUBLIC_SUPABASE_URL; if (-not $SUPABASE_URL) { $SUPABASE_URL = $env:SUPABASE_URL }
$SUPABASE_KEY = $env:SUPABASE_SERVICE_ROLE_KEY; if (-not $SUPABASE_KEY) { $SUPABASE_KEY = $env:SUPABASE_SERVICE_KEY }
$GOOGLE_SHEETS_ID = $env:GOOGLE_SHEETS_ID
$GOOGLE_ACCOUNT = $env:GOOGLE_SERVICE_ACCOUNT_EMAIL
$GOOGLE_KEY = $env:GOOGLE_SERVICE_ACCOUNT_KEY

Write-Host "\n== Import from Google Sheets - quick check =="
Write-Host "Supabase URL: " $SUPABASE_URL
Write-Host "Supabase Service Key: " (if ($SUPABASE_KEY) { Mask($SUPABASE_KEY) } else { '<missing>' })
Write-Host "Google Sheets ID: " (if ($GOOGLE_SHEETS_ID) { Mask($GOOGLE_SHEETS_ID) } else { '<missing>' })
Write-Host "Google Service Account Email: " (if ($GOOGLE_ACCOUNT) { $GOOGLE_ACCOUNT } else { '<missing>' })
Write-Host "DryRun mode: " ($DryRun.IsPresent)
Write-Host "Staging mode: " ($Staging.IsPresent)

if (-not $SUPABASE_URL -or -not $SUPABASE_KEY -or -not $GOOGLE_SHEETS_ID -or -not $GOOGLE_ACCOUNT -or -not $GOOGLE_KEY) {
    Write-Host "\nERROR: one or more required environment variables are missing. Aborting." -ForegroundColor Red
    Write-Host "Ensure: NEXT_PUBLIC_SUPABASE_URL (or SUPABASE_URL), SUPABASE_SERVICE_ROLE_KEY (or SUPABASE_SERVICE_KEY), GOOGLE_SHEETS_ID, GOOGLE_SERVICE_ACCOUNT_EMAIL, GOOGLE_SERVICE_ACCOUNT_KEY"
    Pop-Location; exit 2
}

Write-Host "\nPlease confirm you have shared the Google Sheet with the service account email above."
$confirm = Read-Host "Type YES to proceed"
if ($confirm -ne 'YES') { Write-Host 'Aborted by user.'; Pop-Location; exit 3 }

# Create logs folder if missing
$reportsDir = Join-Path (Get-Location) 'reports'
if (-not (Test-Path $reportsDir)) { New-Item -ItemType Directory -Path $reportsDir | Out-Null }

$timestamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$logFile = Join-Path $reportsDir ("import-sheets_$timestamp.log")

# Build node command
$nodeScript = 'node'
$nodeFile = 'utils/import-from-sheets.js'
$cmd = "$nodeScript $nodeFile"
if ($DryRun) { Write-Host "Dry run requested — please run against a staging DB or set staging switch." }

Write-Host "\nRunning import, logging to $logFile"
# Start process and capture output
$startInfo = New-Object System.Diagnostics.ProcessStartInfo
$startInfo.FileName = $nodeScript
$startInfo.Arguments = $nodeFile
$startInfo.RedirectStandardOutput = $true
$startInfo.RedirectStandardError = $true
$startInfo.UseShellExecute = $false
$startInfo.EnvironmentVariables['SUPABASE_URL'] = $SUPABASE_URL
$startInfo.EnvironmentVariables['SUPABASE_SERVICE_KEY'] = $SUPABASE_KEY
$startInfo.EnvironmentVariables['NEXT_PUBLIC_SUPABASE_URL'] = $SUPABASE_URL
$startInfo.EnvironmentVariables['SUPABASE_SERVICE_ROLE_KEY'] = $SUPABASE_KEY
$startInfo.EnvironmentVariables['GOOGLE_SHEETS_ID'] = $GOOGLE_SHEETS_ID
$startInfo.EnvironmentVariables['GOOGLE_SERVICE_ACCOUNT_EMAIL'] = $GOOGLE_ACCOUNT
$startInfo.EnvironmentVariables['GOOGLE_SERVICE_ACCOUNT_KEY'] = $GOOGLE_KEY

$proc = New-Object System.Diagnostics.Process
$proc.StartInfo = $startInfo
$proc.Start() | Out-Null

# Stream output to console and file
$outStream = [System.IO.File]::CreateText($logFile)
try {
    while (-not $proc.HasExited) {
        $line = $proc.StandardOutput.ReadLine()
        if ($line -ne $null) { Write-Host $line; $outStream.WriteLine($line) }
        Start-Sleep -Milliseconds 50
    }
    # drain remaining output
    while (($line = $proc.StandardOutput.ReadLine()) -ne $null) { Write-Host $line; $outStream.WriteLine($line) }
    while (($err = $proc.StandardError.ReadLine()) -ne $null) { Write-Host $err -ForegroundColor Red; $outStream.WriteLine($err) }
}
finally {
    $outStream.Flush(); $outStream.Close()
}

$exitCode = $proc.ExitCode
Write-Host "\nImport finished with exit code: $exitCode"
Write-Host "Log file: $logFile"

Pop-Location
exit $exitCode
