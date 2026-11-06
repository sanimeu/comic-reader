# Run from the project root AFTER `flutter create .`
# Installs the device-info channel (used by Glass Quality auto-default) into MainActivity.kt,
# keeping whatever `package` line Flutter generated. Makes a .bak first.
$ErrorActionPreference = "Stop"
$kt = Get-ChildItem -Path "android\app\src\main\kotlin" -Recurse -Filter "MainActivity.kt" | Select-Object -First 1
if (-not $kt) { Write-Error "MainActivity.kt not found. Run 'flutter create .' first."; exit 1 }
$pkgLine = Get-Content $kt.FullName | Where-Object { $_ -match '^\s*package\s+' } | Select-Object -First 1
$snippet = Get-Content "platform_snippets\MainActivity_device_info.kt" -Raw
$body = ($snippet -split "`r?`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"
Copy-Item $kt.FullName "$($kt.FullName).bak" -Force
$text = $pkgLine + "`n`n" + $body
[System.IO.File]::WriteAllText($kt.FullName, $text, (New-Object System.Text.UTF8Encoding $false))
Write-Host "Patched $($kt.FullName) (backup: MainActivity.kt.bak)"
