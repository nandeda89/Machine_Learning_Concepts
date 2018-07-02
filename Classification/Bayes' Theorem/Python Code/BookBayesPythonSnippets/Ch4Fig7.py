# -*- coding: utf-8 -*-
"""
File: BayesRulePythonBinomial_v1.py, by Royston Sellman (with tweeks by JV Stone).
Python code to accompany book: Bayes' Rule: A Tutorial Introduction Introduction by JV Stone, 2013.
    Overview: The code plots graphs like those in Figure 4.7, which show the probability of head outcomes as a function of coin bias b.
    For each value of coin bias b (the probability of a head), and for each of a different number of coin flipoutcomes, 
    we generate a data set x. We then count the number of heads nh and tails nt in x. 
    We then compute the probability of x for each value of b in a range of putative bias values, which yields a likelihood function.
    We multiply each value in the likelihood function by a corresponding value in the prior distribution to obtain a posterior distribution.
    The prior can be either uniform or binomial, according to the set value of the boolean variable useuniformprior.
This code can be downloaded from http://jim-stone.staff.shef.ac.uk/BayesBook/Python.
The code below is compatible with Python version 2.7. 
Copyright: 2014, JV Stone, Psychology Department, Sheffield University, Sheffield, England.
Date: 12 January 2014.
"""
# Import required modules.
import numpy as np
import matplotlib.pyplot as plt


plt.close("all")
plt.rcParams.update({'font.size': 12})
plt.ion()
# Set random number seed
np.random.seed(99)

# Make vector of possible coin bias values, bias = p(head).
tiny = 1e-12
b = np.linspace(0, 1, 1000) # Vector of bias values.
a = 1-b                     # Vector of p(tails) values.

# Choose prior, either uniform or binomial.
useuniformprior = 1
if useuniformprior: 
    prior=b**0        # Make prior uniform.
else: 
    prior=b**2 * a**2 # Make prior binomial.

# Make data x0, from which individual data set x will be extracted.
coinbias=0.6
ni = 10
NN = 2**ni # Max number of coin flipoutcomes in loop below is NN.
flipoutcomes = np.random.rand(NN);      # Get NN random numbers.
x0 = np.random.rand(NN,1) < coinbias    # flip coin NN times.
x0[0]=1; x0[1]=0; x0[2]=1; x0[3]=1      # cheat initial outcomes!
x0=x0.astype(int)                       # Convert bool to integers.

# Find likelihood and posterior for different numbers N of flips.
# Make container figure for sub-plots.
fig1 = plt.figure(1,(10,16)) 
for i in range(0, ni):  # Increase coin flips in powers of 2.
    N = 2**i            # Get number of coin flips.
    x = x0[0:N]         # Extract data from x0 for first N flips.
    k = sum(x)          # Get number of heads.
    nh = k              # nh = number of heads.
    nt = N-k            # nt = number of tails.
    #  Likelihood function = probability of nh heads and nt tails.
    lik = b**nh * a**nt
    p = lik*prior       # Find posterior distribution.
    maxp = max(p)       # Find max value of p.
    p = p/maxp          # Make max value of p be one.
    ind = p.argmax()    # Find index of max value of p.
    best = b[ind]       # This is the MAP estimate of bias.
    #  Plot posterior distribution.
    fig2 = plt.subplot(ni/2,2,i+1) 
    plt.plot(b,p) 
    plt.xlabel("Coin Bias, $\\theta$")  
    plt.ylabel("Posterior $p(\\theta|x)$")
    plt.ylim((0,1.1)) 
    plt.text(0.05, 0.9, 'Num flipoutcomes = ' + str(N))
    plt.text(0.05, 0.8, 'Num heads = ' + str(nh))
    plt.text(0.05, 0.7, 'Bias est = '+'%(num)1.3f'% {"num" : best})
plt.show()

# End of program