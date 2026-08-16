# Gemz
Long description (copy-paste for README or longer repo description) Gemz is an experimental toolkit for packaging driver bundles (Wi‑Fi, audio) and producing safe, versioned installer artifacts for Intel-based Macs (T1 models). Gemz focuses on Broadcom Wi‑Fi and common audio codecs, and provides a developer-friendly CLI to build driver packages, validate manifests, simulate flashing, and create local installer artifacts that represent a partition or USB drive (non-destructive).

Features

Driver manifest schema (YAML) for vendor/chipset metadata and upstream links
CLI commands: pack, validate, simulate-flash, make-installer (local artifact)
Support scaffolding for Broadcom Wi‑Fi and common audio codecs; add your own hardware manifests
“Powered by AI” branding and developer-focused tooling, not device-level installers
Important legal & safety notice Gemz does not provide macOS installers or instructions to bypass firmware/security protections (T2/secure-boot, etc.). Use only on hardware you legally own. Gemz bundles metadata and links to upstream sources; proprietary binaries must be supplied by the user and only redistributed with permission.

Quick usage examples

Pack a manifest: python -m gemz pack examples/example-manifest.yaml --out bundles/packages/gemz-package.json
Validate a package: python -m gemz validate --package bundles/packages/gemz-package.json
Simulate a flash (dry-run): python -m gemz simulate-flash --package bundles/packages/gemz-package.json --target examples/example-manifest.yaml
Create a simulated installer folder: python -m gemz make-installer --package bundles/packages/gemz-package.json --output-dir ./simulated-usb

