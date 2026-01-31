# Module 0

## 3.2.1 - Weighted Mean
### Imports
import imp

import numpy as np
import pandas as pd

### Weighted mean
x = [8, 1, 2.5, 4, 28]
v = [0.1, 0.2, 0.3, 0.25, 0.15]
y, z, v = np.array(x), pd.Series(x), np.array(v)
vmean = np.average(y, weights=v)

vmean2 = sum(x_ * v_ for (x_, v_) in zip(x, v)) / sum(v)

## 3.2.2 Median
### Imports
import math
import statistics

## 3.2.3 Variance
### Imports
import numpy as np

x = [8, 1, 2.5, 4, 28]
x_with_nan = [8, 1, 2.5, math.nan, 4, 28]

a = np.var(x)
print("a = ", a)
b = np.var(x_with_nan)
print("b = ", b)
c = np.nanvar(x_with_nan)
print("c = ", c)
d = np.nanvar(x_with_nan, ddof=1)
print("d = ", d)
e = np.nanvar(x_with_nan, ddof=0)
print("e = ", e)


## 3.2.4 Percentiles
### Imports
import numpy as np

y = [-5.0, -1.1, 0.1, 2.0, 8.0, 12.8, 21.0, 25.8, 41.0]
print(np.percentile(y, 25))
