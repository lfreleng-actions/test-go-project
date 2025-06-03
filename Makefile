# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2025 The Linux Foundation

# Makefile for test-go-project

BINARY_NAME=calculator
VERSION ?= dev
COMMIT ?= $(shell git rev-parse --short HEAD)
DATE ?= $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
LDFLAGS=-ldflags="-X main.version=$(VERSION) -X main.commit=$(COMMIT) -X main.date=$(DATE)"

# Build directory
BUILD_DIR=bin

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod

.PHONY: all build clean test deps lint fmt vet run help install cli-test audit

# Default target
all: clean deps build test

# Build the binary
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	$(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) .

# Build for multiple platforms
build-all:
	@echo "Building for multiple platforms..."
	@mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 .
	GOOS=darwin GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 .
	GOOS=darwin GOARCH=arm64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 .
	GOOS=windows GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe .

# Clean build artifacts
clean:
	@echo "Cleaning..."
	$(GOCLEAN)
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html

# Download dependencies
deps:
	@echo "Downloading dependencies..."
	$(GOMOD) download
	$(GOMOD) tidy

# Run tests
test:
	@echo "Running tests..."
	$(GOTEST) -v -race -coverprofile=coverage.out ./...

# Run tests with coverage report
test-coverage: test
	@echo "Generating coverage report..."
	$(GOCMD) tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report generated: coverage.html"

# Run integration tests
test-integration:
	@echo "Running integration tests..."
	$(GOTEST) -v -tags=integration ./...

# Run CLI tests
cli-test: build
	@echo "Running CLI tests..."
	@./$(BUILD_DIR)/$(BINARY_NAME) add 5 3 | grep -q "Result: 8.00" && echo "✓ Add test passed"
	@./$(BUILD_DIR)/$(BINARY_NAME) subtract 10 4 | grep -q "Result: 6.00" && echo "✓ Subtract test passed"
	@./$(BUILD_DIR)/$(BINARY_NAME) multiply 6 7 | grep -q "Result: 42.00" && echo "✓ Multiply test passed"
	@./$(BUILD_DIR)/$(BINARY_NAME) divide 15 3 | grep -q "Result: 5.00" && echo "✓ Divide test passed"
	@echo "All CLI tests passed!"

# Run linting
lint:
	@echo "Running linting..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "golangci-lint not found, installing..."; \
		go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest; \
		golangci-lint run; \
	fi

# Format code
fmt:
	@echo "Formatting code..."
	$(GOCMD) fmt ./...

# Run go vet
vet:
	@echo "Running go vet..."
	$(GOCMD) vet ./...

# Run security audit
audit:
	@echo "Running security audit..."
	@echo "Checking for vulnerabilities..."
	@if command -v govulncheck >/dev/null 2>&1; then \
		govulncheck ./...; \
	else \
		echo "govulncheck not found, installing..."; \
		go install golang.org/x/vuln/cmd/govulncheck@latest; \
		govulncheck ./...; \
	fi
	@echo "Running gosec..."
	@if command -v gosec >/dev/null 2>&1; then \
		gosec ./...; \
	else \
		echo "gosec not found, installing..."; \
		go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest; \
		gosec ./...; \
	fi
	@echo "Running staticcheck..."
	@if command -v staticcheck >/dev/null 2>&1; then \
		staticcheck ./...; \
	else \
		echo "staticcheck not found, installing..."; \
		go install honnef.co/go/tools/cmd/staticcheck@latest; \
		staticcheck ./...; \
	fi

# Install the binary
install: build
	@echo "Installing $(BINARY_NAME)..."
	@if [ -n "$(GOPATH)" ]; then \
		mkdir -p $(GOPATH)/bin && cp $(BUILD_DIR)/$(BINARY_NAME) $(GOPATH)/bin/$(BINARY_NAME); \
	elif [ -n "$(GOBIN)" ]; then \
		mkdir -p $(GOBIN) && cp $(BUILD_DIR)/$(BINARY_NAME) $(GOBIN)/$(BINARY_NAME); \
	else \
		mkdir -p $(HOME)/go/bin && cp $(BUILD_DIR)/$(BINARY_NAME) $(HOME)/go/bin/$(BINARY_NAME); \
	fi
	@echo "$(BINARY_NAME) installed successfully"

# Install system-wide (requires sudo on most systems)
install-system: build
	@echo "Installing $(BINARY_NAME) system-wide..."
	@if [ "$(shell uname)" = "Darwin" ]; then \
		sudo cp $(BUILD_DIR)/$(BINARY_NAME) /usr/local/bin/$(BINARY_NAME); \
	else \
		sudo cp $(BUILD_DIR)/$(BINARY_NAME) /usr/bin/$(BINARY_NAME); \
	fi
	@echo "$(BINARY_NAME) installed system-wide successfully"

