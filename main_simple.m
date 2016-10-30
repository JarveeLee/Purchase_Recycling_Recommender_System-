
% fprintf ('ini=%f\n',adjust_parameters(initial_parameters));
% Set Regularization
i=1;
fprintf('i=%d\n',i);
V=CFsimple();
VT=V;
for i=2:100
    fprintf('i=%d\n',i);
    V=V+CFsimple();
    V=V/2;
    VT=[VT V];
end
save V V
save V VT