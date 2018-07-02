# -*- coding: utf-8 -*-

##################################################################################
# File: Regression.py
# Demonstration code for Bayes' Rule: A Tutorial Introduction to Bayesian Analysis
# JV Stone, 2014.
# Copyright: 2014, JV Stone,  Sheffield University, Sheffield, England.
# The Python code below is version 0.1. This code can be downloaded from http://jim-stone.staff.shef.ac.uk/BookBayes2012/BayesRuleBookMain.html
# This code should run under Python 2.76, and was tested under Enthough Canopy Version: 1.3.0 (64 bit)
# The code was translated from MatLab, and I have left Royston Sellman's helpful translation notes in this file.
##################################################################################
# imports
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
from numpy import arange, linspace, random, ones, linalg, zeros, amin, amax, exp
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.regression.linear_model as sm
from sys import exit

plt.close("all")
plt.rcParams.update({'font.size': 18})
plt.ion()

# Set random number seed.
np.random.seed(6)

# Figure 5.3.
# Make noisy data with slope m and intercept c.
# Define 11 salary values for horizontal axis.
s = arange(1,12)                        
# Set value of slope m and intercept c.
m = 0.5; c = 3
# Set standard deviation of each measured height.
sds = 2*arange(1,12)/10.0; sds = sds * arange(1,12)/10.0       
# Use noise values copied from book (based on sds above).
eta=[-0.0023,-0.0728,0.1104,0.6076,-0.3034,-0.2237,0.7407,
-1.0,-3.0,-2.4653,-3.0]
# Find observed values of x (with noise added).
x = m*s + c + eta

# Weighted Least Squares regression. 
# Find weightings w (discount) for each data point.
vars0 = sds ** 2; w = 1/vars0       
# Un-comment next line for solution based on un-weighted regression.                        
#w=ones(size(w)) 
ss = sm.add_constant(s) # Add column of 1s for regression.   
model = sm.WLS(x,ss, weights=w)       
results = model.fit()
cest2, mest2 = results.params
print('Estimated slope = %.3f,' % mest2)
print(' estimated intercept = %.3f.' % cest2)

# Make line xest2 based on fitted slope and intercept. 
s2 = arange(0,13)
xest2 = mest2 * s2 + cest2               

# Plot fitted line xest, data points, and error bars.
fig1 = plt.figure() 
plt.errorbar(s, x, yerr=sds, fmt='o',color='k')
plt.plot(s,x, 'k*', s2, xest2, 'k--')
plt.xlabel('Salary, $s$ (groats)')
plt.ylabel('Height, $x$ (feet)')
plt.xlim((0,12)); plt.ylim((0,9))
# Output: 
#    Estimated slope = 0.479. 
#    Estimated intercept = 3.019.

# Code for 2d graph, Figure 5.4a.
# Continued from previous snippet ...
m = mest2; mmin = mest2-1; mmax = mest2+1
c = cest2; cmin = cest2-1; cmax = cest2+1
minc = (mmax-mmin)/100
cinc = (cmax-cmin)/100

Fs = []
ms = linspace(mmin, mmax, 100);    nm = len(ms)
cs = linspace(cmin, cmax, 100);    nc = len(cs)
Farray = zeros((nm,nc))
for m1 in arange(0,nm):                 
    for c1 in arange(0, nc):            
        mval=ms[m1]
        cval=cs[c1]
        y1 = mval*s + cval
        F1 = ((x-y1)/sds) ** 2
        Farray[m1,c1] = sum(F1)
        Fs = (Fs, F1)

fig2 = plt.figure()
Z1 = Farray.T
zmin = amin(Z1); zmax = amax(Z1)                         
zrange = zmax - zmin 
v = arange(zmin, zmax, zrange / 10)     
# Adjust spacing of contour lines.
v = arange(0, 9 ,0.5)
v = exp(v)
v = v * zrange/max(v);
X, Y = np.meshgrid(ms,cs)               
plt.xlabel('Slope, $m$') 
plt.ylabel('Intercept, $c$')
plt.contour(X, Y, Z1, v)
plt.show()

# Code for 2d graph, Figure 5.4b.
fig3 = plt.figure()
ax = fig3.add_subplot(111, projection='3d')
ax.set_xlim(-0.5, 1.5)
ax.set_ylim(2,4)
ax.set_zlim(min(v), max(v))
ax.autoscale(enable=True, axis='z')
ax.set_xlabel('$m$'); ax.set_ylabel('$c$'); ax.set_zlabel('$F$')
surf = ax.plot_surface(X,Y,Z1,rstride=1,cstride=1,
cmap = cm.coolwarm,linewidth=0,antialiased=True)
plt.show()
# Output: 
#    Estimated slope = 0.479. 
#    Estimated intercept = 3.019.