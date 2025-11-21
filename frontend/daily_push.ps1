# 1. Go to the project folder
$targetPath = "D:\HTML CSS JS (ALL)\SIGMA WEB DEVELOPMENT COURSE\ZERODHA (CLONE)\Zerodha"

# Check if the folder actually exists before trying to go there
if (Test-Path "$targetPath") {
    Set-Location "$targetPath"
    Write-Host "DEBUG: Successfully entered folder." -ForegroundColor Green
} else {
    Write-Host "ERROR: Folder not found! Check the path." -ForegroundColor Red
    Exit
}

# 2. Get the list of files (Force it to be an array using @())
$rawStatus = @(git status --porcelain)

if ($rawStatus.Count -eq 0) {
    Write-Host "No changed files found to upload." -ForegroundColor Yellow
    Exit
}

# 3. Process the first file
# Get the line, remove the first 3 chars (status code), and TRIM quotes if Git added them
$rawLine = $rawStatus[0]
$cleanFileName = $rawLine.Substring(3).Trim('"')

Write-Host "DEBUG: Found file to upload -> $cleanFileName" -ForegroundColor Cyan

# 4. Run Git Commands
try {
    git add "$cleanFileName"
    
    $date = Get-Date -Format "yyyy-MM-dd"
    git commit -m "Daily upload: $cleanFileName ($date)"
    
    git push origin main
    
    Write-Host "SUCCESS: Uploaded $cleanFileName" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Something went wrong during Git commands." -ForegroundColor Red
    Write-Host $_
}