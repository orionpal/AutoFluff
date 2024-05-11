#!/bin/bash

# Change directory to the location of your Python file
cd C:/Users/13472/Desktop/AutoGitFluff/AutoFluff

# Define variables
PYTHON_FILE="function.py"
GITHUB_REPO="https://github.com/orionpal/AutoFluff.git"

# run file and get commit message
COMMIT_MESSAGE=$(python "$PYTHON_FILE")


# Add changes to git
git add .

# Commit changes
git commit -m "$COMMIT_MESSAGE"

# Push changes to GitHub
git push origin master
