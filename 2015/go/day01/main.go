package main

import (
	"bufio"
	"flag"
	"io"
	"log"
	"os"
)

// solution reads the input file and calculates the final floor based on the parentheses.
func solution(inputFile string) {
	// Open the input file
	file, err := os.Open(inputFile)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// Create a buffered reader to read the file
	reader := bufio.NewReader(file)

	var currentFloor int = 0

	// Read the file character by character
	for {
		char, _, err := reader.ReadRune()
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal(err)
		}

		if char == '(' {
			currentFloor++
		}
		if char == ')' {
			currentFloor--
		}
	}

	log.Printf("Current floor: %d", currentFloor)
}

// processArguments parses command-line flags and returns the input file path.
func processArguments() string {
	// if there are no command-line arguments, print usage and exit
	if len(os.Args) < 2 {
		log.Fatal("Usage: go run main.go -input-file <path_to_input_file>")
	}

	var inputFile string

	flag.StringVar(&inputFile, "input-file", "", "Path to the input file")
	flag.Parse()

	// if the input file flag is not provided, print usage and exit
	if inputFile == "" {
		log.Fatal("Please provide an input file using the -input-file or --input-file flag.")
	}

	return inputFile
}

// main is the entry point of the program. It parses command-line flags and calls the solution function.
func main() {
	inputFile := processArguments()

	log.Println("Advent of Code 2015 - Day 1")

	solution(inputFile)
}
