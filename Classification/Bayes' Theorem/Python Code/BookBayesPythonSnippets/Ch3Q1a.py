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
np.cumsum(a,axis=1) # sum over

See Code Example 3.1 for definitions.
N = sum(n(:)); % Get total number of counts.
nx3theta2 = n(3,2); % number of counts in row x=3 and col theta=2.
px3theta2 = nx3theta2/N; % proportion in row x=3 and col theta=2.

fprintf('Number of counts in n(3,2) is %d.\n',nx3theta2);
fprintf('Proportion of counts in p(3,2) is %.3f.\n',px3theta2);

% Output: Number of counts in n(3,2) is 1.
%         Proportion of counts in p(3,2) is 0.005.