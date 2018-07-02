pSpotsGSmallpox = 0.9
pSmallpox = 0.001
pSpotsGChickenpox = 0.8
pChickenpox = 0.1
Rpost = pSpotsGChickenpox*pChickenpox / (pSpotsGSmallpox*pSmallpox)
print('Rpost = %.3f.' % Rpost)

# Output:   Rpost = 88.9