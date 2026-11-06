# Dependency compatibility probe (throwaway project, separate from comic_reader).
# Adds every candidate package for ALL phases, then tries to resolve, analyze and BUILD for
# Windows and Android. "Builds" proves the native plugin code compiles on both targets.
# It does NOT prove runtime behaviour; that is verified when each feature is built and tested.
# Prereqs: Flutter, Visual Studio C++ workload, Android SDK, Windows Developer Mode ON (plugin symlinks).
param([string]$Root = "$HOME\dev\dep_probe")
$ErrorActionPreference = "Continue"
if (Test-Path $Root) { Remove-Item $Root -Recurse -Force }
flutter create $Root --platforms=windows,android --project-name dep_probe | Out-Null
Set-Location $Root

$results = @()
function Step([string]$Name, [scriptblock]$Cmd) {
  Write-Host "=== $Name ===" -ForegroundColor Cyan
  & $Cmd
  $code = $LASTEXITCODE
  $script:results += [pscustomobject]@{ Step = $Name; ExitCode = $code; Result = $(if ($code -eq 0) { "OK" } else { "FAILED" }) }
}

$pkgs = @("flutter_riverpod","drift","sqlite3_flutter_libs","path_provider","path","ffi","pdfrx","file_picker","window_manager","desktop_drop","logging")
$dev  = @("drift_dev","build_runner")
foreach ($p in $pkgs) { Step "add $p" { flutter pub add $p } }
foreach ($p in $dev)  { Step "add --dev $p" { flutter pub add --dev $p } }
Step "pub get"           { flutter pub get }
Step "analyze"           { flutter analyze }
Step "build windows"     { flutter build windows --debug }
Step "build apk"         { flutter build apk --debug }
flutter pub outdated > outdated.txt 2>&1
flutter pub deps --style=compact > deps.txt 2>&1

$results | Format-Table -AutoSize | Out-String | Tee-Object -FilePath probe_report.txt
Write-Host "Report: $Root\probe_report.txt  (also outdated.txt, deps.txt). Send me this report and any error text."
