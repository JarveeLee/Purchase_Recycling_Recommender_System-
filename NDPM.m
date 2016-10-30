function an = NDPM( X,Theta,Y,R )
Rating=Theta*X';
num_user=size(Y,1);
num_item=size(Y,2);
an=0.0;
sm=0.0;
for u=1:num_user
    cf=0.0;
    cu=0.0;
    cc=0.0;
    Rank=zeros(num_item,5);
    for i=1:size(Rank,1)
        Rank(i,1)=i;
        Rank(i,2)=Rating(u,i);
    end
    Rank=sortrows(Rank,-2);
    for i=1:num_item
        for j=i+1:num_item
            tp1=Rank(i,1);
            tp2=Rank(j,1);
            if Y(u,tp1)>0&&Y(u,tp2)>0
                cc=cc+1;
                if Y(u,tp1)>Y(u,tp2)
                    cu=cu+1;
                else
                    %cf=cf+1;
                end
            end
        end
    end
    tep=(cf+cu)/cc;
    if cc==0
        tep=0;
    end
    if tep>0
        sm=sm+1;
    end
    an=an+tep;
    %fprintf('tep=%f,cf=%f,cu=%f,cc=%f\n',tep,cf,cu,cc);
    %pause;
end
an=an/sm;
end

