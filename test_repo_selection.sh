#!/bin/bash

# Quick test script to verify repository selection logic
# This script simulates the repository selection without installing anything

source /home/sam/picar-x-setup/setup_picar_x.sh

# Test functions by calling them directly
echo "Testing repository selection logic..."
echo

echo "Test 1: Custom fork (--custom-fork)"
choose_picar_x_repo "--custom-fork"
echo "Selected: $PICAR_X_REPO (branch: $PICAR_X_BRANCH)"
echo

echo "Test 2: Official repository (--official)"
choose_picar_x_repo "--official"
echo "Selected: $PICAR_X_REPO (branch: $PICAR_X_BRANCH)"
echo

echo "Test 3: Short form custom (-c)"
choose_picar_x_repo "-c"
echo "Selected: $PICAR_X_REPO (branch: $PICAR_X_BRANCH)"
echo

echo "Test 4: Short form official (-o)"
choose_picar_x_repo "-o"
echo "Selected: $PICAR_X_REPO (branch: $PICAR_X_BRANCH)"
echo

echo "All tests completed!"