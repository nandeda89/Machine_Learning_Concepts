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
N = np.sum(n)               # Get total number of counts.
ps = n/N                    # make counts into proportions.
nx3theta2 = n[3,2]          # Number of counts in row=3 and col=2.
ntheta2 = np.sum(n[:,1]);   # number of counts in col theta=2.
ptheta2 = ntheta2/N;        # proportion of counts in col theta=2.
pTHETA = 1.0*np.sum(n,axis=0)/N # Marignal distribution.

print 'Number of counts in col 2 is %d.' % ntheta2
print 'Proportion of counts in col 2 is %.3f.' % ptheta2
print 'Marignal distribution p(THETA)'
print pTHETA
# Number of counts in col 2 is 15.
# Proportion of counts in col 2 is 0.075.
# Marignal distribution p(THETA)
# [0.055 0.075 0.095 0.12 0.185 0.135 0.13 0.085 0.075 0.045]