DESTINATION_DIR := $(shell pwd)/dest

.PHONY: install generate

install:
	@echo "Installing the project..."
	npm install

generate:
	@echo "Generating the project..."
	ANYPOINT_GENERATOR_GO_DEST=$(DESTINATION_DIR) npx openapi-generator-cli generate
	@echo "Generated files are available in $(DESTINATION_DIR)"

