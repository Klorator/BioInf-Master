# Exam 2025-01
## Imports
import matplotlib.pyplot as plt
import numpy as np

## 6)
h_old = 0.1
h_new = h_old / (10 ** (1 / 2))
print(h_new)

local_truncation_error = (10 ** (1 / 2)) ** 3
print(local_truncation_error)


## 7)
def B_sim(t_start, t_end, step_size, mean, std_dev):
    ### Create time vector
    t = np.arange(t_start, t_end + step_size, step_size)

    ### Brownian motion simulation
    B = [0]  # Initial condition B(0) = 0
    for i in range(1, len(t)):
        rnorm = np.random.normal(mean, std_dev)
        B.append(B[i - 1] + rnorm)

    ### Package results
    result = {"time": t, "B": B}
    return result


test = B_sim(0, 10, 0.1, 0, 1)

plt.plot(test["time"], test["B"])
plt.xlabel("Time")
plt.ylabel("B")
plt.show()
plt.close()
################################################################


## 8)
### Inverse transform sampling of Pareto cumulative density function
def pareto_cdf_inverse(u, xm, alpha):
    return xm / (u ** (1 / alpha))


### MC testing function
def MC_pareto_test(n, xm, alpha):
    pareto = []
    for i in range(n):
        u = np.random.uniform(0, 1)
        pareto.append(pareto_cdf_inverse(u, xm, alpha))
    return pareto


test_pareto = MC_pareto_test(1000, 1, 3)
test_pareto = sorted(test_pareto)
x_0_1 = np.arange(0, 1, 0.001)

plt.plot(x_0_1, test_pareto)
plt.show()
plt.close()


###############################################################
## 9)
def prop(Y, params):
    alpha = params[0]
    beta = params[1]
    gamma = params[2]
    theta = params[3]
    kappa = params[4]
    delta = params[5]

    p = [
        alpha * Y[0],
        kappa * Y[1],
        theta * Y[1] * Y[0],
        beta * Y[0] * Y[2],
        gamma * Y[2],
        delta * Y[1] * Y[2],
    ]
    return p


stoch = np.array(
    [
        # R,  S,  F
        [1, 0, 0],
        [0, 1, 0],
        [-1, 1, 0],
        [-1, 0, 1],
        [0, 0, -1],
        [0, -1, 3],
    ]
)

y0 = [100, 10, 1]
params = [
    0.1,  # alpha
    0.1,  # beta
    4,  # gamma
    0.01,  # theta
    2,  # kappa
    0.6,  # delta
]

### Inverse sampling of propensity
p0 = prop(y0, params)
p0_pdf = [x / sum(p0) for x in p0]


### Inverse sampling for event time
def exp_dist_inv(u, rate):
    return -(1 / rate) * np.log(u)


rate = sum(p0)
u_rand_1 = 0.5
event_time_1 = exp_dist_inv(u_rand_1, rate)
print(event_time_1)  # event 6

### Update state
y1 = [y0[i] + stoch[5][i] for i in range(len(y0))]  # add stoch for event 6

### update prop
p1 = prop(y1, params)


## regression analysis
x = np.array([1, 2, 3, 4, 5])
y = np.array([1, 2, 1, 2, 3])
A = np.ones((len(x), 3))
A[:, 1] = x
A[:, 2] = x**2

ATA = A.T @ A
ATy = A.T @ y
k = np.linalg.solve(ATA, ATy)
print(k)
