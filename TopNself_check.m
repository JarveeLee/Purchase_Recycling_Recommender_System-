function [P,Re] = TopNself_check(N,X,Theta,Y,R,num_user,num_item,rev)
%TOP10SELF_CHECK 此处显示有关此函数的摘要
%   此处显示详细说明
P=0;
Re=0;
Rating=Theta*X';
temp=Y.*R;
revcnt=zeros(num_item,1);
RT=sum(R,2);
RS=RT >0 ;
valid_user=sum(RS);
%
for i=1:num_item
    revcnt(i)=item_rev(i,X,rev);
end
%}
for u=1:num_user
    if RS(u)==0
        continue;
    end
    Rank=zeros(num_item,5);
    for i=1:size(Rank,1)
        Rank(i,1)=i;
        Rank(i,2)=Rating(u,i);
    end
    Rank=sortrows(Rank,-2);
    j=1;
    for i=1:size(Rank,1)
        if temp(u,Rank(i,1))>0
            %fprintf('%d....%d\n',Rank(i,1),Rank(i,2));
            Rank(j,3)=Rank(i,1);
            Rank(j,4)=Rank(i,2);
            Rank(j,5)=Y(u,Rank(i,1));
            j=j+1;
        end
    end
    coverage=0.0;
    rc=0.0;
    for i=1:N
        if temp(u,Rank(i,1))>0
            %fprintf('%d....%d\n',Rank(i,1),Rank(i,2));
            coverage=coverage+1.0/N;
            rc=rc+1.0/revcnt(Rank(i,1));
        end
    end
    %fprintf('%d:Top 10 coverage=%f\n',u,coverage);
    P=P+coverage;
    Re=Re+rc;
end
P=P/valid_user;
Re=Re/valid_user;
if Re==0
    Re=10000000;
end
end

