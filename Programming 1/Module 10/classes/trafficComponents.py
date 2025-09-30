## Traffic system components
class Vehicle:
    """Represents vehicles in traffic simulations"""
    def __init__(self, destination, borntime):
        """Creates the vehicle with specified properties."""
        # Implement this constructor.
        self.destination = destination
        self.borntime = borntime
    
    def __str__(self):
        return f"{self.destination}"


class Lane:
    """Represents a lane with (possibly) vehicles"""
    def __init__(self, length):
        """Creates a lane of specified length."""
        # Implement this constructor.
        self.file = [None for _ in range(length)]

    def __str__(self):
        """String representation of lane contents."""
        file_lst = ["." if v == None else str(v) for v in self.file]
        return str("[" + "".join(file_lst) + "]")

    def enter(self, vehicle):
        """Called when a new vehicle enters the end of the lane."""
        # Implement this method.
        if self.last_free():
            self.file[-1] = vehicle
        # else: error or warning ??

    def last_free(self):
        """Reports whether there is space for a vehicle at the
        end of the lane."""
        # Implement this method.
        if self.file[-1] == None:
            return True
        else:
            return False

    def step(self):
        """Execute one time step."""
        # Implement this method.
        for i in range(1, len(self.file)):
            if self.file[i-1] == None:
                self.file[i-1] = self.file[i]
                self.file[i] = None

    def get_first(self):
        """Return the first vehicle in the lane, or None."""
        # Implement this method.
        return self.file[0]

    def remove_first(self):
        """Remove the first vehicle in the lane.
           Return the vehicle removed.
           If no vehicle is a the front of the lane, returns None
           without removing anything."""
        # Implement this method.
        first = self.file[0]
        # if self.file[0] != None:
        self.file[0] = None
        return first

    def number_in_lane(self):
        """Return the number of vehicles currently in the lane."""
        # Implement this method.
        return sum([True for i in self.file if i != None])


class Light:
    """Represents a traffic light"""
    def __init__(self, period, green_period):
        """Create a light with the specified timers."""
        # Implement this method.
        self.period = period
        self.green_period = green_period
        self.internal_clock = 0

    def __str__(self):
        """Report current state of the light."""
        if self.internal_clock < self.green_period:
            return "(G)"
        else:
            return "(R)"

    def step(self):
        """Take one light time step."""
        # Implement this method.
        self.internal_clock += 1
        if self.internal_clock >= self.period:
            self.internal_clock = 0


    def is_green(self):
        """Return whether the light is currently green."""
        # Implement this method.
        if self.internal_clock < self.green_period:
            return True
        else:
            return False


# Functions:
def demo_lane():
    """For demonstration of the class Lane"""
    a_lane = Lane(10)
    print(a_lane)
    v = Vehicle('N', 34)
    a_lane.enter(v)
    print(a_lane)

    a_lane.step()
    print(a_lane)
    for i in range(20):
        if i % 2 == 0:
            u = Vehicle('S', i)
            a_lane.enter(u)
        a_lane.step()
        print(a_lane)
        if i % 3 == 0:
            print('  out: ',
                  a_lane.remove_first())
    print('Number in lane:',
          a_lane.number_in_lane())


def demo_light():
    """Demonstrats the Light class"""
    a_light = Light(7, 3)
    for i in range(15):
        print(i, a_light,
              a_light.is_green())
        a_light.step()


def main():
    """Demonstrates the classes"""
    print('\nLight demonstration\n')
    demo_light()
    print('\nLane demonstration')
    demo_lane()


if __name__ == '__main__':
    main()
