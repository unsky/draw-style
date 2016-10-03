function [L, Jvec] = optimFun(xvec, xsize, net2, contentLayersIdx, styleLayersIdx)
% returns loss L and jacobian J

x=single(reshape(xvec, xsize(1), xsize(2), xsize(3))); % de-vectorize input

% forward pass
Fx = vl_simplenn(net2, x);

grad = single(zeros(size(Fx(end).x)));

% backwards pass
Fx = vl_simplenn(net2, x, grad);

% content loss
 L = 0;
for j=1:length(styleLayersIdx)
    L = L + Fx(styleLayersIdx(j)).aux;
end 
for j=1:length(contentLayersIdx)
    L = L + Fx(contentLayersIdx(j)).aux;
end 

L = double(L);
Jvec = double(Fx(1).dzdx(:)); % vectorize output