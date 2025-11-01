# Module 4 stuff

# # Defining custom functions
# def my_func(arg1, arg2):
#     print(arg1, arg2)
#     return "done"
#
# result = my_func("num", 55)
# print(result)
###############################################
# # Function: Celsius to Fahrenheit
# def celsius_to_fahrenheit(c):
#     f = c * (9/5) + 32
#     return f

# print(celsius_to_fahrenheit(25))

# def fahrenheit_to_celsius(f):
#     c = (5/9) * (f - 32)
#     return c

# print(fahrenheit_to_celsius(77))
###############################################
# Function with multiple return values
import math
def quad_equation(p, q):
    disc = p*p - 4*q
    if disc >= 0:
        d = math.sqrt(disc)
        x1 = (-p + d)/2.0
        x2 = (-p - d)/2.0
        if isinstance(d, complex):
            raise ValueError("Complex roots not allowed!")
        return x1, x2 # Returns a tuple
    else:
        return None
r = quad_equation(-3, 2) # return tuple
print(r)
print(r[0], "and", r[1])
x1, x2 = quad_equation(-3, 2) # tuple unpacked
##############################################
# # error handling & warnings
# def triangle_area(a, b, c):
#     s = (a + b + c)/2
#     t = s*(s-a)*(s-b)*(s-c)
#     if a <= 0 or b <= 0 or c <= 0 or t <= 0:
#         raise ValueError('Illegal parameter values in triangle_area')
#     r = math.sqrt(t)
#     return r
# triangle_area(-1, 3, 4)

# while True:
#     print('Give side lengths')
#     a = float(input('First: '))
#     b = float(input('Second: '))
#     c = float(input('Third: '))
#     try:
#         print('The area is', triangle_area(a, b, c))
#         break
#     except ValueError:
#         print('\n*** Bad arguments to triangle_area!')
#         print('Try again!')
