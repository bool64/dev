GO ?= go

## Replace GitHub Actions from template
github-actions:
	@mkdir -p $(PWD)/.github/workflows && (chmod +w $(PWD)/.github/workflows/*.yml || echo "could not chmod +w existing workflows") \
		&& cp $(DEVGO_PATH)/templates/github/workflows/*.yml $(PWD)/.github/workflows/ \
		&& chmod +w $(PWD)/.github/workflows/*.yml && git add $(PWD)/.github/workflows \
		&& (test -z "$(BENCH_COUNT)" && rm $(PWD)/.github/workflows/bench.yml || echo "keeping bench.yml") \
		&& (test -z "$(RELEASE_TARGETS)" && rm $(PWD)/.github/workflows/release-assets.yml || echo "keeping release-assets.yml") \
		&& (test -z "$(INTEGRATION_TEST_TARGET)" && rm $(PWD)/.github/workflows/test-integration.yml || echo "keeping test-integration.yml")

.PHONY: github-actions
