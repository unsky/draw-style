function G = getGramMatrix(x)

X = featureToMatrix(x, 1, []);
G = X*X';