DISTINATION_DIR := $(shell pwd)/dist

.PHONY: install generate

install:
	@echo "Installing the project..."
	npm install

generate:
	@echo "Generating the project..."
	ANYPOINT_GENERATOR_GO_DEST=$(DISTINATION_DIR) npx openapi-generator-cli generate
	@echo "Generated files are available in $(DISTINATION_DIR)"

