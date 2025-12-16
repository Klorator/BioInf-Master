#==============================================
# Gillespies algorithm, SSA
# Version 2, much quicker then previous version
#==============================================
import numpy as np

def SSA(prop, stoch, X0, tspan, coeff, step=0.1):
    # prop  - A function defining the propensities. The calling signature is
    #         prop(X,coeff), and it returns 1D-array or list.
    # stoch - Stoichiometry matrix. 2D-matrix, columns corresponding to the states
    #         and the rows correspond to the equations.
    # X0    - Initial values. A 1D-array or a list.
    # tspan - Time interval (list)
    # coeff - Extra parameters. 1D-array or list
    # step  - Optional, default step=0.1. The time step at which solutions are stored.
    #         Note, step does not change the time steps in the simulation, onl when
    #         the results are stored.

    time_save = np.arange(tspan[0],tspan[1]+step, step)
    if isinstance(X0, list):  # If X0 is a list,  transform to an array
      X0 = np.asarray(X0)

    Xarr = np.zeros([len(time_save),len(X0)])
    Xarr[0,:] = X0
    t = time_save[0]
    tvec = np.zeros(len(time_save))
    tvec[0] = time_save[0]

    X = X0
    i = 1
    while t<tspan[1]:
        r1, r2 = np.random.uniform(0,1, size=2)  # Find two random numbers from uniform distr.
        re = prop(X,coeff)
        cre = np.cumsum(re)
        a0 = cre[-1]
        if a0 < 1e-12:
            break
        tau = -np.log(r1)/a0  # Find random number from exponential distr.
        
        cre=cre/a0
        r = np.argmax(cre>r2)

        t+=tau
        # if new time is larger than final time, skip last calculation
        if t > tspan[1]:
            break
       
        X=X+stoch[r,:]
        if t >= time_save[i]:
            Xarr[i,:] = X
            tvec[i] = t
            i+=1

    # If iterations stopped before final time, add final time and no change
    if tvec[-1] < tspan[1]:
        tvec[-1] = tspan[1]
        Xarr[-1,:] = X

    return tvec, Xarr