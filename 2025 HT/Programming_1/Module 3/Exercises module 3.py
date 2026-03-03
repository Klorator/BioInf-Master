# Stuff for module 3

import turtle

# # Initiate window and create object
# t = turtle.Turtle()
# # Change shape/icon
# t.shape('turtle')

# t.forward(100) # draws line behind, unit is pixels
# t.left(90) # rotate left/counter-clockwise 90 degrees
# t.forward(100)
# t.circle(100) # draw circle with specified radius, ends in starting position
# turtle.clearscreen()
############################################

# # Draw a star
# t = turtle.Turtle()
# t.hideturtle()
# t.color('blue', 'light blue')
# t.begin_fill()
# for i in range(36):
#     t.forward(200)
#     t.left(170)
# t.end_fill()
# turtle.clearscreen()

# turtle.done() # not sure what the point was...?

# # Exercise 1
#     # Get user input
# side_length = int(input('Length of triangle side: '))
# fill_color = input('Color: ')
#     # Angle for equilateral triangle
# tri_angle = 180 - 180 / 3
#     # Create turtle
# t = turtle.Turtle()
# t.hideturtle()
#     # Fill color
# t.fillcolor(fill_color)
# t.begin_fill()
#     # draw sides
# t.forward(side_length)
# t.left(tri_angle)
# t.forward(side_length)
# t.left(tri_angle)
# t.forward(side_length)
#     # End fill
# t.end_fill()
# ###################################

# Spiral
# t = turtle.Turtle()
# for i in range(100):
#     t.forward(i)
#     t.left(40)

# t = turtle.Turtle()
# i = 0
# dist = abs(t.distance(turtle.position()))
# while dist <= 200:
#     i += 1
#     t.forward(i)
#     t.left(40)
#     dist = abs(t.distance(turtle.position()))
# ###############################################

# # Sine curve
# import math
# t = turtle.Turtle()
# x_len = 360
# screen = turtle.Screen()
# screen.setworldcoordinates(-x_len * 1.5, -100 * 1.5, x_len * 1.5, 100 * 1.5)

# t.fillcolor('light blue')
# t.begin_fill()
#     # starting position
# t.up()
# t.goto(-x_len, 0)
#     # Draw sine curve
# t.down()
# for x_val in range(-x_len, x_len):
#     y_val = math.sin(math.radians(x_val)) * 100
#     t.goto(x_val, y_val)

#     # Draw x-axis backwards
# t.goto(-x_len, 0)
#     # End fill
# t.end_fill()
# t.hideturtle()

# # French flag (base = 100 * 3 & height = 200)
# t = turtle.Turtle()
#     # Base & red section
# t.fillcolor('red')
# t.begin_fill()

# t.forward(300)
# t.left(90)
# t.forward(200)
# t.left(90)
# t.forward(100)
# t.left(90)
# t.forward(200)

# t.end_fill() # Fill red

#     # Top & blue section
# t.left(180) # reset at top
# t.forward(200)
# t.left(90)

# t.fillcolor('blue')
# t.begin_fill()

# t.forward(200)
# t.left(90)
# t.forward(200)
# t.left(90)
# t.forward(100)
# t.left(90)
# t.forward(200)

# t.end_fill() # Fill blue
# t.hideturtle()


    # French flag with loop (repeated lines)
t = turtle.Turtle()
    # Setup
size = 100
t.up()
t.goto(-size * 1.5, -size)
t.down()
t.hideturtle()

fill = ['blue', 'white', 'red']
sides = [size, size  * 2, size, size * 2]

for col in fill: # iterate over colors
    t.fillcolor(col)
    t.begin_fill()

    for border in sides: # iterate over sides
        t.forward(border)
        t.left(90)
    t.end_fill()
    t.forward(size)
