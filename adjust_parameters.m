function an = adjust_parameters(para)
%---------------------Oganize the dataset------------------
p1=para(1);
p2=para(2);
p3=para(3);
p4=para(4);
lambda=para(5); 
%---------------------Oganize the dataset------------------
fprintf('....Load and organize the data into matric...\n');
num_user = 10000;
num_item = 770;
num_catagory = 108;
num_feature=108;
ite=80;
train_rate=0.8;
test_rate=0.2;
Rec = load('recycledetails.txt');%user/catagory
Buy = load('buydetals.txt');%user/item/catagory
Cli = load('clickhis.txt');%user/item/catagory
t_shop= load('shop_catagory.txt');%item/catagory
shop=zeros(num_item,1);
for i=1:size(t_shop,1)
    shop(t_shop(i,1))=t_shop(i,2);
end
%-----------Randomly generate the 20% test set and the 80% training set----
fprintf(['....Randomly generate the %f test set' ...
   'and the %f training set....\n'],test_rate,train_rate);
Y_train=zeros(num_user,num_item);
Y_test=zeros(num_user,num_item);
R_train=Y_train;
R_test=zeros(num_user,num_item);
X=zeros(num_item,num_feature);
Theta = zeros(num_user, num_feature);
%---------Load on purchasing data------------------
%
fprintf('....Randomly generate purchasing data into matric...\n');
ss=size(Buy,1);
index=randperm(ss);
for i=1:floor(train_rate*ss)
    j=index(i);
    Y_train(Buy(j,1),Buy(j,2))= Y_train(Buy(j,1),Buy(j,2))+p1;
    R_train(Buy(j,1),Buy(j,2))= 1;
    if Y_train(Buy(j,1),Buy(j,2))>5
        Y_train(Buy(j,1),Buy(j,2))=5;
    end
end
for i=ceil(train_rate*ss):ss
    j=index(i);
    Y_test(Buy(j,1),Buy(j,2))= Y_test(Buy(j,1),Buy(j,2))+p1;
    R_test(Buy(j,1),Buy(j,2))= 1;
    if Y_test(Buy(j,1),Buy(j,2))>5
        Y_test(Buy(j,1),Buy(j,2))=5;
    end
end
%---------Load on clicking data------------------
fprintf('....Randomly generate clicking data into matric...\n');
ss=size(Cli,1);
index=randperm(ss);
for i=1:floor(train_rate*ss)
    j=index(i);
    Y_train(Cli(j,1),Cli(j,2))= Y_train(Cli(j,1),Cli(j,2))+p3;
    R_train(Cli(j,1),Cli(j,2))= 1;
    if Y_train(Cli(j,1),Cli(j,2))>5
        Y_train(Cli(j,1),Cli(j,2))=5;
    end
end
for i=ceil(train_rate*ss):ss
    j=index(i);
    Y_test(Cli(j,1),Cli(j,2))= Y_test(Cli(j,1),Cli(j,2))+p3;
    R_test(Cli(j,1),Cli(j,2))= 1;
    if Y_test(Cli(j,1),Cli(j,2))>5
        Y_test(Cli(j,1),Cli(j,2))=5;
    end
end
save Y_train Y_train
save Y_test Y_test
save R_train R_train
save R_test R_test 
save X X
save Theta Theta
%}
%-----------Load on data and parameters-----------------
load ('Y_train.mat');
load ('Y_test.mat');
load ('R_train.mat');
load ('R_test.mat');
load ('Theta.mat');
load ('X.mat');
Y=Y_train+Y_test;
R=R_train+R_test;
%-------------------Training parameters and save---------

fprintf('Train parameters and save.....\n');
X = randn(num_item, num_feature);
Theta = randn(num_user, num_feature);
%-----------Cost function with initialized parameters----
J = cofiCostFunc([X(:) ; Theta(:)], Y_train, R_train, num_user, num_item, ...
               num_feature, 0);
fprintf(['Cost at initial parameters: %f '...
         '\n'], J);
initial_parameters = [X(:); Theta(:)];

% Set options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', ite);

% Set Regularization
theta = fmincg (@(t)(cofiCostFunc(t, Y_train, R_train, num_user, num_item, ...
                                num_feature, lambda)), ...
                initial_parameters, options);

% Unfold the returned theta back into U and W
X = reshape(theta(1:num_item*num_feature), num_item, num_feature);
Theta = reshape(theta(num_item*num_feature+1:end), ...
                num_user, num_feature);
J = cofiCostFunc([X(:) ; Theta(:)], Y_train, R_train, num_user, num_item, ...
               num_feature, 0);
save Theta Theta;
save X X;
%}
%------Check the result----------------------------------------------------
fprintf('....Validation before loading on recycle data.....\n');
load ('Theta.mat');
load ('X.mat');
V1=check_the_result( X,Theta,Y_test,Y_train,R_test,R_train , num_user, num_item,num_feature);
%------Load on recycle-data---------------------------
fprintf('Generate the customers preference based on click and purchase log\n');
fprintf('Load on recycle data\n');
for i=1:size(Rec,1)
    us=Rec(i,1);
    cl=Rec(i,2);
    temp_vec=zeros(1,num_catagory);
    tnum=0;
    for j=1:num_item
        if Y(us,j)>0 && shop(j)==cl
            tnum=tnum+1;
            temp_vec=temp_vec+X(j,:)*Y(us,j);
        end
    end
    if tnum>0
        temp_vec=temp_vec/tnum;
    end
    adjust=Theta(us,:)*temp_vec'*p2;
    
    if adjust<p4
        adjust=p4;
    end
    %adjust=p2;
    for j=1:num_item
        if Y_train(us,j)>0 && shop(j)==cl
            Y_train(us,j)=Y_train(us,j)+adjust;
            if Y_train(us,j)>5
                Y_train(us,j)=5;
            end         
        end
        if Y_test(us,j)>0 && shop(j)==cl
            Y_test(us,j)=Y_test(us,j)+adjust;
            if Y_test(us,j)>5
                Y_test(us,j)=5;
            end
        end
    end
end
Y=Y_train+Y_test;
R=R_train+R_test;
%-------------------Re Training parameters and save---------

fprintf('Once again Train parameters and save.....\n');
X = randn(num_item, num_feature);
Theta = randn(num_user, num_feature);
%-----------Cost function with initialized parameters----
J = cofiCostFunc([X(:) ; Theta(:)], Y_train, R_train, num_user, num_item, ...
               num_feature, 0);
fprintf(['Cost at initial parameters: %f '...
         '\n'], J);
initial_parameters = [X(:); Theta(:)];

% Set options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', ite);

% Set Regularization
theta = fmincg (@(t)(cofiCostFunc(t, Y_train, R_train, num_user, num_item, ...
                                num_feature, lambda)), ...
                initial_parameters, options);

% Unfold the returned theta back into U and W
X = reshape(theta(1:num_item*num_feature), num_item, num_feature);
Theta = reshape(theta(num_item*num_feature+1:end), ...
                num_user, num_feature);
J = cofiCostFunc([X(:) ; Theta(:)], Y_train, R_train, num_user, num_item, ...
               num_feature, 0);
save Theta Theta;
save X X;
%}
%------Check the result----------------------------------------------------
fprintf('....Validation after loading on recycle data.....\n');
load ('Theta.mat');
load ('X.mat');
V2=check_the_result( X,Theta,Y_test,Y_train,R_test,R_train , num_user, num_item,num_feature);
V=[V1 V2];
an=V;
end

