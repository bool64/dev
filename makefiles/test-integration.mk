GO ?= go

# Override in app Makefile to add custom ldflags, example BUILD_LDFLAGS="-s -w"
BUILD_LDFLAGS ?= ""
INTEGRATION_TEST_TARGET ?= -coverpkg ./internal/... integration_test.go
INTEGRATION_DOCKER_COMPOSE ?= ./docker-compose.yml

## Run integration tests
test-integration:
	@make start-deps
	@echo "Running integration tests."
	@CGO_ENABLED=1 $(GO) test -ldflags "$(shell bash $(DEVGO_SCRIPTS)/version-ldflags.sh && echo $(BUILD_LDFLAGS))" -race -cover -coverprofile ./integration.coverprofile $(INTEGRATION_TEST_TARGET)

## Start dependencies for integration tests or local dev via docker-compose up
start-deps:
	@test ! -f $(INTEGRATION_DOCKER_COMPOSE) || docker-compose -p "$(shell basename $$PWD)" -f $(INTEGRATION_DOCKER_COMPOSE) up -d

## Stop dependencies for integration tests or local dev via docker-compose down
stop-deps:
	@test ! -f $(INTEGRATION_DOCKER_COMPOSE) || docker-compose -p "$(shell basename $$PWD)" -f $(INTEGRATION_DOCKER_COMPOSE) down

.PHONY: test-integration start-deps stop-deps
