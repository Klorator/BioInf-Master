# Module 7: Mandatory task

# Imports:
import tkinter as tk
from tkinter import filedialog

import re
import os.path

# Functions:
def dict_val(tuple):
    return tuple[1]

############################

# User input
## From: "https://stackoverflow.com/questions/9319317/quick-and-easy-file-dialog-in-python"
root = tk.Tk()
root.withdraw()
file_path = filedialog.askopenfilename()

n_most_common = int(input('Number of most common words: '))
m_least_common = int(input('Number of least common words: '))

# Read file
file = open(file_path, 'r')
file_lines = file.read()
file.close()

# "Produce statistics" ??
## Count words
words_lst = re.findall(r'[a-zA-ZåäöÅÄÖ]+', file_lines)
words_count = len(words_lst)
### Most/least common
words_dict = {}
for w in words_lst:
    w = w.lower()
    if w in words_dict:
        words_dict[w] += 1
    else:
        words_dict[w] = 1

#### "https://realpython.com/sort-python-dictionary/"
words_lst_sorted = sorted(words_dict.items(), key=dict_val, reverse=True)

words_top = words_lst_sorted[0:n_most_common]
words_bottom = words_lst_sorted[len(words_lst_sorted) - m_least_common: ]

# Output results
## "https://www.geeksforgeeks.org/python/python-os-path-basename-method/"
print("---------------------------------------------")
print(f"Word counts for '{os.path.basename(file_path)}':")
print(f"Words: {words_count}")

print(f"The {n_most_common} most common words are:")
for index, pair in enumerate(words_top):
    print(f"\t{pair[0]}:{pair[1]:2d}")

print(f"The {m_least_common} least common words are:")
for index, pair in enumerate(words_bottom):
    print(f"\t{pair[0]}:{pair[1]:2d}")
print("--------------------------------------------")

