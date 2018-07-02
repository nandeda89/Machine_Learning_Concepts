library(utils)

#or

library(combinat)

permn(1:3)
combn(1:5, 3)

length(permn(1:3))
dim(combn(1:5,3))[2]

?combn

library(gtools)
combinations(5,3)
dim(combinations(5,3)) [1]

combinations(5,3,repeats=TRUE)
dim(combinations(5,3,repeats=TRUE))[1]

combinations(10,6,1:10)
dim(combinations(10,6,1:10)) [1]

# To use large 'n',
options(expressions=1e5)
cmat <- combinations(300,2)
dim(cmat) # 44850 by 2
