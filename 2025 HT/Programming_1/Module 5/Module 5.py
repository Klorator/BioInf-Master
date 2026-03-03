# Module 5 (mandatory task below)
# Imports:
import turtle
from math import sqrt

# Functions:
def jump(t, x, y):
    t.penup()
    t.goto(x, y)
    t.pendown()

def make_turtle(x, y, visible = True):
    t = turtle.Turtle()
    if visible == False:
        # visible = False
        t.hideturtle() # Hide turtle
        t.speed(0)     # Speed fastest
    
    jump(t, x, y)
    return t

def rectangle(t, x, y, width, height, color = ""):
    # t = make_turtle(x, y)
    jump(t, x, y)
    t.setheading(0)

    t.fillcolor(color)
    t.begin_fill()

    sides = [width, height, width, height]
    for line in sides:
        t.forward(line)
        t.left(90)
    
    t.end_fill()
    return t

def tricolore(t, x, y, h):
    flag_col = ["blue", "white", "red"]
    x_loop = x
    y_loop = y

    for col in flag_col:
        rectangle(t, x_loop, y_loop, h/2, h, col)
        x_loop += h/2
    
    return t

def pentagram(t, x, y, side, color):
    # t = make_turtle(x, y)
    jump(t, x, y)
    t.setheading(288)

    t.fillcolor(color)
    t.begin_fill()
    for point in range(5):
        t.forward(side)
        t.left(180 + 36)

    t.end_fill()

    return t

###############################################

# Mandatory task 1: Try the functions!
## Shape dimensions
flag_height = 200
rectangle_width = flag_height / 2
flag_width = rectangle_width * 3
pentagram_side = rectangle_width
pentagram_height = sqrt( rectangle_width**2 - (rectangle_width / 2)**2 )

## Starting positions
flag_bl_corner = [-rectangle_width * 1.5, -flag_height / 2]
pentagram_top = [-rectangle_width * 2, (flag_height / 2) + (pentagram_height * 1.5)]
pentagram_bottom = [pentagram_top[0], -((flag_height / 2) + (pentagram_height * 0.5))]

## Create turtle
t = make_turtle(0, 0, True)
## Draw flag
tricolore(
    t,
    flag_bl_corner[0],
    flag_bl_corner[1],
    flag_height
)
## Draw pentagrams top
for i in range(5):
    pentagram(
        t,
        pentagram_top[0] + i * pentagram_side,
        pentagram_top[1],
        pentagram_side,
        "green"
    )
    pentagram(
        t,
        pentagram_bottom[0] + i * pentagram_side,
        pentagram_bottom[1],
        pentagram_side,
        "green"
    )
# Done
turtle.done()