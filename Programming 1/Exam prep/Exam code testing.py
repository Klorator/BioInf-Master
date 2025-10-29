# A5
# import statistics


def average_age(name_to_age, names):
    age_lst = [v for k, v in name_to_age.items() if k in names]
    # age_avg = statistics.mean(age_lst)
    age_avg = sum(age_lst) / len(age_lst)
    return age_avg


name_to_age = {"Adam": 17, "Bertil": 74, "Carina": 65, "Denise": 18}
names = ["Adam", "Carina", "Bertil"]
avg = average_age(name_to_age, names)

print("The average age of the following people: ")
for name in names:
    print(name, end=", ")
print(f"\nis {avg}.")


# A6
def is_prime(n):
    """Return True if n is a prime, otherwise False"""
    limit = int(n**0.5)
    for i in range(2, limit + 1):
        if n % i == 0:
            return False
    return True


def next_prime(x):
    n = x + 1
    while is_prime(n) == False:
        n += 1
    return n


x_values = [1, 2, 3, 4, 9, 11, 14]
for x in x_values:
    print(f"The smallest prime greater than {x} is {next_prime(x)}.")


# A7
def round_list_of_strings(x):
    lst_rounded = [str(round(float(n), 2)) for n in x]
    return lst_rounded


x = ["1.2145", "12.3198", "-138.4319"]
x_rounded = round_list_of_strings(x)
print(f"x:          {x}")
print(f"x, rounded: {x_rounded}")


# A8
def shuffle_name(name):
    name_lst = [char for char in name]
    name_lst.append(name_lst.pop(0).lower())
    name_lst[0] = name_lst[0].upper()
    name_new = "".join(name_lst)
    return name_new


names = ["My", "Jonas", "Ibrohim"]
for name in names:
    print(f"{name} -> {shuffle_name(name)}")


# A9
class BankAccount:
    def __init__(self, owner):
        self.owner = owner
        self.balance = 0

    def __str__(self):
        return f"{self.owner}'s bank account. Balance: {self.balance} SEK"

    def deposit(self, amount):
        """Add amount to the account balance"""
        self.balance += amount

    def withdraw(self, amount):
        """Remove amount from the account balance unless amount > balance"""
        if amount > self.balance:
            print("Error: Cannot withdraw an amount that exceeds the balance.")
        else:
            self.balance -= amount


bills_account = BankAccount("Bill")
print(bills_account)
bills_account.deposit(100)
print(bills_account)
bills_account.withdraw(200)
print(bills_account)
bills_account.withdraw(40)
print(bills_account)


# A10
def extract_elements(lst, indices_to_extract):
    subset = []
    for i in indices_to_extract:
        subset.append(lst[i])
    return subset


lst = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
ind = (0, 2, 4, 0, 1, 8, -1)
extracted = extract_elements(lst, ind)
print(f"lst: {lst}")
print(f"indices to extract: {ind}")
print(f"Extracted elements: {extracted}")


# B1
def total_cost(name_to_preferences, food_to_cost, alcohol_cost):
    # Calc. food cost
    ## Extract list of dishes
    foods = [
        v2
        for k1, v1 in name_to_preferences.items()
        for k2, v2 in v1.items()
        if k2 == "food"
    ]
    ## Sum cost for each dish
    food_total = sum([food_to_cost[dish] for dish in foods if dish in food_to_cost])

    # Calc. alcohol cost
    ## Extract list of all replies for alcohol
    alcohol_lst = [
        v2
        for k1, v1 in name_to_preferences.items()
        for k2, v2 in v1.items()
        if k2 == "alcohol"
    ]
    ## Sum cost based on 'yes'
    alcohol_total = sum([alcohol_cost for answer in alcohol_lst if answer == "yes"])

    return food_total + alcohol_total


name_to_preferences = {
    "Person 1": {"food": "vegan", "alcohol": "yes"},
    "Person 2": {"food": "fish", "alcohol": "no"},
}
food_to_cost = {"fish": 250, "meat": 300, "vegan": 200}
alcohol_cost = 150

print(total_cost(name_to_preferences, food_to_cost, alcohol_cost))


# B2
class Rook:
    def __init__(self, square=("a", 1)):
        self.square = square

    def move(self, new_square):
        """Move the rook to new_square (without checking if this is a legal move)"""
        self.square = new_square

    def is_legal_move(self, new_square):
        """Return True if the rook can move to new_square, otherwise False"""
        pass


class Bishop:
    def __init__(self, square=("a", 1)):
        self.square = square

    def move(self, new_square):
        """Move the bishop to new_square (without checking if this is a legal move)"""
        self.square = new_square

    def is_legal_move(self, new_square):
        """Return True if the bishop can move to new_square, otherwise False"""
        # Moving to the same square is not a legal move.
        if self.square == new_square:
            return False
        new_col = new_square[0]
        new_row = new_square[1]
        current_col = self.square[0]
        current_row = self.square[1]
        # Convert the character (a-h) to a column index
        new_col_index = "abcdefgh".index(new_col)
        current_col_index = "abcdefgh".index(current_col)
        # We remain on the same diagonal if we shift the same number of squares
        # horizontally as vertically
        return abs(new_col_index - current_col_index) == abs(new_row - current_row)

    def all_legal_moves(self):
        """Return a list of all squares that the bishop can move to"""
        pass

    def pretty_print_list_of_squares(squares):
        """Print a list of squares (represented by tuples) in a readable way"""
        for square in squares:
            print(square[0] + str(square[1]), end=" ")
            print()
