# Wake

Wake is a tiny macOS menu bar app that keeps your Mac awake while it is enabled.

It uses native macOS power assertions, ships as a menu bar utility, and includes a custom app icon in the `.app` bundle.

Portuguese version: [README.pt-BR.md](./README.pt-BR.md)

## How it works

Instead of shelling out to `caffeinate`, the app uses native macOS power management assertions through `IOKit`:

- `PreventUserIdleSystemSleep`
- `PreventUserIdleDisplaySleep`

When Wake is active, the menu bar icon switches to the enabled state. When disabled, it releases the assertions and the Mac returns to its normal sleep behavior.

The app bundle also contains a custom `Wake.icns` icon, while the status item in the menu bar still uses SF Symbols in template mode.

## Local development

Build the executable:

```bash
swift build
```

Build the `.app` bundle:

```bash
./scripts/build_app.sh
```

That script:

- builds the release executable
- generates `dist/Wake.app`
- creates `Wake.icns` only when it is missing or when `scripts/generate_app_icon.swift` changed
- copies the icon into `Wake.app/Contents/Resources`
- applies an ad-hoc signature when `codesign` is available

Create the `.dmg`:

```bash
./scripts/create_dmg.sh
```

Or use `make` shortcuts:

```bash
make build
make run
make dmg
make release
```

## Release flow

The GitHub Actions workflow builds the app on macOS and:

- creates `Wake.app`
- creates `Wake.dmg`
- creates `Wake.app.zip`
- uploads build artifacts
- publishes a GitHub Release when you push a tag like `v1.0.0`

## Notes

- The app runs as a menu bar utility and does not show a Dock icon.
- The app bundle icon is generated from `scripts/generate_app_icon.swift`.
- The menu bar status item still uses SF Symbols in template mode, so it stays monochrome in the menu bar.
- The generated app is ad-hoc signed locally for easier distribution and packaging.
- If you want to force a fresh icon build, delete `.build/app-icon/Wake.icns` and run `./scripts/build_app.sh` again.
