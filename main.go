// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2025 The Linux Foundation

package main

import (
	"fmt"
	"os"

	"github.com/lfreleng-actions/test-go-project/pkg/calculator"
)

func main() {
	if len(os.Args) < 4 {
		fmt.Println("Usage: go run main.go <operation> <num1> <num2>")
		fmt.Println("Operations: add, subtract, multiply, divide")
		os.Exit(1)
	}

	operation := os.Args[1]
	var a, b float64
	if _, err := fmt.Sscanf(os.Args[2], "%f", &a); err != nil {
		fmt.Printf("Error parsing first number: %v\n", err)
		os.Exit(1)
	}
	if _, err := fmt.Sscanf(os.Args[3], "%f", &b); err != nil {
		fmt.Printf("Error parsing second number: %v\n", err)
		os.Exit(1)
	}

	calc := calculator.New()
	var result float64
	var err error

	switch operation {
	case "add":
		result = calc.Add(a, b)
	case "subtract":
		result = calc.Subtract(a, b)
	case "multiply":
		result = calc.Multiply(a, b)
	case "divide":
		result, err = calc.Divide(a, b)
		if err != nil {
			fmt.Printf("Error: %v\n", err)
			os.Exit(1)
		}
	default:
		fmt.Printf("Unknown operation: %s\n", operation)
		os.Exit(1)
	}

	fmt.Printf("Result: %.2f\n", result)
}
