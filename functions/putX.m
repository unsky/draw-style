function sizeStr = putX(s)

sizeStr=num2str(s(1));
for j=2:length(s);
    sizeStr=strcat(sizeStr, 'x', num2str(s(j)));
end
