# Experimental results

On a sample of 100,000 random images from Wikimedia Commons, the
algorithm generated colliding matches for 1,036 images, meaning that
it has a collision rate of ca 1%. The vast majority of such collisions
are where between two to four images generate the same hash; only
rarely does a hash match more than four images.

Number of images in collision  Collisions
-----------------------------  ----------
                            2         247
                            3          51
                            4          19
                            5           8
                            6           9
                            7           3
                    8 or more          16

^[collisions::Blockhash collisions rate]

Taking 4,000 unique sample images (not counting collisions) and doing
a crosswise comparison of them, calculating the hamming distance
between one hash and every other hash, we get the following
distribution of hamming distances (up to 10 bits):

Hamming distance Cross matches Cross matches (%)
---------------- ------------- -----------------
               1             0 0%
               2             2 0,05% 
               3             2 0,05% 
               4             7 0,175%
               5             7 0,175%
               6            25 0,625%
               7            30 0,75% 
               8            47 1,175%
               9            55 1,375%
              10            73 1,825%

^[crossmatches::False positive match rate]