# Uninstall the binary
uninstall:
	@echo "Uninstalling $(BINARY_NAME)..."
	@rm -f $(GOPATH)/bin/$(BINARY_NAME) $(GOBIN)/$(BINARY_NAME) $(HOME)/go/bin/$(BINARY_NAME)
	@echo "$(BINARY_NAME) uninstalled successfully"

# Uninstall system-wide
uninstall-system:
	@echo "Uninstalling $(BINARY_NAME) system-wide..."
	@if [ "$(shell uname)" = "Darwin" ]; then \
		sudo rm -f /usr/local/bin/$(BINARY_NAME); \
	else \
		sudo rm -f /usr/bin/$(BINARY_NAME); \
	fi
	@echo "$(BINARY_NAME) uninstalled system-wide successfully"

# Run the application
run: build
	@echo "Running $(BINARY_NAME) (try: make run ARGS='add 5 3')"
	@if [ -n "$(ARGS)" ]; then \
		./$(BUILD_DIR)/$(BINARY_NAME) $(ARGS); \
	else \
		./$(BUILD_DIR)/$(BINARY_NAME); \
	fi

# Development setup
dev-setup:
	@echo "Setting up development environment..."
	$(GOGET) -u github.com/golangci/golangci-lint/cmd/golangci-lint
	$(GOGET) -u golang.org/x/vuln/cmd/govulncheck
	$(GOGET) -u github.com/securecodewarrior/gosec/v2/cmd/gosec
	$(GOGET) -u honnef.co/go/tools/cmd/staticcheck
	$(GOMOD) tidy

# Benchmark tests
benchmark:
	@echo "Running benchmarks..."
	$(GOTEST) -bench=. -benchmem ./...

# Docker build
docker-build:
	@echo "Building Docker image..."
	docker build -t $(BINARY_NAME):$(VERSION) .

# Release preparation
release-prep: clean deps fmt vet lint audit test build-all cli-test
	@echo "Release preparation complete"

# Quick quality check
check: fmt vet lint test
	@echo "Quality check complete"

# Demo the calculator
demo: build
	@echo "Calculator Demo:"
	@echo "================"
	@echo "Addition: 5 + 3 ="
	@./$(BUILD_DIR)/$(BINARY_NAME) add 5 3
	@echo ""
	@echo "Subtraction: 10 - 4 ="
	@./$(BUILD_DIR)/$(BINARY_NAME) subtract 10 4
	@echo ""
	@echo "Multiplication: 6 × 7 ="
	@./$(BUILD_DIR)/$(BINARY_NAME) multiply 6 7
	@echo ""
	@echo "Division: 15 ÷ 3 ="
	@./$(BUILD_DIR)/$(BINARY_NAME) divide 15 3

# Help
help:
	@echo "Available targets:"
	@echo "  all           - Clean, download deps, build, and test"
	@echo "  build         - Build the binary"
	@echo "  build-all     - Build for multiple platforms"
	@echo "  clean         - Clean build artifacts"
	@echo "  deps          - Download dependencies"
	@echo "  test          - Run tests"
	@echo "  test-coverage - Run tests with coverage report"
	@echo "  test-integration - Run integration tests"
	@echo "  cli-test      - Run CLI tests"
	@echo "  lint          - Run linting"
	@echo "  fmt           - Format code"
	@echo "  vet           - Run go vet"
	@echo "  audit         - Run security audit (govulncheck, gosec, staticcheck)"
	@echo "  install       - Install the binary to Go bin path"
	@echo "  install-system - Install the binary system-wide (requires sudo)"
	@echo "  uninstall     - Uninstall the binary"
	@echo "  uninstall-system - Uninstall the binary system-wide (requires sudo)"
	@echo "  run           - Build and run the application (use ARGS='...' for arguments)"
	@echo "  dev-setup     - Set up development environment"
	@echo "  benchmark     - Run benchmark tests"
	@echo "  docker-build  - Build Docker image"
	@echo "  release-prep  - Prepare for release"
	@echo "  check         - Quick quality check (fmt, vet, lint, test)"
	@echo "  demo          - Run calculator demo"
	@echo "  help          - Show this help"
	@echo ""
	@echo "Examples:"
	@echo "  make run ARGS='add 5 3'        - Run calculator with add operation"
	@echo "  make run ARGS='divide 10 2'    - Run calculator with divide operation"
	@echo "  make VERSION=1.0.0 build       - Build with specific version"
