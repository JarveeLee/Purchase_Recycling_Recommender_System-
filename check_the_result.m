function an= check_the_result( X,Theta,Y_test,Y_train,R_test,R_train , num_user, num_item,num_feature)
an=zeros(16,2);
rev=0.5;
AUC_ite=150;
J_train= cofiCostFunc([X(:) ; Theta(:)], Y_train, R_train, num_user, num_item, ...
               num_feature, 0);
MAE_train=MAE(X,Theta,Y_train,R_train);
AUC_train=AUC(X,Theta,R_train,AUC_ite);
NDP=NDPM(X,Theta,Y_train,R_train);
%NDP=0;
fprintf('For training dataset:\nCost function=%f\nMAE=%f\nAUC=%f\nNDPM=%f\n',J_train,MAE_train,AUC_train,NDP);
an(1,1)=J_train;
an(2,1)=MAE_train;
an(3,1)=AUC_train;
an(4,1)=NDP;
Recal=0.0;
Precision=0.0;
F1=0.0;
j=5;
for i=[5,10,20,50]
    N=i;
    [Precision,Recal]=TopNself_check(N,X,Theta,Y_train,R_train,num_user,num_item,rev);
    F1=2/(1/Precision+1/Recal);
    fprintf('%d:Precision=%f,Recall=%f,F1 score=%f\n',N,Precision,Recal,F1);
    an(j,1)=Precision;
    an(j+1,1)=Recal;
    an(j+2,1)=F1;
    j=j+3;
end

J_test= cofiCostFunc([X(:) ; Theta(:)], Y_test, R_test, num_user, num_item, ...
               num_feature, 0);
MAE_test=MAE(X,Theta,Y_test,R_test);
AUC_test=AUC(X,Theta,R_test,AUC_ite);
NDP=NDPM(X,Theta,Y_test,R_test);
%NDP=0;
fprintf('For testing dataset:\nCost function=%f\nMAE=%f\nAUC=%f\nNDPM=%f\n',J_test,MAE_test,AUC_test,NDP);
an(1,2)=J_test;
an(2,2)=MAE_test;
an(3,2)=AUC_test;
an(4,2)=NDP;
j=5;
for i=[5,10,20,50]
    N=i;
    [Precision,Recal]=TopNself_check(N,X,Theta,Y_test,R_test,num_user,num_item,rev);
    F1=2/(1/Precision+1/Recal);
    fprintf('%d:Precision=%f,Recall=%f,F1 score=%f\n',N,Precision,Recal,F1);
    an(j,2)=Precision;
    an(j+1,2)=Recal;
    an(j+2,2)=F1;
    j=j+3;
end

end

