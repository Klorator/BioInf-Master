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

import random # For random numbers etc.
number = random.randint(1, 100)

# Bool
honest = True
fake = False

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

    ## and, or, not
if x < 6 and x > 4:
    print(x)
elif x == 5 or y == 5:
    print(x, y)
elif x != 10:
    print(y)

age = 15
teenager = 12 < age < 20
print(teenager)

# Loops
    ## While loop
n = 6
i = 1
n_factorial = 1
while i <= n:
    n_factorial *= i
    i += 1
    if i > 100:
        print("We have gone too far!")
        break
print(f"{n}! = {n_factorial}")

    ## For loop
n_factorial = 1
for i in range(1, n + 1):
    n_factorial *= i
print(f"{n}! = {n_factorial}")

vec = ["A", "B", "C"]
for letter in vec:
    print(letter)

