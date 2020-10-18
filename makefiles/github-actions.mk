GO ?= go

## Replace GitHub Actions from template
github-actions:
Update 	@mkdir -p $(PWD)/.github/workflows && chmod +w $(PWD)/.github/workflows/*.yml && cp $(DEVGO_PATH)/templates/.github/workflows/*.yml $(PWD)/.github/workflows/ && chmod +w $(PWD)/.github/workflows/*.yml && git add $(PWD)/.github

.PHONY: github-actions
