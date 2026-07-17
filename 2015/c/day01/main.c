/**
 * main.c
 * 
 * Advent of Code 2015 - Day 1
 * Created By: Samuel Stidham
 *
 * Compiled with: clang -std=c23 -Wall -Wextra -Wpedantic -Werror -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer main.c -o main
 *                gcc -std=c23 -Wall -Wextra -Wpedantic -Werror -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer main.c -o main
 */
#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void printUsage(char *programName) {
    fprintf(stderr, "Usage: %s -f <input_file>\n", programName);
    exit(EXIT_FAILURE);
}

char* processArguments(int argc, char *argv[]) {
    int opt;

    char *input_file = NULL;

    while ((opt = getopt(argc, argv, "f:")) != -1) {
        switch (opt) {
        case 'f':
            input_file = optarg;
            break;
        default: /* '?' */
            printUsage(argv[0]);
        }
    }

    if (input_file == NULL) {
        printUsage(argv[0]);
    }

    return input_file;
}

void solution(char *fileName) {
    int floor = 0;
    int ch;

    FILE *file = fopen(fileName, "r");
    if (file == NULL) {
        perror("Error reopening file");
        exit(EXIT_FAILURE);
    }

    while ((ch = fgetc(file)) != EOF) {
        if (ch == '(') {
            floor++;
        } else if (ch == ')') {
            floor--;
        }
    }

    fclose(file);

    printf("Final floor: %d\n", floor);
}

// main is the entry point of the program. It processes command-line arguments and prints the input file name.
int main(int argc, char *argv[]) {
    printf("Advent of Code 2015 - Day 1\n");

    char* fileName = processArguments(argc, argv);

    printf("Input file: %s\n", fileName);

    solution(fileName);

    return 0;
}