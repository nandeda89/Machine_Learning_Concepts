import numpy as np
import matplotlib.pyplot as plt

plt.close("all")
plt.rcParams.update({'font.size': 18})
# Set print options for numpy arrays.
np.set_printoptions(formatter={'float': '{: 0.3f}'.format})

# Define vector of values for theta.
THETA = np.linspace(0.0, 1.0,100)
# Find prior distribution from Eq 4.14.
pTHETA = THETA**2 * (1.0-THETA)**2
# Plot prior distribution, Figure 4.2b.
plt.figure("Figure 4.2b")
plt.plot(THETA,pTHETA)
plt.xlabel("Bias, $\\theta$")  
plt.ylabel("Prior probability density $p(\\theta)$")
plt.show()