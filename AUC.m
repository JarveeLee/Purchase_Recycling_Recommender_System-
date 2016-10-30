function an = AUC(X,theta,R,itera)
H=theta*X';
Riv=1-R;
an=0.0;
R_array=[];
for i=1:size(R,1)
    for j=1:size(R,2)
        if R(i,j)==1
            temp=[i,j];
            R_array=[R_array;temp];
        end
    end
end
len=size(R_array,1);
for i=1:itera
    posA=randperm(len);
    pos=posA(1);
    x=R_array(pos,1);
    y=R_array(pos,2);
    h1=H(x,y);
    [x,y]=R_random_select(Riv);
    h2=H(x,y);
    if abs(h1-h2)<=0.1
        an=an+0.5;
    elseif h1>h2
        an=an+1.0;
    end
end
an=an/itera;
end

