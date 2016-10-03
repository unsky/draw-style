function [resi] = cLossBackward(layer, resi, resi_1)

resi.aux = sum((resi.x(:)-layer.P(:)).^2); % loss
resi.dzdx = max(resi.x-layer.P,0) * layer.w + ... % new gradient term
    resi_1.dzdx;