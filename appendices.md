# Experimental results

For images in general, the blockhash algorithm generates the same
blockhash value for two different images in 0,007% (0.7 per 10,000) of
the cases (data based on a random sampling of 29,649 images).

For photographs, the algorithm generates practically unique
blockhashes, but for icons, clipart and other images, the algorithm
generates less unique blockhashses.

Larger areas of the same color (in particular black) in an image,
either as a background or borders, result in hashes that collide in
1,9% (190 per 10,000) of cases.
