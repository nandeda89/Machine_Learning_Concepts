import numpy as np
import matplotlib.pyplot as plt
from sys import exit

plt.close("all")
plt.rcParams.update({'font.size': 18})
# Set print options for numpy arrays.
np.set_printoptions(formatter={'float': '{: 0.3f}'.format})
# Define vector of values for theta.
THETA = np.linspace(0.0, 1.0,100)

# Find posterior distribution, Equation 4.17.
pTHETAGx = THETA**9 * (1.0-THETA)**5
# Set max value to 1, for graph.
pTHETAGx = pTHETAGx/max(pTHETAGx)
# Plot posterior distribution, Figure 4.3c.
plt.figure("Figure 4.3c")
plt.plot(THETA,pTHETAGx)
plt.xlabel("Coin bias, $\\theta$")  
plt.ylabel("Posterior probability density $p(\\theta|x)$")

# Find likelihood function from Eq 4.9.
pxGTHETA = THETA**7 * (1.0-THETA)**3
# Set max value to 1, for graph.
pxGTHETA = pxGTHETA/max(pxGTHETA)
# Plot likelihood function, for comparison.
plt.plot(THETA,pxGTHETA,'r--')
plt.ylim([0, 1.1]) 
plt.show()
exit
