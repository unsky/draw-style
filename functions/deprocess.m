function img = deprocess(img)

avgColor = [123.68, 116.779, 103.939];

img(:,:,1) = img(:,:,1)+avgColor(1);
img(:,:,2) = img(:,:,2)+avgColor(2);
img(:,:,3) = img(:,:,3)+avgColor(3);

% % convert to rgb
% B = img(:,:,1);
% G = img(:,:,2);
% R = img(:,:,3);
% 
% avgColor = [123.68, 116.779, 103.939];
% 
% img(:,:,1) = R+avgColor(1);
% img(:,:,2) = G+avgColor(2);
% img(:,:,3) = B+avgColor(3);