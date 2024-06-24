
# Navigate to GitHub repository
cd /Users/orionpal/Desktop/Projects/AutoFluff || { echo "Failed to navigate to repo" >> ~/daily_github_update.log; exit 1; }

# Files containing words and definitions
WORDS_FILE=words.txt
DICTIONARY_FILE=dictionary.txt

# Count the number of lines in the file
line_count=$(wc -l < $WORDS_FILE)

# Generate a random number between 1 and the number of lines
random_line=$((RANDOM % line_count + 1))
# Save random word
random_word=$(sed "${random_line}q;d" $WORDS_FILE)
# Print the word at the random line
echo $random_word

# Convert the random word to uppercase
uppercase_word=$(echo $random_word | tr '[:lower:]' '[:upper:]')

# Find the line number of the uppercase word in the dictionary file
line_number=$(grep -n "^$uppercase_word$" $DICTIONARY_FILE | cut -d: -f1)
# If the word is found, search for "Defn:" and write the definition to a file
if [ -n "$line_number" ]; then
    # Get the lines from the dictionary starting from the word line and write the definition to a file
    tail -n +$line_number $DICTIONARY_FILE | awk '
    /Defn:/ {
        flag=1
        sub(/.*Defn: */, "")
        print > "'$random_word.txt'"
        next
    }
    flag {
        if (/^$/) exit
        print >> "'$random_word.txt'"
    }'
else
    # Remove the line from words.txt if the word is not found in the dictionary
    awk 'NR != '$random_line'' $WORDS_FILE > temp && mv temp $WORDS_FILE
    echo "Word not found in dictionary. Line removed from words.txt."
fi

git add .
git commit -m "Did some stuff using $random_word"
git push origin main