// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Linux Foundation

// Package calculator provides basic arithmetic operations.
package calculator

import "errors"

// ErrDivisionByZero reports an attempt to divide by zero.
var ErrDivisionByZero = errors.New("division by zero")

// Calculator performs basic arithmetic operations.
type Calculator struct{}

// New returns a Calculator ready for use.
func New() *Calculator { return &Calculator{} }

// Add returns the sum of a and b.
func (c *Calculator) Add(a, b float64) float64 { return a + b }

// Subtract returns a minus b.
func (c *Calculator) Subtract(a, b float64) float64 { return a - b }

// Multiply returns the product of a and b.
func (c *Calculator) Multiply(a, b float64) float64 { return a * b }

// Divide returns a divided by b, or an error when b is zero.
func (c *Calculator) Divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, ErrDivisionByZero
	}
	return a / b, nil
}
