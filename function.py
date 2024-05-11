import subprocess
import re
from nltk.corpus import words
import random

word_list = words.words()
using_llm = False


def main():
    # generate 2 random words
    two_words = random.sample(word_list, 2)
    if using_llm:
        prompt = "Generate two random words please"
        two_words_sentence = get_prompt_response(prompt)
        pattern = r'"([^"]*)"'
        two_words = re.findall(pattern, two_words_sentence)
    # make a txt file for each
    for word in two_words:
        # write a little paragraph too
        create_text_file(word+".txt")
    # TODO:
    # if more than 4 txt files, try to find a grouping
    # make the grouping a directory and move the grouped files in there

    print("Made files for these words: " + str(two_words))

def get_prompt_response(prompt_string):
    command = ["llm", "-m", "gpt-falcon", '"' + prompt_string + '"']
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode == 0:
        print("our response: " + result.stdout)
        return result.stdout
    else:
        # If the command failed, print the stderr
        return "Error:" + result.stderr

def create_text_file(file_name):
    # Create and open the first text file
    with open(file_name, 'w') as file:
        # Write some content to the first text file
        print("trying to make file for " + file_name)
        content = "Hey man I'm trying something here"
        if using_llm:
            prompt = "Can you write a little something about " + file_name + ". Could be anything related."
            content = get_prompt_response(prompt)
        file.write(content)







main()