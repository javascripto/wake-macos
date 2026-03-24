.PHONY: help build run dmg release clean tag create_release_tag

help:
	@printf '%s\n' "Available targets:"
	@printf '%s\n' "  make build    Build the .app bundle"
	@printf '%s\n' "  make run      Build and open the app"
	@printf '%s\n' "  make dmg      Build the .dmg package"
	@printf '%s\n' "  make release  Build the app and the .dmg"
	@printf '%s\n' "  make tag VERSION=1.2.3            Create and push v1.2.3"
	@printf '%s\n' "  make create_release_tag VERSION=1.2.3  Alias for make tag"
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

tag create_release_tag:
	@test -n "$(VERSION)" || (printf '%s\n' "Usage: make $@ VERSION=1.2.3" && exit 1)
	@./scripts/create_release_tag.sh $(VERSION)

clean:
	@rm -rf .build dist
