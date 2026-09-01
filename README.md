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

- Go 1.25+
- github.com/stretchr/testify for testing

## Fixture properties

Some of what this repository declares exists for the workflows that
scan it rather than for the project itself. Please do not "tidy" these
away.

- **`go.mod` carries a `toolchain` directive pinned below the `go`
  directive's resolution.** `go 1.25` resolves to the latest 1.25.x,
  while `toolchain go1.25.0` resolves to exactly 1.25.0. Tooling that
  reads `go.mod` must prefer `toolchain`, and consumers can only prove
  they do by comparing which of the two they ended up with. Raising
  the pin to match the `go` directive, or dropping the line as
  redundant, silently disables that check.
  See [security-workflows#75][sw75].

[sw75]: https://github.com/lfreleng-actions/security-workflows/issues/75
