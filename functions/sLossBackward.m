function [resi] = sLossBackward(layer, resi, resi_1)

[Ml1, Ml2, Nl] = size(resi.x);
Ml = Ml1*Ml2;
G = getGramMatrix(resi.x);
resi.aux = sum((G(:)-layer.A(:)).^2)/(4*Nl^2*Ml^2); % loss

Fl = featureToMatrix(resi.x, 1, []);
resi.dzdx = max(featureToMatrix((Fl'*(G-layer.A)/(Nl^2*Ml^2))',-1, size(resi.x)),0) * layer.w + ... % new gradient term
    resi_1.dzdx;



