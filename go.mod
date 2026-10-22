// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2025 The Linux Foundation

module github.com/lfreleng-actions/test-go-project

go 1.26.0

// Deliberate, and load-bearing for consumers rather than for this
// project. It pins a later patch than the 'go' directive above, which
// resolves to 1.26.0; this resolves to 1.26.10. Tooling reading this
// file must prefer 'toolchain' over 'go', and comparing the two
// resolutions is the only way to prove that it does. Removing this
// line, or setting it to the release 'go' resolves to, silently
// disables that check. Keep 'toolchain' on the newest patch of a
// supported release line, and on the same line as 'go': golangci-lint
// targets the 'toolchain' release, so a newer line here would demand
// a linter built with that newer Go.
// See lfreleng-actions/security-workflows#75.
toolchain go1.26.10

require github.com/stretchr/testify v1.12.1

require go.yaml.in/yaml/v3 v3.0.5 // indirect
