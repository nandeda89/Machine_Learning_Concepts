library(conjoint)
data(tea)

caModel(y = tprefm[1, ], x = tprof)
caUtilities(y = tprefm[1, ], x = tprof, z = tlevn)
caPartUtilities(y = tprefm, x = tprof, z = tlevn)
Conjoint(y = tpref, x = tprof, z = tlevn)
Conjoint(y = tprefm, x = tprof, z = tlevn)
caImportance(y = tprefm, x = tprof)
caTotalUtilities(y = tprefm, x = tprof)

colnames(tprefm) <- cbind(paste("prof", 1:13, sep = ""))
tprefm[1:5, ]

ShowAllUtilities(tprefm, tprof, tlevn)

caSegmentation(y = tprefm, x = tprof, c = 3)
ShowAllSimulations(sym = tsimp, y = tprefm, x = tprof)

