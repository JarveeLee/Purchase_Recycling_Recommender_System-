function an = item_rev(item,X,rev)
an=0.0;
for i=1:size(X,1)
    %{
    if i==item
        continue
    end
    %}
    if cosine(X(i,:),X(item,:))>=rev
        an=an+1;
    end
end
end

