import numpy as np
import matplotlib.pyplot as plt

plt.close("all")
plt.rcParams.update({'font.size': 18})
# Set print options for numpy arrays.
np.set_printoptions(formatter={'float': '{: 0.3f}'.format})

# Define vector of values for theta.
THETA = np.linspace(0.0, 1.0,100)
# Find likelihood function from Eq 4.9.
pxGTHETA = THETA**7 * (1.0-THETA)**3
# Plot likelihood function, Figure 4.1.
plt.figure("Figure 4.1")
plt.plot(THETA,pxGTHETA)
plt.xlabel("Bias, $\\theta$")  
plt.ylabel("Likelihood function $p(x|\\theta)")
plt.show()