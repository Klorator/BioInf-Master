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

def rectangle(x, y, width, height, color = ""):
    t = make_turtle(x, y)
    t.setheading(0)

    t.fillcolor(color)
    t.begin_fill()

    sides = [width, height, width, height]
    for line in sides:
        t.forward(line)
        t.left(90)
    
    t.end_fill()

def tricolore(x, y, h):
    flag_col = ["blue", "white", "red"]
    x_loop = x
    y_loop = y

    for col in flag_col:
        rectangle(x_loop, y_loop, h/2, h, col)
        x_loop += h/2

def pentagram(x, y, side, color):
    t = make_turtle(x, y)
    t.setheading(288)

    t.fillcolor(color)
    t.begin_fill()
    for point in range(5):
        t.forward(side)
        t.left(180 + 36)

    t.end_fill()

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

## Draw flag
tricolore(
    flag_bl_corner[0],
    flag_bl_corner[1],
    flag_height
)
## Draw pentagrams top
# pent_top_x = pentagram_top[0]
# pent_bottom_x = pentagram_bottom[0]
for i in range(5):
    pentagram(
        pentagram_top[0] + i * pentagram_side,
        pentagram_top[1],
        pentagram_side,
        "green"
    )
    # pent_top_x += pentagram_side
    pentagram(
        pentagram_bottom[0] + i * pentagram_side,
        pentagram_bottom[1],
        pentagram_side,
        "green"
    )
## Draw pentagrams bottom
# pent_bottom_x = pentagram_bottom[0]
# for i in range(5):
#     pentagram(
#         pent_bottom_x,
#         pentagram_bottom[1],
#         pentagram_side,
#         "green"
#     )
#     pent_bottom_x += pentagram_side
# Done
turtle.done()