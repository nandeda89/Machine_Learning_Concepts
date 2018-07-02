# The probability that patient has symptoms x3 and disease theta2.
# Data in table 3.1 transposed here so python can access elements.
from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
plt.close("all")
plt.rcParams.update({'font.size': 22})

# Make array of data, as in Table 3.1 (transposed here).
n = np.array([ 
[8,     9,     9,     5,     4,     1,     1,     0,     0,     0],
[3,     5,     8,     9,    14,    10,     3,     3,     0,     0],
[0,     1,     1,    10,    16,    11,    12,     7,     8,     5],
[0,     0,     1,     0,     3,     5,    10,     7,     7,     4]
])

# See Code Example 3.1 for definitions.
N = np.sum(n)           # Get total number of counts.
row3 = n[2,:]           # Get row 3.
nx3=sum(row3)           # Number of counts in row=3.
px3 = nx3/N             # Proportion in row x=3.
X = np.sum(n,axis=1)/N  # Marignal distribution.

print ('Number of counts in row 3 is %d.' % nx3)
print('Proportion of counts in row 3 is %.3f.' % px3)
print('Marignal distribution p(X) ')
print(X)
# Output: Number of counts in row 3 is 71.
# Proportion of counts in row 3 is 0.355.
# Marignal distribution p(X) [ 0.185  0.275  0.355  0.185]


