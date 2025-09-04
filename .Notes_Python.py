# Notes on Python syntax
# print('Hello Positron!')

# Arithmetic
    ## Basic
1 + 1
2 - 1

2*5
10/2

5**2 # 5^2, to the power of

    ## Special
7//2 # Integer division, rounded
10 % 4 # Modulo, remainder of integer division

# Assignment, right to left
a = 5

    ## Assignment & math
a += 1 # a = a + 1
a -= 1 # a = a - 1

a *= 2 # a = a * 2
a /= 2 # a = a / 2

# Strings
MusicType = 'Rock'

'Hello' + MusicType + "your body" # concatenates without separator

    # f-string
f'Party {MusicType}'
f'{a} squared is {a**2}'

# Functions
print("I like", MusicType)
    # Apply functions/methods to objects with `.` (see # List)

    ## Ask for user input
echo_this = input(prompt = "User input: ")
print(echo_this)

    ## Import modules & functions
# import [module] # imports entire module
# from [module] import [function] # imports function

import math # For math functions
hypotenuse = math.sqrt(25)
math.pi
math.e



# List
my_list = [1, 2, "A", "B"]
my_list[0] # Index starts with 0
my_list[1] = my_list[1] * 2

my_list.append(30)
len(my_list)

# Type conversion
str(23)
int('23')
int(3.6) # Removes the decimal part! No rounding!
float('3.5')
list("abc") # Separates the characters! x = ['a', 'b', 'c']


# If-statement
x = 5
y = 3
if x > y:
    print(f'{x} larger than {y}')
elif x == y:
    print(f"{x} equals {y}")
else:
    print(f"{x} smaller than {y}")


