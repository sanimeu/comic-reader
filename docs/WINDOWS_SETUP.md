# Windows setup and first compile (PowerShell)

Run PowerShell as a normal user unless a step says otherwise. Skip any tool you already have.
**These commands are untested by me (no Windows machine here). Report anything that fails verbatim.**

## A. Prerequisites (one time)
```powershell
winget install -e --id Git.Git
winget install -e --id Google.AndroidStudio
winget install -e --id Microsoft.VisualStudio.2022.Community --override "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --passive"

# Flutter SDK (stable channel)
New-Item -ItemType Directory -Force "$HOME\dev" | Out-Null
git clone https://github.com/flutter/flutter.git -b stable "$HOME\dev\flutter"
$old = [Environment]::GetEnvironmentVariable("Path","User")
[Environment]::SetEnvironmentVariable("Path", "$old;$HOME\dev\flutter\bin", "User")
```
Close and reopen PowerShell, then:
```powershell
start ms-settings:developers          # turn ON "Developer Mode" (needed for plugin symlinks)
```
Open Android Studio once: *More Actions > SDK Manager > SDK Tools*, tick **Android SDK Command-line Tools** and **NDK (Side by side)**, Apply. Then:
```powershell
flutter doctor --android-licenses     # accept all
flutter doctor -v                     # Windows + Android toolchain must be green; paste me any red items
```
Optional later: `Python 3` and `7-Zip` for the archive spike tools.

## B. Unpack and create the platform folders
```powershell
Expand-Archive "$HOME\Downloads\comic_reader_scaffold_v2.zip" -DestinationPath "$HOME\dev" -Force
cd "$HOME\dev\comic_reader"
git init
git add .
git commit -m "scaffold v2 before flutter create"
flutter create . --platforms=windows,android --project-name comic_reader --org com.joe.comicreader
# flutter create adds a default counter test that references MyApp and would fail analyze; remove it:
Remove-Item test\widget_test.dart -ErrorAction SilentlyContinue
git status --short                    # pubspec.yaml / lib\ / test\ must NOT show as modified; tell me if they do
```

## C. Android channel snippet (Glass Quality auto-default)
```powershell
powershell -ExecutionPolicy Bypass -File tools\apply_android_snippet.ps1
```

## D. Compile and test (this is the real verification)
```powershell
flutter pub get
flutter analyze                       # paste ALL output to me, even warnings
flutter test                          # 47 tests expected by source count (never run by me): paste output, including any failures
flutter run -d windows                # the glass dashboard should appear (Design Preview: Settings > Open)
flutter build apk --debug             # proves the Android build compiles
flutter devices                       # plug in phone with USB debugging on
flutter run -d <device-id>            # dashboard on Android
```
After the first clean `pub get`, tighten versions and record them:
```powershell
dart pub upgrade --tighten
git add pubspec.yaml pubspec.lock ; git commit -m "pin resolved versions"
```

## E. Dependency compatibility probe (separate throwaway project)
```powershell
powershell -ExecutionPolicy Bypass -File tools\dep_probe\run_probe.ps1
```
Send me `probe_report.txt` and any failure text. Packages that fail on either platform are replaced before they enter the real pubspec.

## F. What to look at in the dashboard
1. Glass panels blur the ambient background (accent bloom top-left, charcoal light bottom-right); bright top-left border fading to faint.
2. Settings > Glass quality High / Low: Low shows no blur but still looks like deliberate translucent panels.
3. Radii: major panels about 24 px, cards about 16 px. Accent #8B6CF6 on progress bars, selected nav, hero glow.
4. Resize the Windows window across 700 px and 1100 px: bottom nav < 700, sidebar from 700, right panel from 1100. On Android check portrait and landscape.
5. Library: search, type / status / Favourites-only chips, sort menu, grid/list toggle; on narrow widths the filter button opens a bottom sheet.
6. Heart on a card toggles a favourite (in memory only; resets on restart).
7. Everything shown is fictional sample data (badge top right). Resume / card taps say the reader is not built yet; that is expected.
8. Note anything that looks like an "ordinary grey card" or any overflow stripe so it can be fixed.
