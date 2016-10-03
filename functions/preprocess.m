function img = preprocess(img, imsize)

avgColor = [123.68, 116.779, 103.939];

img = imresize(img, [imsize(1) imsize(2)]);

img(:,:,1) = img(:,:,1)-avgColor(1);
img(:,:,2) = img(:,:,2)-avgColor(2);
img(:,:,3) = img(:,:,3)-avgColor(3);

% avgColor = [123.68, 116.779, 103.939];
% 
% img = imresize(img, [imsize(1) imsize(2)]);
% 
% R = img(:,:,1)-avgColor(1);
% G = img(:,:,2)-avgColor(2);
% B = img(:,:,3)-avgColor(3);
% 
% convert to BGR
% img(:,:,1) = B;
% img(:,:,2) = G;
% img(:,:,3) = R;