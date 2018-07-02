import numpy as np
import matplotlib.pyplot as plt
from sys import exit

plt.close("all")
plt.rcParams.update({'font.size': 18})
plt.ion()

# Set print options for numpy arrays.
np.set_printoptions(formatter={'float': '{: 0.3f}'.format})

np.random.seed(991)

# Define vector of values for theta.
THETA = np.linspace(0.0, 1.0,100)
coinbias = 0.6
q = 1-THETA                             # Values for p(tails).
NN = 2**10                              # Max number of coin flips.
x0 = np.random.rand(NN,1) < coinbias     # flip coin NN times.
x0[0]=1; x0[1]=0; x0[2]=1; x0[3]=1;     # cheat initial outcomes!
x0=x0.astype(int)                     # Convert bool to integers.

for i in range(0,11):
    N = 2**i
    x = x0[0:N]
    k = np.sum(x);           # Num heads observed.
    p = THETA**k * q**(N-k); # Prob of k heads and (N-k) tails.
    maxp = np.max(p);          #  Find max value of p.
    p=p/maxp;                   # Set max value of p to 1.
    plt.figure()
    plt.plot(THETA,p,'k')
    plt.xlabel("Coin Bias, $\\theta$")  
    plt.ylabel("Posterior probability density $p(\\theta|x)$")
    s = "Coin flips = %d" % N
    plt.text(0.2, 0.9,s, ha='center', va='center')
    plt.ylim([0, 1.1]); plt.pause(0.0001)
    plt.show()
    
exit(0)
