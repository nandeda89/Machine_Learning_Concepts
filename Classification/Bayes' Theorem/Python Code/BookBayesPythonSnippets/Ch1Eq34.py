pData = 0.61
pDataGFourCandles = 0.6
pFourCandles = 0.9
pFourCandlesGData = pDataGFourCandles * pFourCandles / pData
print 'pFourCandlesGData = %.3f' % pFourCandlesGData
     
pDataGForkHandles = 0.7
pForkHandles = 0.1
pForkHandlesGData = pDataGForkHandles * pForkHandles / pData
print 'pForkHandlesGData = %.3f\n' % pForkHandlesGData

# Output:   pFourCandlesGData = 0.885
#           pForkHandlesGData = 0.115