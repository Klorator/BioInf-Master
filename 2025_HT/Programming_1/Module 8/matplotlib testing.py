# Matplotlib examples

import matplotlib.pyplot as plt
from math import pi, sin

# Data for plotting
L = 100
time = list(range(L))
Voltage = [sin(2*pi*t/L) for t in time]

# Plot
fig, ax = plt.subplots()
ax.plot(time, Voltage)

ax.set(xlabel='time (s)', ylabel='voltage (mV)', title='Example 1')
ax.grid()

fig.savefig("test.png")
plt.show() # Display plot when running script?

# Tutorial example
plt.plot([1, 4, 9, 16]) # y (if only one arg, arg = y & x implicit 0:max(y)-1)
plt.close()

plt.plot(
    [1, 2, 3, 4],  # x
    [1, 4, 9, 16], # y
    'ro')          # color & shape, see MATLAB syntax (ro = red circles, b- = blue line)
plt.axis((0, 6, 0, 20)) # Set axis as c(xmin, xmax, ymin, ymax)
plt.show()
plt.close()
