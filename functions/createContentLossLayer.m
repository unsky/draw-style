function cLossLayer = createContentLossLayer(P,w)

dummyForward = @(layer, resi, resi_1) resi;
cLossLayer = struct('type', 'custom', 'name', 'closs', 'forward', dummyForward, 'backward', @cLossBackward, 'P', P, 'loss', 0, 'w', w)