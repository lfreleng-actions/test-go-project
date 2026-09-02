// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2025 The Linux Foundation

module github.com/lfreleng-actions/test-go-project

go 1.25

// Deliberate, and load-bearing for consumers rather than for this
// project. It pins a patch distinct from the 'go' directive above,
// which resolves to the latest 1.25.x. Tooling reading this file
// must prefer 'toolchain' over 'go', and comparing the two
// resolutions is the only way to prove that it does. Removing this
// line, or raising it to match 'go', silently disables that check.
// See lfreleng-actions/security-workflows#75.
toolchain go1.25.0

require github.com/stretchr/testify v1.12.1

require go.yaml.in/yaml/v3 v3.0.5 // indirect
