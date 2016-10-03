function layerDesc = netAnalysis(net, res)

n=length(net.layers)
layerDesc = zeros(n,6);
layerDesc= num2cell(layerDesc);
for i=1:n
    layerDesc(i,1) = {i};
    if ~isempty(res)
        layerDesc(i,2) = {putX(size(res(i).x))};
    end
    layerDesc(i,3) = {net.layers{i}.type};
    layerDesc(i,4) = {net.layers{i}.name};
    
    if strcmp(net.layers{i}.type,'conv')        
        layerDesc(i,5) = {putX(size(net.layers{i}.weights{1}))};
    else
        layerDesc(i,5) = {''};
    end
    if ~isempty(res)
        layerDesc(i,6) = {putX(size(res(i+1).x))};
    end
end
layerDesc