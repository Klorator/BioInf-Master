# Module 5 (mandatory task below)
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
    t.speed(0)
    if visible == False:
        t.hideturtle() # Hide turtle
    
    jump(t, x, y)
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

# Mandatory task 2: Dizzy toads
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
x = random.randint(-250, 250)
y = random.randint(-250, 250)
t1 = make_turtle(x, y, True)
t1.pencolor("green")

x = random.randint(-250, 250)
y = random.randint(-250, 250)
t2 = make_turtle(x, y, True)
t2.pencolor("red")

counter_close = 0
for i in range(0, 500):
    move_random(t1)
    move_random(t2)

    if (abs(t1.pos()[0] - t2.pos()[0]) < 50 and
        abs(t1.pos()[1] - t2.pos()[1]) < 50):
        t1.write("close")
        counter_close += 1

print("Close call", counter_close, "times!")
# Done
turtle.done()