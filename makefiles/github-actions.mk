GO ?= go

## Replace GitHub Actions from template
github-actions:
	@mkdir -p $(PWD)/.github/workflows && (chmod +w $(PWD)/.github/workflows/*.yml || echo "could not chmod +w existing workflows") \
		&& cp $(DEVGO_PATH)/templates/github/workflows/*.yml $(PWD)/.github/workflows/ \
		&& chmod +w $(PWD)/.github/workflows/*.yml && git add $(PWD)/.github/workflows \
		&& mkdir -p $(PWD)/.github/ISSUE_TEMPLATE && (chmod +w $(PWD)/.github/ISSUE_TEMPLATE/*.md || echo "could not chmod +w existing issue templates") \
		&& cp $(DEVGO_PATH)/templates/github/ISSUE_TEMPLATE/*.md $(PWD)/.github/ISSUE_TEMPLATE/ \
		&& chmod +w $(PWD)/.github/ISSUE_TEMPLATE/*.md && git add $(PWD)/.github/ISSUE_TEMPLATE \
		&& (test -z "$(BENCH_COUNT)" && rm $(PWD)/.github/workflows/bench.yml || echo "keeping bench.yml") \
		&& (test -z "$(RELEASE_TARGETS)" && rm $(PWD)/.github/workflows/release-assets.yml || echo "keeping release-assets.yml") \
		&& (test -z "$(INTEGRATION_TEST_TARGET)" && rm $(PWD)/.github/workflows/test-integration.yml || echo "keeping test-integration.yml") \
		&& /bin/bash $(DEVGO_PATH)/replace.sh

.PHONY: github-actions
