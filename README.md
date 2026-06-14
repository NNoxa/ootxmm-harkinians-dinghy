# OoTxMM Harkinian's Dinghy

OoTxMM Harkinian's Dinghy is a crossover randomizer build that links Ship of Harkinian and 2 Ship 2 Harkinian into one shared OoT/MM seed.

This repository contains source, tools, docs, and shared asset metadata. ROMs and ROM-derived archives are not included.

## Setup Guide

1. Look under the Releases tab in GitHub.
2. Download the latest release zip.
3. The zip should have 5 folders: `ootxmm/`, `soh/`, `2ship/`, `mods/`, `roms/`.
4. Place your OoT and MM ROMs inside `roms/`.

Recommended test ROMs:

- OoT: `(EU)(Beta)(GameCube)(Debug)`
- MM: `(USA)`

Other ROMs may work, but these are the stability baseline used during development.

5. Enter `ootxmm/`.
6. Launch `ootxmm.exe`.

## Release Packaging

After a fresh clone, initialize the submodules and apply the local crossover submodule patches:

```powershell
git submodule update --init --recursive
powershell -ExecutionPolicy Bypass -File .\tools\Apply-SubmodulePatches.ps1
```

Build the release package with:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Build-ReleasePackage.ps1 -Version "v0.1.0"
```

The package is written under `build_out/`. Upload that zip as the GitHub Release asset.
