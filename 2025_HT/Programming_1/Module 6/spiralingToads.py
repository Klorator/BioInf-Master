# Module 6
# Imports:
import turtle

# Functions:
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

#######################################################

width = 500
height = 500

# Create starting toads
t_starting_pos_x = [-width/2, -width/2, width/2, width/2]
t_starting_pos_y = [height/2, -height/2, -height/2, height/2]
turtles = []
for i in range(4):
    turtles.append(make_turtle(t_starting_pos_x[i], t_starting_pos_y[i]))

turtles_heading = list(range(len(turtles)))
for i in range(10):
    for j in range(len(turtles)):
        turtles_heading[j] = turtles[j].towards(turtles[j-1])
    for j in range(len(turtles)):
        turtles[j].setheading(turtles_heading[j])
        turtles[j].forward(50)

# Done
turtle.done()