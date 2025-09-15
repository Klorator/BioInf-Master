# Module 6: Wandering toads

## Imports
import turtle
import random

## Functions
def jump(t, x, y):
    t.penup()
    t.goto(x, y)
    t.pendown()

def make_turtle(x, y, visible = True):
    t = turtle.Turtle()
    if visible == False:
        t.hideturtle() # Hide turtle
        t.speed(0)     # Speed fastest
    jump(t, x, y)
    return t

def random_turtle(width, height):
    x_rand = random.randint(int(-width / 2), int(width / 2))
    y_rand = random.randint(int(-height / 2), int(height / 2))
    t = make_turtle(x_rand, y_rand, True)
    return t

def rectangle(x, y, width, height, color = "", visible = True):
    t = make_turtle(x, y, visible)
    t.setheading(0)

    t.fillcolor(color)
    t.begin_fill()

    sides = [width, height, width, height]
    for line in sides:
        t.forward(line)
        t.left(90)
    
    t.end_fill()

def move_random(t):
    angle_rand = random.randint(-45, 45)
    distance_rand = random.randint(0, 25)

    if abs(t.pos()[0]) > 250 or abs(t.pos()[1]) > 250:
        angle_home = t.towards(0, 0)
        t.setheading(angle_home)
    else:
        t.left(angle_rand)
    
    t.forward(distance_rand)

#####################################################

## Create square area
square_side = 500
rectangle(
    -square_side / 2, 
    -square_side / 2, 
    square_side,
    square_side,
    "lightblue",
    False
)

## Turtle random walk
turtles = []
for i in range(6):
    turtles.append(random_turtle(int(-square_side / 2), int(square_side / 2)))

counter_close = 0
for i in range(0, 500):
    for t in turtles:
        move_random(t)
        # if (abs(t.pos()[0] - t.pos()[0]) < 50 and
        #     abs(t.pos()[1] - t.pos()[1]) < 50):
        #     t.write("close")
        #     counter_close += 1

# print("Close call", counter_close, "times!")
# Done
turtle.done()