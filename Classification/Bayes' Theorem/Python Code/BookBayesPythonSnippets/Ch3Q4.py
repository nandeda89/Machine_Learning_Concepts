 # The probability that patient has symptoms x3 and disease theta2.
# Data in table 3.1 transposed here so python can access elements.
from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
from sys import exit

# Set print options for numpy arrays.
np.set_printoptions(formatter={'float': '{: 0.3f}'.format})

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
N = np.sum(n)               # Get total number of counts.
ps = n/N                    # Make counts into proportions.
ntheta2 = np.sum(n[:,1]);   # Number of counts in col theta=2.
ptheta2 = ntheta2/N         # Proportion of counts in col theta=2.

px3ANDtheta2 = ps[2,1]
px3Gtheta2 = px3ANDtheta2/ptheta2

print('Prob x=3 AND theta=2 is %.3f.' % px3ANDtheta2)
print('Prob x=3 given theta=2 is %.3f.' % px3Gtheta2)

# Find likelihood function
nx3ANDTHETA = n[2,:]           # get theta values at x=3.
nTHETA = np.sum(n,axis=0)     # Marignal distribution.
px3GTHETA = nx3ANDTHETA/nTHETA

print( 'Likelihood function p(x3|THETA) = ')
print(px3GTHETA)
# Output: 
# Prob x=3 AND theta=2 is 0.005.
# Prob x=3 given theta=2 is 0.067.
# Likelihood function p(x3|THETA) = 
# [0.000 0.067 0.053 0.417 0.432 0.407 0.462 0.412 0.533 0.556]