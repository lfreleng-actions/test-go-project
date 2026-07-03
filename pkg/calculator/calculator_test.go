// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Linux Foundation

package calculator

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAdd(t *testing.T) {
	calc := New()
	assert.InDelta(t, 5.0, calc.Add(2, 3), 1e-9)
	assert.InDelta(t, -1.0, calc.Add(2, -3), 1e-9)
	assert.InDelta(t, 0.0, calc.Add(0, 0), 1e-9)
}

func TestSubtract(t *testing.T) {
	calc := New()
	assert.InDelta(t, -1.0, calc.Subtract(2, 3), 1e-9)
	assert.InDelta(t, 5.0, calc.Subtract(2, -3), 1e-9)
}

func TestMultiply(t *testing.T) {
	calc := New()
	assert.InDelta(t, 6.0, calc.Multiply(2, 3), 1e-9)
	assert.InDelta(t, 0.0, calc.Multiply(2, 0), 1e-9)
	assert.InDelta(t, -6.0, calc.Multiply(2, -3), 1e-9)
}

func TestDivide(t *testing.T) {
	calc := New()
	result, err := calc.Divide(6, 3)
	require.NoError(t, err)
	assert.InDelta(t, 2.0, result, 1e-9)

	_, err = calc.Divide(1, 0)
	require.ErrorIs(t, err, ErrDivisionByZero)
}
