param(
    [string]$Version = "dev"
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$stage = Join-Path $root "build_out\ootxmm-harkinians-dinghy-$Version"
$zip = "$stage.zip"

if (Test-Path $stage) {
    Remove-Item -LiteralPath $stage -Recurse -Force
}
if (Test-Path $zip) {
    Remove-Item -LiteralPath $zip -Force
}

New-Item -ItemType Directory -Force -Path `
    (Join-Path $stage "ootxmm"), `
    (Join-Path $stage "soh\mods\OoTxMM"), `
    (Join-Path $stage "2ship\mods\OoTxMM"), `
    (Join-Path $stage "mods"), `
    (Join-Path $stage "roms") | Out-Null

Copy-Item -LiteralPath (Join-Path $root "crossover_launcher\bin\Release\net9.0-windows\win-x64\publish\SoH2ShipCrossover.exe") `
    -Destination (Join-Path $stage "ootxmm\ootxmm.exe") -Force

Copy-Item -LiteralPath (Join-Path $root "source files\Shipwright-9.2.3\x64\Release\soh.exe") `
    -Destination (Join-Path $stage "soh\soh.exe") -Force
Copy-Item -LiteralPath (Join-Path $root "extracted_win\soh\soh.o2r") `
    -Destination (Join-Path $stage "soh\soh.o2r") -Force
Copy-Item -LiteralPath (Join-Path $root "extracted_win\soh\gamecontrollerdb.txt") `
    -Destination (Join-Path $stage "soh\gamecontrollerdb.txt") -Force
Copy-Item -LiteralPath (Join-Path $root "extracted_win\soh\readme.txt") `
    -Destination (Join-Path $stage "soh\readme.txt") -Force

Copy-Item -LiteralPath (Join-Path $root "source files\2ship2harkinian-4.0.2\x64\Release\2ship.exe") `
    -Destination (Join-Path $stage "2ship\2ship.exe") -Force
Copy-Item -LiteralPath (Join-Path $root "extracted_win\2ship\2ship.o2r") `
    -Destination (Join-Path $stage "2ship\2ship.o2r") -Force
Copy-Item -LiteralPath (Join-Path $root "extracted_win\2ship\gamecontrollerdb.txt") `
    -Destination (Join-Path $stage "2ship\gamecontrollerdb.txt") -Force
Copy-Item -LiteralPath (Join-Path $root "extracted_win\2ship\readme.txt") `
    -Destination (Join-Path $stage "2ship\readme.txt") -Force
Copy-Item -LiteralPath (Join-Path $root "extracted_win\2ship\2S2HTimeSplitData.json") `
    -Destination (Join-Path $stage "2ship\2S2HTimeSplitData.json") -Force

$assetRoot = Join-Path $root "shared_assets\ootxmm"
Copy-Item -LiteralPath (Join-Path $assetRoot "ootxmm_assets.o2r") `
    -Destination (Join-Path $stage "soh\mods\ootxmm_assets.o2r") -Force
Copy-Item -LiteralPath (Join-Path $assetRoot "ootxmm_assets.o2r") `
    -Destination (Join-Path $stage "2ship\mods\ootxmm_assets.o2r") -Force
Copy-Item -LiteralPath (Join-Path $assetRoot "manifest.ootxmm-assets.json") `
    -Destination (Join-Path $stage "soh\mods\OoTxMM\manifest.ootxmm-assets.json") -Force
Copy-Item -LiteralPath (Join-Path $assetRoot "manifest.ootxmm-assets.json") `
    -Destination (Join-Path $stage "2ship\mods\OoTxMM\manifest.ootxmm-assets.json") -Force

@'
{
  "sohExe": "soh/soh.exe",
  "twoShipExe": "2ship/2ship.exe",
  "stateFile": "crossover_state.json",
  "handoffFile": "crossover_handoff.json",
  "pollMilliseconds": 250,
  "gracefulExitMilliseconds": 5000
}
'@ | Set-Content -LiteralPath (Join-Path $stage "crossover_launcher.json") -Encoding ascii

@'
Put your legally obtained ROMs here.

Recommended test ROMs:
- OoT: (EU)(Beta)(GameCube)(Debug)
- MM:  (USA)

ROMs and ROM-derived .o2r archives are not included with this release.
'@ | Set-Content -LiteralPath (Join-Path $stage "roms\README.txt") -Encoding ascii

@'
Optional top-level mod drop folder.

OoTxMM's required shared asset pack is already included inside:
- soh/mods/
- 2ship/mods/

Do not put ROMs here.
'@ | Set-Content -LiteralPath (Join-Path $stage "mods\README.txt") -Encoding ascii

@'
SETUP GUIDE:

  1. Look under the Releases tab in GitHub (right hand side)
  2. Download the latest release zip
  3. This zip should have 5 folders: ootxmm/, soh/, 2ship/, mods/, roms/
  4. Place your OoT & MM ROMs inside of roms/
  ROMs I use:
    - OoT: (EU)(Beta)(GameCube)(Debug)
    - MM:  (USA)
    - Not saying this will not work with different ROMs, but to ensure greatest stability, use these

  5. Enter ootxmm/
  6. Find ootxmm.exe

Done.
'@ | Set-Content -LiteralPath (Join-Path $stage "SETUP_GUIDE.txt") -Encoding ascii

Compress-Archive -LiteralPath `
    (Join-Path $stage "ootxmm"), `
    (Join-Path $stage "soh"), `
    (Join-Path $stage "2ship"), `
    (Join-Path $stage "mods"), `
    (Join-Path $stage "roms"), `
    (Join-Path $stage "crossover_launcher.json"), `
    (Join-Path $stage "SETUP_GUIDE.txt") `
    -DestinationPath $zip -CompressionLevel Optimal

Write-Host "Release package staged at: $stage"
Write-Host "Release zip created at: $zip"
