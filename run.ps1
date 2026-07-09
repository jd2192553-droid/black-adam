# Aegis Security Dashboard - Quick Local Runner
# Run this script in PowerShell to automatically set up dependencies and launch the app.

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "       Aegis Security Dashboard          " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# 1. Check if Python is installed
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Error: Python is not installed or not in your system's PATH." -ForegroundColor Red
    Exit
}

# 2. Check for Virtual Environment
if (!(Test-Path ".venv")) {
    Write-Host "[*] Creating Python virtual environment (.venv)..." -ForegroundColor Yellow
    python -m venv .venv
}

# 3. Install Requirements
Write-Host "[*] Installing required packages..." -ForegroundColor Yellow
& ".venv\Scripts\pip.exe" install -r api/requirements.txt

# 4. Open Browser
Write-Host "[*] Opening web dashboard..." -ForegroundColor Yellow
Start-Sleep -Seconds 1
Start-Process "http://localhost:8000"

# 5. Start Server
Write-Host "[+] Launching Flask Server on http://localhost:8000" -ForegroundColor Green
Write-Host "[+] Press Ctrl+C in this terminal to stop the server." -ForegroundColor Green
& ".venv\Scripts\python.exe" api/api.py
