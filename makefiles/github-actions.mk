GO ?= go

## Replace GitHub Actions from template
github-actions:
	@rm -rf $(PWD)/.github && cp -r $(DEVGO_PATH)/templates/.github $(PWD)/ && rm -f $(PWD)/.github/workflows/doc.go && git add $(PWD)/.github

.PHONY: github-actions
