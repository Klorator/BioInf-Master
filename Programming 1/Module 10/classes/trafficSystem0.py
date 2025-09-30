# Imports:
# from statistics import mean, median
from time import sleep
import destinations
import trafficComponents as tc


class TrafficSystem:
    """Defines a traffic system"""

    def __init__(self):
        """Initialize all components of the traffic
        system."""
        self.time = 0
        self.destination_generator = destinations.DestinationGenerator()
        self.system = [
            tc.Lane(5),
            tc.Light(10, 8),
            tc.Lane(5),
        ]
        self.queue = []

    def snapshot(self):
        """Print a snap shot of the current state of the system."""
        # print(f'Time step {self.time}')
        sys = " ".join([str(x) for x in self.system])
        queue = str("[" + "".join([str(v) for v in self.queue]) + "]")
        print(f"{sys}  {queue}")

    def step(self):
        """Take one time step for all components."""
        self.time += 1
        # 5.3.1 Remove first vehicle
        self.system[0].remove_first()
        # 5.3.2 Step left lane
        self.system[0].step()
        # 5.3.3 If light is green
        if self.system[1].is_green():
            # move vehicle from right -> left lane
            v = self.system[2].remove_first()
            self.system[0].enter(v)
        # 5.3.4 Step light
        self.system[1].step()
        # 5.3.5 Step right lane
        self.system[2].step()
        # 5.3.6 New destination -> vehicle -> queue
        dest = self.destination_generator.step()
        if dest != None:
            self.queue.append(tc.Vehicle(dest, self.time))
        # If right lane has space & queue is not empty
        if (self.system[2].last_free() and
            len(self.queue) > 0):
            # pop index 0 into right lane
            self.system[2].enter(self.queue.pop(0))
    
    def number_in_system(self):
        pass

    def print_statistics(self):
        pass


def main():
    ts = TrafficSystem()
    for i in range(100):
        ts.snapshot()
        ts.step()
        sleep(0.1) # Pause for 0.1 s.
    print('\nFinal state:')
    ts.snapshot()
    print()


if __name__ == '__main__':
    main()
