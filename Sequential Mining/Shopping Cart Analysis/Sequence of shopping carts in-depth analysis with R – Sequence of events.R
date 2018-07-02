#Sequence of shopping carts in-depth analysis with R - Sequence of events
#http://analyzecore.com/2015/01/28/sequence-carts-in-depth-analysis-with-r-events/


df.evseq <- seqecreate(df.seq, tevent='state') # converting state object to event sequence
head(df.evseq)

df.subseq <- seqefsub(df.evseq, pMinSupport=0.01) # searching for frequent event subsequences
plot(df.subseq[1:10], col="cyan", ylab="Frequency", xlab="Subsequences", cex=1.5) # plotting

# In order  to do some custom analysis, in addition to the minimum support, TraMineR also allows to control the search of frequent subsequences with time constraints. For instance, we can specify:
#   
# maxGap: maximum time gap between two transitions;
# windowSize: maximum window size, that is the maximum time taken by a subsequence;
# ageMin: Minimum age at the beginning of the subsequences;
# ageMax: Maximum age at the beginning of the subsequences;
# ageMaxEnd: Maximum age at the end of the subsequences.

time.constraint <- seqeconstraint(maxGap=10, windowSize=30) # creating variable with conditions
df.subseq.time.constr <- seqefsub(df.evseq, pMinSupport=0.01, constraint=time.constraint) # searching for frequent event subsequences
plot(df.subseq.time.constr[1:10], col="cyan", ylab="Frequency", xlab="Subsequences", cex=1.5) # plotting


discrseq <- seqecmpgroup(df.subseq, group=df.feat$sex) # searching for frequent sequences that are related to gender
head(discrseq)
plot(discrseq[1:10], cex=1.5) # plotting 10 frequent subsequences
plot(discrseq[1:10], ptype="resid", cex=1.5) # plotting 10 residuals

rules <- TraMineR:::seqerules(df.subseq) # searching for rules
head(rules)
