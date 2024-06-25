#!/bin/bash

# Repository and log file paths
REPOSITORY_PATH=/Users/orionpal/Desktop/Projects/AutoFluff
LOG_FILE=$REPOSITORY_PATH/cron.log

# Navigate to GitHub repository
cd "$REPOSITORY_PATH" || { echo "[$(date)] Failed to navigate to repo" >> "$LOG_FILE"; exit 1; }

# Files containing words and definitions
WORDS_FILE=$REPOSITORY_PATH/words_file.txt
DICTIONARY_FILE=$REPOSITORY_PATH/dictionary_file.txt

# Count the number of lines in the file
line_count=$(wc -l < "$WORDS_FILE")

# Generate a random number between 1 and the number of lines
random_line=$((RANDOM % line_count + 1))

# Save random word
random_word=$(sed "${random_line}q;d" "$WORDS_FILE")

# Print the word at the random line
echo "[$(date)] Random word: $random_word" >> "$LOG_FILE"

# Convert the random word to uppercase
uppercase_word=$(echo "$random_word" | tr '[:lower:]' '[:upper:]')

# Find the line number of the uppercase word in the dictionary file
line_number=$(grep -n "^$uppercase_word$" "$DICTIONARY_FILE" | cut -d: -f1)

# If the word is found, search for "Defn:" and write the definition to a file
if [ -n "$line_number" ]; then
    # Get the lines from the dictionary starting from the word line and write the definition to a file
    tail -n +$line_number "$DICTIONARY_FILE" | awk '
    /Defn:/ {
        flag=1
        sub(/.*Defn: */, "")
        print > "'$REPOSITORY_PATH'/'$random_word.txt'"
        next
    }
    flag {
        if (/^$/) exit
        print >> "'$REPOSITORY_PATH'/'$random_word.txt'"
    }'
    echo "[$(date)] Definition for $random_word written to $REPOSITORY_PATH/$random_word.txt" >> "$LOG_FILE"
else
    # Remove the line from words.txt if the word is not found in the dictionary
    awk 'NR != '$random_line'' "$WORDS_FILE" > temp && mv temp "$WORDS_FILE"
    echo "[$(date)] Word not found in dictionary. Line removed from words.txt." >> "$LOG_FILE"
fi

# Git operations
git add . >> "$LOG_FILE" 2>&1
git commit -m "Did some stuff using $random_word" >> "$LOG_FILE" 2>&1
git push origin master >> "$LOG_FILE" 2>&1

echo "[$(date)] Script execution completed" >> "$LOG_FILE"
