GO ?= go

## Replace GitHub Actions from template
github-actions:
	@mkdir -p $(PWD)/.github/workflows && cp $(DEVGO_PATH)/templates/.github/workflows/*.yml $(PWD)/.github/workflows/ && git add $(PWD)/.github

.PHONY: github-actions
