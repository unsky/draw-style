function [J] = gradFunMat(xvec, auxdata)
% returns loss L and jacobian J
x=single(reshape(xvec, auxdata.xsize(1), auxdata.xsize(2), auxdata.xsize(3))); % de-vectorize input

% forward pass
Fx = vl_simplenn(auxdata.net2, x);

grad = single(zeros(size(Fx(end).x)));

% backwards pass
Fx = vl_simplenn(auxdata.net2, x, grad);

% content loss
 L = 0;
for j=1:length(auxdata.styleLayersIdx)
    L = L + Fx(auxdata.styleLayersIdx(j)).aux;
end 
for j=1:length(auxdata.contentLayersIdx)
    L = L + Fx(auxdata.contentLayersIdx(j)).aux;
end 

% add stochatstic component
grad = Fx(1).dzdx.*(rand(auxdata.xsize(1), auxdata.xsize(2), auxdata.xsize(3))>0.3);    
%grad = Fx(1).dzdx;    
J = double(Fx(1).dzdx(:)); % vectorize output
