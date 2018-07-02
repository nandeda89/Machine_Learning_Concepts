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
N = np.sum(n)                       # Get total number of counts.
ps = n/N                            # Make counts into proportions.
nTHETA = np.sum(n,axis=0)   

# Set graph parameters.
width = 0.2                 
theta_values = range(1,11)

# Find likelihood function.
nx3ANDTHETA = n[2,:]               # Get theta values at x=3.
px3GTHETA = nx3ANDTHETA/nTHETA     # Likelihood p(x=3|theta).
# Plot likelihood function.
plt.figure("Figure 7a")
plt.bar(theta_values, px3GTHETA, width=width,align='center')
plt.xticks(theta_values, theta_values)
#  Add space to bar on left and right.
plt.xlim([min(theta_values)-0.5, max(theta_values)+0.5]) 
plt.xlabel("Outcome value")
plt.ylabel("Likelihood, $p(x_3|\\theta)$")

# Get prior distribution.
pTHETA = nTHETA/N                  # Prior distribution.
# Plot prior distribution.
plt.figure("Figure 7b")
plt.bar(theta_values, pTHETA, width=width,align='center')
plt.xticks(theta_values, theta_values)
plt.xlim([min(theta_values)-0.5, max(theta_values)+0.5]) 
plt.xlabel("Outcome value")
plt.ylabel("Prior, $p(\\theta)$")

# Find posterior distribution.
nx3 = np.sum(n[2,:])                # Number of counts in row x=3.
px3 = nx3/N                         # Marginal probability p(x3)
pTHETAGx3 = px3GTHETA*pTHETA/px3    # Posterior distribution.
# Plot posterior distribution.
plt.figure("Figure 7c")
plt.bar(theta_values, pTHETAGx3, width=width,align='center')
plt.xticks(theta_values, theta_values)
plt.xlim([min(theta_values)-0.5, max(theta_values)+0.5]) 
plt.xlabel("Outcome value")
plt.ylabel("Posterior, $p(\\theta|x)$")
plt.show()

exit(0) #

ptheta2Gx3 = n[2,1]/nx3
print 'Prob x=3 given theta=2 is %.3f.' % ptheta2Gx3

# Output: 
# Number of counts in row x=3 is 71.
# Prob x=3 given theta=2 is 0.014.


px3ANDtheta2 = ps[2,1];
px3Gtheta2 = px3ANDtheta2/ptheta2;

print 'Prob x=3 AND theta=2 is %.3f.' % px3ANDtheta2
print 'Prob x=3 given theta=2 is %.3f.' % px3Gtheta2

# Find likelihood function
px3GTHETA = nx3ANDTHETA/nTHETA

print 'Likelihood function p(x3|THETA) = '
print px3GTHETA
# Output: 
# Prob x=3 AND theta=2 is 0.005.
# Prob x=3 given theta=2 is 0.067.
# Likelihood function p(x3|THETA) = 
# [0.000 0.067 0.053 0.417 0.432 0.407 0.462 0.412 0.533 0.556]


exit(0) #