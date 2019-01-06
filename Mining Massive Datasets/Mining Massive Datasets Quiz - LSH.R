#
# Quiz 2a
#

#
# Q1
# The edit distance is the minimum number of character insertions and character deletions required to turn one string into another. Compute the edit distance between each pair of the strings he, she, his, and hers. Then, identify which of the following is a true statement about the number of pairs at a certain edit distance.
#

packages <- c('combinat', 'stringdist')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

library(combinat)
library(stringdist)

words <- c('he', 'she', 'his', 'hers')

# Get distinct pairs of words to transform.
pairs <- combn2(words)

# Iterate over the matrix by row (1).
distances <- apply(pairs, 1, function(pair) {
  # Calculate the edit distance of insertions and deletions using longest common substring (LCS).
  stringdist(pair[1], pair[2], method = 'lcs')
})

# Append edit distance result to matrix.
cbind(pairs, distance = distances)

#
# Q2
# Perform a minhashing of the data, with the order of rows: R4, R6, R1, R3, R5, R2. Which of the following is the correct minhash value of the stated column? Note: we give the minhash value in terms of the original name of the row, rather than the order of the row in the permutation. These two schemes are equivalent, since we only care whether hash values for two columns are equal, not what their actual values are.
#

# 0  0  R4 0
# 0  R6 R4 0
# 0  R6 R4 0
# 0  R6 R4 R3
# R5 R6 R4 R3

#
# Q3
# Here is a matrix representing the signatures of seven columns, C1 through C7.
#
# Suppose we use locality-sensitive hashing with three bands of two rows each. Assume there are enough buckets available that the hash function for each band can be the identity function (i.e., columns hash to the same bucket if and only if they are identical in the band). Find all the candidate pairs, and then identify one of them in the list below.
#

# C1, C4
# C2, C5

# C1, C6

# C4, C7
# C1, C3

# Setup data set.
data <- data.frame()
data <- rbind(data, c(C1=1, 2, 1, 1, 2, 5, 4))
data <- rbind(data, c(C1=2, 3, 4, 2, 3, 2, 2))
data <- rbind(data, c(C1=3, 1, 2, 3, 1, 3, 2))
data <- rbind(data, c(C1=4, 1, 3, 1, 2, 4, 4))
data <- rbind(data, c(C1=5, 2, 5, 1, 1, 5, 1))
data <- rbind(data, c(C1=6, 1, 6, 4, 1, 1, 4))
names(data) <- c('C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7')

# Setup empty hash to hold names.
pairs <- data.frame(band = numeric(), col1 = character(), col2 = character())

# Iterate across the number of desired bands (3).
for (band in seq(1, nrow(data), by=nrow(data) / 3)) {
  # Compare two rows.
  row1 <- data[band,]
  row2 <- data[band + 1,]
  
  # Iterate across each column, looking for matches.
  for (col1 in seq(1, ncol(data) - 1)) {
    for (col2 in seq(col1 + 1, ncol(data))) {
      # If the value in row1, column1 matches row1, column2 AND the value in row2, column1 matches row2 column2 then we have a pair!
      if (row1[col1] == row1[col2] && row2[col1] == row2[col2]) {
        part1 <- paste('C', col1, sep='')
        part2 <- paste('C', col2, sep='')
        pairs <- rbind(pairs, data.frame(band = band, col1 = part1, col2 = part2))
      }
    }
  }
}

pairs

#
# Q4
# Find the set of 2-shingles for the "document":
#
# ABRACADABRA
# and also for the "document":
#
# BRICABRAC
#

shingles <- function(document, len, removeDups = TRUE) {
  result <- c()
  
  for (i in seq(1, nchar(document))) {
    shingle <- substr(document, i, i + (len - 1))
    if (nchar(shingle) == len) {
      result <- c(result, shingle)
    }
  }
  
  if (removeDups) {
    result <- unique(result) 
  }
  
  result
}

# Calculate unique shingles for two documents.
shingles1 <- shingles('ABRACADABRA', 2)
shingles2 <- shingles('BRICABRAC', 2)

# ABRACADABRA
# AB, BR, RA, AC, CA, AD, DA, AB, BR, RA
# AB, BR, RA, AC, CA, AD, DA

# BRICABRAC
# BR, RI, IC, CA, AB, BR, RA, AC
# BR, RI, IC, CA, AB, RA, AC

# Union:
# AB, BR, RA, AC, CA, AD, DA, RI, IC

# Answer the following questions:
#
# How many 2-shingles does ABRACADABRA have?
length(shingles1)
# 7
# How many 2-shingles does BRICABRAC have?
length(shingles2)
# 7
# How many 2-shingles do they have in common?
intersect(shingles1, shingles2)
# 5
# What is the Jaccard similarity between the two documents"?
print(paste(length(intersect(shingles1, shingles2)), length(union(shingles1, shingles2)), sep = '/'))
length(intersect(shingles1, shingles2)) / length(union(shingles1, shingles2))
# 5/9

#
# Q5 - Skipped
#

#
# Q6
# Suppose we want to assign points to whichever of the points (0,0) or (100,40) is nearer. Depending on whether we use the L1 or L2 norm, a point (x,y) could be clustered with a different one of these two points. For this problem, you should work out the conditions under which a point will be assigned to (0,0) when the L1 norm is used, but assigned to (100,40) when the L2 norm is used. Identify one of those points from the list below.
#
printDistance <- function(a,b) {  
  p1l1 = (a^2+ b^2)^(1/2)
  p2l1 = ((100-a)^2 + (40-b)^2)^(1/2)
  p1l2 = (a+b)
  p2l2 = (100-a) + (40-b)
  print(p1l1)
  print(p2l1)
  print(p1l2)
  print(p2l2)
}