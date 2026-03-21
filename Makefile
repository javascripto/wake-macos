.PHONY: help build run dmg release clean

help:
	@printf '%s\n' "Available targets:"
	@printf '%s\n' "  make build    Build the .app bundle"
	@printf '%s\n' "  make run      Build and open the app"
	@printf '%s\n' "  make dmg      Build the .dmg package"
	@printf '%s\n' "  make release  Build the app and the .dmg"
	@printf '%s\n' "  make clean    Remove build artifacts"

build:
	@./scripts/build_app.sh

open:
	@open dist/Wake.app

run: build open

dmg:
	@./scripts/create_dmg.sh

zip:
	@ditto -c -k --sequesterRsrc --keepParent dist/Wake.app dist/Wake.app.zip

release: build dmg zip

tag:
	@./scripts/create_release_tag.sh $(TAG)

clean:
	@rm -rf .build dist
