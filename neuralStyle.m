%% Script to run Neural Style on Matlab
% Work in progress!
% Ignacio Rocco

% Before running you should compile matconvnet by running vl_compilenn
% see their own documentation if you find trouble

%% intialize 

addpath([cd '/functions'])


%% set parameters
content = 'images/aa.jpg';
style = 'images/starry_night.jpg';
maxSize = 256;
pooling = 'avg';

%% load network

    net = load('H:\draw\matconv-style-master\model/imagenet-vgg-verydeep-19.mat');
net = vl_simplenn_tidy(net) ;
net.layers = net.layers(1:37); % Keep 16 convolution+ReLU & 5 pooling layers
% Use desired pooling
for i=1:length(net.layers)
    if strcmp(net.layers{i}.type, 'pool')
       net.layers{i}.method = pooling; 
    end
end

%% load images
porig = single(imread(content)); 
aorig = single(imread(style));

% scaling size computation for preprocess
imsize = round(size(porig(:,:,1))/max(size(porig(:,:,1)))*maxSize);

% preprocess
p = preprocess(porig, imsize);
a = preprocess(aorig, imsize);

% compute feature maps
Fp = vl_simplenn(net, p);
Fa = vl_simplenn(net, a);

% analyze network structure
netStructure = netAnalysis(net, Fp);
layerNames = netStructure(:,4);

%% create content loss layer
content_weight = 5;
style_weight = 1e3;
contentLayers = {'conv4_2'}
styleLayers = {'conv1_1','conv2_1','conv3_1','conv4_1','conv5_1'}

% check last needed layer in net (either contentLayers{end} or styleLayers{end})
maxContentLayer = find(not(cellfun('isempty', strfind(layerNames, contentLayers{end}))));
if isempty(maxContentLayer)
    maxContentLayer = 0;
end

maxStyleLayer = find(not(cellfun('isempty', strfind(layerNames, styleLayers{end}))));
if isempty(maxStyleLayer)
    maxStyleLayer=0;
end
N = max(maxContentLayer, maxStyleLayer);

% create new network with layers from net from 1:N and additional loss layers
net2=struct('layers','','classes',net.meta.classes,'normalization', net.meta.normalization);
j=1;
contentLayersIdx = [];
styleLayersIdx = [];
for i=1:N
    net2.layers{j} = net.layers{i}; 
    j = j+1;
    if ~isempty(cell2mat(strfind(contentLayers, net.layers{i}.name)))
        net2.layers{j} = createContentLossLayer(Fp(i+1).x, content_weight); 
        contentLayersIdx = [contentLayersIdx; j];
        j = j+1;
    end
    if ~isempty(cell2mat(strfind(styleLayers, net.layers{i}.name)))
        net2.layers{j} = createStyleLossLayer(getGramMatrix(Fa(i+1).x), style_weight);        
        styleLayersIdx = [styleLayersIdx; j];
        j = j+1;
    end
end
netAnalysis(net2,[])


%% Optimize using fmincon (Idea taken from Alexandre Garcia)
% x0 = double(rand([imsize(1) imsize(2) 3])*0.001);
% fun = @(xvec) optimFun(xvec, [imsize(1) imsize(2) 3], net2, contentLayersIdx, styleLayersIdx);
% u = ones(length(x0(:)),1)*255;
% l = -u;
% 
% iters = 1000;
% options = optimoptions('fmincon','Hessian','lbfgs', 'GradObj','on','Display','iter','MaxIter',iters);
% x = fmincon(fun,x0,[],[],[],[],l,u,[],options)
% 
% figure; imshow(uint8(deprocess(x)),[1,255]); title('x');

%% Optimize using SGD
x = single(rand([imsize(1) imsize(2) 3])*0.001);

xorig = x;
lambda = 5;
Ldata = [];
L = inf;
for i=1:1000
    % forward pass
    Fx = vl_simplenn(net2, single(x));

    grad = single(zeros(size(Fx(end).x)));
    % backwards pass
    Fx = vl_simplenn(net2, x, grad);

    % content loss
    oldL = L;
    %L = Fx(24).aux
    L = 0;
    for j=1:length(styleLayersIdx)
        L = L + Fx(styleLayersIdx(j)).aux;
    end 
    for j=1:length(contentLayersIdx)
        L = L + Fx(contentLayersIdx(j)).aux;
    end 

    % gradiend descent step
    oldx = x;
    grad = Fx(1).dzdx.*(rand(imsize(1), imsize(2), 3)>0.7);    
    x = x-lambda*grad/max(abs(grad(:)));

    display('iter   loss');
    display([num2str(i) '     ' num2str(L, '%10.5e\n')]);

    if mod(i,10)==0 % plot output every some iters
        figure(1); imshow(uint8(deprocess(x)),[]); title('x'); drawnow;        
    end
end

figure(1); imshow('aa.jpg');
figure(2); imshow('starry_night.jpg');
figure(3); imshow(uint8(deprocess(x)),[])
