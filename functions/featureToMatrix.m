function res = featureToMatrix(f, dir, size3d)

if dir==1
    res = reshape(f, size(f,1)*size(f,2), size(f,3))';
end

if dir==-1
    res=reshape(f', size3d(1), size3d(2), size3d(3));
end