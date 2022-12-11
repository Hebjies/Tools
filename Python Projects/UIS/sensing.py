import numpy as np
import cv2 as cv


lenna = cv.imread("lenna.png") # 512 by 512 rgb image.
ft = cv.cvtColor(lenna, cv.COLOR_BGR2GRAY) # 512 by 512 gray image.
kernel = 4 # Kernel size.

y = [] # empty list that will contain the new image.

for i in range(0,len(ft),kernel): # row loop.
    for j in range(0,len(ft),kernel): # column loop.
        y.append(round((ft[i:i+4,j:j+4]).mean())) # submatrix mean

y = np.array(y, dtype=np.uint8).reshape((128, 128)) # re arranging y vector to be a 128 by 128 matrix


# Image visualization.
cv.imshow('Lenna',lenna)
cv.imshow('Lenna gray',ft)
cv.imshow('Test',y)

# Press 0 to exit.
cv.waitKey(0)

