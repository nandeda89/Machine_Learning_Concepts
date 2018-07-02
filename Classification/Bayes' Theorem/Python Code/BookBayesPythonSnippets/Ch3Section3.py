# Use Bayes' Rule to Estimate the Posterior Distribution.
# Data in table 3.1 transposed here so python can access elements.
from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
from sys import exit

# Set print options for numpy arrays.
np.set_printoptions(formatter={'float': '{: 0.3f}'.format})

# Make array of data, as in Table 3.1 (transposed here).
n = np.array([ 
[8,     9,     9,     5,     4,     1,     1,     0,     0,     0],
[3,     5,     8,     9,    14,    10,     3,     3,     0,     0],
[0,     1,     1,    10,    16,    11,    12,     7,     8,     5],
[0,     0,     1,     0,     3,     5,    10,     7,     7,     4]
])
 
# See Code Example 3.1 for definitions.
N = np.sum(n)                       # Get total number of counts.
ps = n/N                            # Make counts into proportions.
nTHETA = np.sum(n,axis=0)           # Sum rows to get prior counts.

# Find likelihood function.
nx3ANDTHETA = n[2,:]               # Get theta values at x=3.
px3GTHETA = nx3ANDTHETA/nTHETA     # Likelihood p(x=3|theta).
print("Likelihood function:")
print(px3GTHETA)

# Get prior distribution.
pTHETA = nTHETA/N                  # Prior distribution.
print("Prior distribution:")
print(pTHETA)

# Find posterior distribution.
nx3 = np.sum(n[2,:])                # Number of counts in row x=3.
px3 = nx3/N                         # Marginal probability p(x3)
pTHETAGx3 = px3GTHETA*pTHETA/px3    # Bayes Rule=>Posterior distn.
print("Posterior distribution:")
print(pTHETAGx3)

# Output:
# Likelihood function:
# [0.000 0.067 0.053 0.417 0.432 0.407 0.462 0.412 0.533 0.556]
# Prior distribution:
# [0.055 0.075 0.095 0.120 0.185 0.135 0.130 0.085 0.075 0.045]
# Posterior distribution:
# [0.000 0.014 0.014 0.141 0.225 0.155 0.169 0.099 0.113 0.070]