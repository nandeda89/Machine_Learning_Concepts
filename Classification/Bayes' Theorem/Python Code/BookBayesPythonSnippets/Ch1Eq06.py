# likelihood = prob of spots given smallpox
pSpotsGSmallpox = 0.9
# prior = prob of smallpox
pSmallpox = 0.001
# marginal likelihood = prob of spots
pSpots = 0.081
# find posterior = prob of smallpox given spots 
pSmallpoxGSpots = pSpotsGSmallpox * pSmallpox / pSpots

print('Posterior, pSmallpoxGSpots = %.3f.' % pSmallpoxGSpots)
# Output: Posterior, pSmallpoxGSpots = 0.011.