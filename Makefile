# =============================================================================
# Advent of Code — solution runner
# =============================================================================
# Build and/or run a single day's solution in a chosen language.
#
#   make run   YEAR=2015 DAY=1 LANG=c        # compile (to build/) and run
#   make run   YEAR=2015 DAY=1 LANG=go
#   make run   YEAR=2015 DAY=1 LANG=c CC=gcc  # pick the C compiler
#   make build YEAR=2015 DAY=1 LANG=c        # compile only (compiled languages)
#   make clean                                # remove the build/ directory
#
# DAY accepts 1 or 01. Compiled languages emit their binary under build/
# (which is git-ignored); interpreted languages run straight from source.
# =============================================================================

# ---- Parameters (override on the command line) ------------------------------
YEAR ?=
DAY  ?=
LANG ?=

# C/C++ compilers. Make predefines CC/CXX, so only default to clang when the
# user hasn't overridden them (via the command line or environment).
ifeq ($(origin CC),default)
  CC := clang          # C compiler: clang or gcc (override: make ... CC=gcc)
endif
ifeq ($(origin CXX),default)
  CXX := clang++
endif

# C flags mirror the ones documented at the top of the .c solutions.
CFLAGS ?= -std=c23 -Wall -Wextra -Wpedantic -Werror -O1 -g \
          -fsanitize=address,undefined -fno-omit-frame-pointer

CXXFLAGS ?= -std=c++23 -Wall -Wextra -Wpedantic -Werror -O1 -g \
            -fsanitize=address,undefined -fno-omit-frame-pointer

# ---- Derived paths ----------------------------------------------------------
# Zero-pad DAY (1 -> 01) via awk so both "1" and "01" resolve to day01/
# (awk treats the value as a decimal number, avoiding shell octal pitfalls).
DAY2   := $(shell awk 'BEGIN{printf "%02d", $(DAY)+0}' 2>/dev/null)
SRCDIR := $(YEAR)/$(LANG)/day$(DAY2)
INPUT  := $(YEAR)/inputs/day$(DAY2)/input.txt
OUTDIR := build/$(YEAR)/$(LANG)/day$(DAY2)
BIN    := $(OUTDIR)/main

# ---- Per-language configuration ---------------------------------------------
# For each language define:
#   SRC        source file to build/run
#   COMPILED   1 if it must be compiled first (emits to build/), empty otherwise
#   build_cmd  how to compile (compiled languages only)
#   run_cmd    how to run it, passing the puzzle input
#
# NOTE: run_cmd must match how that day's program takes its input. C uses
# `-f` and Go uses `-input-file`; the others below pass the path positionally
# — adjust the flag to match your solution when you add one.
ifeq ($(LANG),c)
  SRC       := $(SRCDIR)/main.c
  COMPILED  := 1
  build_cmd  = $(CC) $(CFLAGS) $(SRC) -o $(BIN)
  run_cmd    = ./$(BIN) -f $(INPUT)
else ifeq ($(LANG),cpp)
  SRC       := $(SRCDIR)/main.cpp
  COMPILED  := 1
  build_cmd  = $(CXX) $(CXXFLAGS) $(SRC) -o $(BIN)
  run_cmd    = ./$(BIN) $(INPUT)
else ifeq ($(LANG),go)
  SRC       := $(SRCDIR)/main.go
  COMPILED  := 1
  build_cmd  = go build -o $(BIN) $(SRC)
  run_cmd    = ./$(BIN) -input-file $(INPUT)
else ifeq ($(LANG),rust)
  SRC       := $(SRCDIR)/main.rs
  COMPILED  := 1
  build_cmd  = rustc -O -o $(BIN) $(SRC)
  run_cmd    = ./$(BIN) $(INPUT)
else ifeq ($(LANG),python)
  SRC       := $(SRCDIR)/solution.py
  run_cmd    = python3 $(SRC) $(INPUT)
else ifeq ($(LANG),ruby)
  SRC       := $(SRCDIR)/solution.rb
  run_cmd    = ruby $(SRC) $(INPUT)
else ifeq ($(LANG),php)
  SRC       := $(SRCDIR)/solution.php
  run_cmd    = php $(SRC) $(INPUT)
endif

# ---- Targets ----------------------------------------------------------------
.DEFAULT_GOAL := help
.PHONY: help run build clean check

help:
	@echo "Advent of Code — solution runner"
	@echo
	@echo "Usage:"
	@echo "  make run   YEAR=<yyyy> DAY=<n> LANG=<lang>   compile (if needed) and run"
	@echo "  make build YEAR=<yyyy> DAY=<n> LANG=<lang>   compile only"
	@echo "  make clean                                   remove build/"
	@echo
	@echo "Examples:"
	@echo "  make run YEAR=2015 DAY=1 LANG=c"
	@echo "  make run YEAR=2015 DAY=1 LANG=go"
	@echo "  make run YEAR=2015 DAY=1 LANG=c CC=gcc"

check:
	@test -n "$(YEAR)" || { echo "Error: set YEAR (e.g. YEAR=2015)"; exit 1; }
	@test -n "$(DAY)"  || { echo "Error: set DAY (e.g. DAY=1)"; exit 1; }
	@test -n "$(LANG)" || { echo "Error: set LANG (e.g. LANG=c)"; exit 1; }
	@test -n "$(SRC)"  || { echo "Error: unsupported LANG='$(LANG)'"; exit 1; }
	@test -f "$(SRC)"  || { echo "Error: no source at $(SRC)"; exit 1; }

build: check
ifeq ($(COMPILED),1)
	@mkdir -p $(OUTDIR)
	$(build_cmd)
else
	@echo "$(LANG): interpreted language, nothing to compile."
endif

run: build
	@test -f "$(INPUT)" || { echo "Error: missing input $(INPUT)"; exit 1; }
	$(run_cmd)

clean:
	@rm -rf build
	@echo "Removed build/"
