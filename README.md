<!--
SPDX-License-Identifier: Apache-2.0
SPDX-FileCopyrightText: 2025 The Linux Foundation
-->

# Test Go Project

This is a sample Go project used for testing GitHub Actions for Go projects.

## Features

- Simple calculator package with basic arithmetic operations
- Command-line interface
- Unit tests with testify
- Go modules support

## Usage

```bash
# Run the calculator
go run main.go add 5 3
go run main.go subtract 10 4
go run main.go multiply 6 7
go run main.go divide 15 3
```

## Testing

```bash
# Run tests
go test ./...

# Run tests with coverage
go test -v -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

## Building

```bash
# Build the binary
go build -o calculator main.go
```

## Dependencies

- Go 1.21+
- github.com/stretchr/testify for testing
