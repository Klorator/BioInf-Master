# Module 7 stuff
text = """Kvällens gullmoln fästet kransa.
Älvorna på ängen dansa,
och den bladbekrönta näcken
gigan rör i silverbäcken.
"""

len(text)
text.count(' ')

# Count letters
count = 0
for character in text:       # character will gradually include all characters in text
    if character.isalpha():  # Count if character is a letter
        count += 1
print(f'Antal bokstäver: {count}')


count = len([character for character in text if character.isalpha()])
print(f'Antal bokstäver: {count}')


# Räknar 'svenska' bokstäver
count = 0
for character in text:
    if character.lower() in 'åäö':
        count += 1
print(f'Antal svenska bokstäver: {count}')

# .lower() and .upper() make characters lower/upper case

# Exercise:
count = len( [char \
                for char in text \
                if char.lower() in 'åäö'] )
count

###
import string
count = len( [char \
    for char in text \
        if char in string.ascii_letters] )
count

###
# .replace() replace characters

# Dictionary = {key : value}
translation_dict = {
    'å':'aa',
    'ä':'ae',
    'ö':'oe',
    'Å':'Aa',
    'Ä':'Ae',
    'Ö':'Oe'
    }
translation_dict

new_text = ''
for character in text:          # Iterate over the characters
    if character in translation_dict:            # If the character character exists as a key
        new_text += translation_dict[character]  # add the translation of the character
    else:                                        # otherwise
        new_text += character                    # add the sign as it is

print(new_text)

###

count = {}
for char in text:
    if char.isalpha():
        char = char.lower()
        if char in count:
            count[char] += 1
        else:
            count[char] = 1
print(count)

count_lst = list(count.items())
print('List: ', count_lst)
count_lst.sort()
print('Sorted list: ', count_lst)

for i, element in enumerate(count_lst, start=1):
    print(element, end=' ')
    if i % 8 == 0:
        print()
print('\n')


for index, element in enumerate(count_lst, start=1):
    print(f'{element[0]}:{element[1]:2d}', end='  ')
    if index % 8 == 0:
        print()
print('\n\n')

####

'Take it easy'.split(' ')
print(text.split(' '))

import re
wordlist = re.findall(r'[a-zA-ZåäöÅÄÖ]+', text)
print(wordlist)
