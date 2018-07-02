# The probability that patient has symptoms x3 and disease theta2.
# Data in table 3.1 transposed here so python can access elements.

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

fig = plt.figure()
ax = fig.add_subplot(111)
plt.ion() # Allow interactive plotting

for r in range(0, 4):
    for c in range(0, 10):
        ndots = n[r,c]
        for i in range(0,ndots):
            rr = 0.1+r+0.8*np.random.random()
            cc = 0.1+c+0.8*np.random.random()
            plt.scatter(cc,rr)

plt.ylim([0,4])
plt.xlim([0,10])
ax.yaxis.set_ticks([0,1,2,3,4])
plt.xlabel("$\\theta$")  
plt.ylabel("x")  
plt.grid(True)
plt.show()
# NB. Indexing in Python runs from 0 to N-1, but examples in book
# assumes indexing 1 to N. For consistency, the variable names 
# used here assume 1 to N. 

# END OF FILE

