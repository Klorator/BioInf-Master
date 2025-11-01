# Module 9: classes
# Imports:
import random
# Classes:
class Dice:
    def __init__(self, sides): # must be __init__(self, ...)
        self.sides = sides
        self.value = random.randint(1, self.sides)

    def __str__(self):
        return f"Sides: {self.sides:2d}, value: {self.value:2d}"
    
    def roll(self):
        self.value = random.randint(1, self.sides)

class PokerDice:
    def __init__(self, n_dice = 5):
        self.dice_lst = []
        for _ in range(n_dice):
            self.dice_lst.append(Dice(6))
    
    def __str__(self):
        return str(sorted([d.value for d in self.dice_lst]))

    def roll(self):
        for d in self.dice_lst:
            d.roll()
    
    def n_dice(self):
        return len(self.dice_lst)

# Functions:

################################

d1 = Dice(6)
print(d1)
d1.roll()
print(d1)

pd = PokerDice()
print('Poker Dice:')
for _ in range(10):
    pd.roll()
    print(pd)
