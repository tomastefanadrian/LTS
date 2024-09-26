function x=find_element(c,elem,lit)

x=[0 0];
for i=1:length(c(:,1))
    if strcmp(c(i,1),lit)
        x(1)=i;
        break
    end
end

for j=2:length(c(i,:))
    if strcmp(c{i,j}(1),elem)
        x(2)=j;
        break
    end
end
