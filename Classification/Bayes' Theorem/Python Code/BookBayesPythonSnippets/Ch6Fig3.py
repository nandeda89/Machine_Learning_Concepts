# imports
from numpy import arange, linspace, ones, linalg, zeros, amin, amax, exp
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

plt.close("all")
plt.rcParams.update({'font.size': 12})
plt.ion()

# Make prior  distribution p(THETA).
# Find likelihood function for each value of x.
# Make joint distribution p(X,THETA) and posteriors p(THETA|X). 
# See online file for imports.
imax = 1001; imid = 500.0; 
X = linspace(0,1,imax) 
sdlik = 0.1                   # Standard deviation of likelihood.
sdprior = 0.1                 # Standard deviation of prior.
x1_index = round(imax*0.25)       # Index at x=0.75. 
thetatrue_index = round(imax*0.6) # Index at theta=0.6.

# Make Gaussian prior.
prior =  np.exp(-((X-0.5)**2/(2*sdprior**2)))
# Show prior distribution.
ax6 = plt.subplot(426); plt.ylim([0, 1.1])
plt.plot(X,prior);      plt.title("Prior distribution")
plt.ylabel("$p(x)$");   plt.xlabel("$\\theta$")
plt.setp(ax6.get_xticklabels(), visible=False)
plt.setp(ax6.get_yticklabels(), visible=False)

likelihoods = zeros((imax,imax)) # Create 2D array for likelihoods.
prior2d = zeros((imax,imax)) # Create 2D array for duplicated priors.
# Fill arrays.
for r in arange(0,imax):  
    rfrac = 1.0*(imax-r)/imax
    likelihoods[r,:] = np.exp(-((X-rfrac)**2/(2*sdprior**2)))
    prior2d[r,:] = prior

likelihoods = likelihoods/np.max(likelihoods) 
prior2d = prior2d/np.max(prior2d) # Set array max value to 1.

lik1d = likelihoods[x1_index,:] # Get likelihood function at X=x1.
ax4 = plt.subplot(424);            plt.ylim([0,1.1])
plt.plot(X,lik1d);                 plt.title("Likelihood")
plt.ylabel("$p(x_1|\\theta)$");    plt.xlabel("$\\theta$")
plt.setp(ax4.get_xticklabels(), visible=False)
plt.setp(ax4.get_yticklabels(), visible=False)

# Find joint distribution: p(X,THETA)=p(X|THETA)*p(THETA), Eq 3.41. 
joint1 = likelihoods * prior2d;    joint1=joint1/np.max(joint1)

# Get slice of joint distribution at X=x1.
joint1d = joint1[x1_index,:];    joint1d = joint1d/np.max(joint1d)
ax2 = plt.subplot(422);          plt.plot(X,joint1d)
plt.title("Joint distribution at $X=x_1$"); plt.ylim([0,1.1])
plt.ylabel("$p(x_1,\\theta)$");  plt.xlabel("$\\theta$")
plt.setp(ax2.get_xticklabels(),visible=False)
plt.setp(ax2.get_yticklabels(),visible=False)

# Find marginal likelihood p(X)
pX = np.sum(joint1,axis=1)
pX = pX/np.max(pX)

# Find posterior distribution for each value of x.
pX_duplicated = zeros((imax,imax))
for r in arange(0,imax):  
    pX_duplicated[:,r]=pX
posteriors = likelihoods * prior2d / pX_duplicated
posteriors = posteriors/np.max(posteriors)

# Get posterior distribution at X=x1.
posterior = posteriors[x1_index,:]
ax8 = plt.subplot(428);         plt.ylim([0,1.1])           
plt.plot(X,posterior)
plt.title("Posterior distribution")
plt.ylabel("$p(\\theta|x_1)$");    plt.xlabel("$\\theta$")
plt.setp(ax8.get_xticklabels(), visible=False)
plt.setp(ax8.get_yticklabels(), visible=False)

# Show 2D distributions as images.
lw = 5  # Determines white line width in 2d graphs.
# Show joint distribution.
# Mark all rows at thetatrue_index and columns at x1_index.
joint1[:,thetatrue_index-lw:thetatrue_index+lw]=1
joint1[x1_index-lw:x1_index+lw,:]=1
ax1 = plt.subplot(421);         plt.axis('off')
plt.imshow(joint1,cmap="gray"); plt.title("Joint distribution")

# Show likelihood functions.
plt.subplot(423)
# Mark all rows at thetatrue_index and columns at x1_index.
likelihoods[:,thetatrue_index-lw:thetatrue_index+lw]=1
likelihoods[x1_index-lw:x1_index+lw,:]=1
plt.imshow(likelihoods, cmap="gray")
plt.title("Likelihoods");    plt.axis('off')

# Show copies prior distribution.
plt.subplot(425);   plt.axis('off')
plt.imshow(prior2d,cmap="gray")
plt.title("Prior distributions")

# Show posterior distributions.
plt.subplot(427)
posteriors[:,thetatrue_index-lw:thetatrue_index+lw]=1
posteriors[x1_index-lw:x1_index+lw,:]=1
plt.imshow(posteriors, cmap="gray")
plt.title("Posterior distributions"); plt.axis('off'); 
figManager = plt.get_current_fig_manager()
figManager.window.showMaximized()

# Note that the white lines in the figures are made by changing the values of 
# array elements, so be careful of using these modified arrays for calculations.
