#  likelihood = prob of spots given chickenpox
pSpotsGChickenpox = 0.8
#  prior = prob of chickenpox
pChickenpox = 0.1
#  marginal likelihood = prob of spots
pSpots = 0.081
#  find posterior = prob of chickenpox given spots 
pChickenpoxGSpots = pSpotsGChickenpox * pChickenpox / pSpots
print('Posterior, pChickenpoxGSpots = %.3f.' % pChickenpoxGSpots)

# Output:   Posterior, pChickenpoxGSpots = 0.988.
