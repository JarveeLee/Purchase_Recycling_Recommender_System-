%---------------------Oganize the dataset------------------
fprintf('....Load and organize the data into matric...\n');
num_user = 10000;
num_item = 770;
num_catagory = 108;
num_feature=108;
p1=1;%purchasing parameters
p2=1;%recycling parameters
p3=0.5;%clicking parameters
Rec = load('recycledetails.txt');%user/catagory
Buy = load('buydetals.txt');%user/item/catagory
Cli = load('clickhis.txt');%user/item/catagory
Classify = load('shop-catagory.txt');%shopitem/catagory
MaUI = zeros(num_user,num_item);%Matric of user-item
MaUC = zeros(num_user,num_catagory);%Matric of user-catagory
Class = zeros(num_item,num_catagory);
for i=1:size(Buy,1)
    MaUC(Buy(i,1),Buy(i,3))= MaUC(Buy(i,1),Buy(i,3))+p1;
    MaUI(Buy(i,1),Buy(i,2))= MaUI(Buy(i,1),Buy(i,2))+p1;
end
for i=1:size(Rec,1)
    MaUC(Rec(i,1),Rec(i,2))= MaUC(Rec(i,1),Rec(i,2))+p2;
end
for i=1:size(Cli,1)
    MaUC(Cli(i,1),Cli(i,3))= MaUC(Cli(i,1),Cli(i,3))+p3;
    MaUI(Cli(i,1),Cli(i,2))= MaUI(Cli(i,1),Cli(i,2))+p3;
end
for i=1:size(Classify,1)
    Class(Classify(i,1),Classify(i,2))= Class(Classify(i,1),Classify(i,2))+1;
end
%set the maxval as 5 and generate matric R
R=zeros(num_user, num_feature);
for i=1:size(MaUI,1)
    for j=1:size(MaUI,2)
        if MaUI(i,j)>5
            MaUI(i,j)=5;
        end
        if MaUI(i,j)>0
            R(i,j)=1;
        end
    end
end
%{
x=0;
y=0;
val=0;

for i=1:size(MaUI,1)
    for j=1:size(MaUI,2)
        if MaUI(i,j)>val
            val=MaUI(i,j);
            x=i;
            y=j;
        end
    end
end
%check the maxval in MaUI
%}
%fprintf('val= %f \n', val);

%--------------------Compute the cost function and gradient--------
fprintf('....Initialize the parameters...\n');
Y=MaUI;
X=zeros(num_item, num_feature);
Theta = zeros(num_user, num_feature);
J = cofiCostFunc([X(:) ; Theta(:)], Y, R, num_user, num_item, ...
               num_feature, 0);
fprintf(['Cost at initial parameters: %f '...
         '\n'], J);
%-------------------Training parameters and save---------
%{
fprintf('Train parameters and save.....\n');
X = randn(num_item, num_feature);
Theta = randn(num_user, num_feature);

initial_parameters = [X(:); Theta(:)];

% Set options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', 100);

% Set Regularization
lambda = 5;
theta = fmincg (@(t)(cofiCostFunc(t, Y, R, num_user, num_item, ...
                                num_feature, lambda)), ...
                initial_parameters, options);

% Unfold the returned theta back into U and W
X = reshape(theta(1:num_item*num_feature), num_item, num_feature);
Theta = reshape(theta(num_item*num_feature+1:end), ...
                num_user, num_feature);
J = cofiCostFunc([X(:) ; Theta(:)], Y, R, num_user, num_item, ...
               num_feature, 0);
save Theta Theta;
save X X;
%}
%------Temporary error val----
N=10;
load ('Theta.mat');
load ('X.mat');
J = cofiCostFunc([X(:) ; Theta(:)], Y, R, num_user, num_item, ...
               num_feature, 0);
fprintf(['Cost at loaded parameters: %f '...
         '\n'], J);
%-------Manually check some single user's stastic----
u=14;
fprintf('....Manually check the user:%d.....\n',u);
Rating=Theta*X';
Rank=zeros(num_item,5);
for i=1:size(Rank,1)
    Rank(i,1)=i;
    Rank(i,2)=Rating(u,i);
end
Rank=sortrows(Rank,-2);
j=1;
for i=1:size(Rank,1)
    if Y(u,Rank(i,1))>0
        %fprintf('%d....%d\n',Rank(i,1),Rank(i,2));
        Rank(j,3)=Rank(i,1);
        Rank(j,4)=Rank(i,2);
        Rank(j,5)=Y(u,Rank(i,1));
        j=j+1;
    end
end
coverage=0.0;
for i=1:N
    if Y(u,Rank(i,1))>0
        %fprintf('%d....%d\n',Rank(i,1),Rank(i,2));
        coverage=coverage+1.0/N;
    end
end
fprintf('User %d:Top %d coverage=%f\n',u,N,coverage);
%-----------------Top N average coverage self-checking-----------
fprintf('....Self validation.....\n');
N=10;
ave = TopNself_check(N,X,Theta,Y,num_user,num_item);
MAE_self=MAE(X,Theta,Y,R);
fprintf('Top %d average coverage=%f\n',N,ave);
fprintf('MAE=%f\n',MAE_self);
