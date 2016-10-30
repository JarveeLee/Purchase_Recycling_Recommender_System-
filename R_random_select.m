function [x,y] = R_random_select(R)
xlen=size(R,1);
ylen=size(R,2);
xt=randperm(xlen);
x=xt(1);
yt=randperm(ylen);
y=yt(1);
while R(x,y)==0
    xt=randperm(xlen);
    x=xt(1);
    yt=randperm(ylen);
    y=yt(1);
end
end

