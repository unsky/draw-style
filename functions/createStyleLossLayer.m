function sLossLayer = createStyleLossLayer(A,w)

dummyForward = @(layer, resi, resi_1) resi;
sLossLayer = struct('type', 'custom', 'name', 'sloss', 'forward', dummyForward, 'backward', @sLossBackward, 'A', A, 'loss', 0, 'w', w)