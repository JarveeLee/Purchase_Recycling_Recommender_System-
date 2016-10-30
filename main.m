initial_parameters = [1.8,0.8,0.5,0.2,5];

% Set options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', 80);
% fprintf ('ini=%f\n',adjust_parameters(initial_parameters));
% Set Regularization
i=1;
fprintf('i=%d\n',i);
V=adjust_parameters(initial_parameters);
VT=V;
for i=2:100
    fprintf('i=%d\n',i);
    V=V+adjust_parameters(initial_parameters);
    V=V/2;
    VT=[VT V];
end
save V V
save V VT