%% clear environment variable
clear all
clc

%% load dataset
load spectra_data.mat

%% stochastic sampling
temp = randperm(size(NIR,1));

% train set
P_train = NIR(temp(1:50),:)';
T_train = octane(temp(1:50),:)';

% test set
P_test = NIR(temp(51:end),:)';
T_test = octane(temp(51:end),:)';

% test set numble
N = size(P_test,2);

%% normalization £¨no need)
% pretictor
% [p_train,PS_p] = mapminmax(P_train,0,1);
% p_test = mapminmax('apply',P_test,PS_p);
% 
% % target
% [t_train,PS_t] = mapminmax(P_train,0,1);

%% create network
net = newrbe(P_train,T_train,0.3);

%% simulation
T_sim = sim(net,P_test);

%% anti-normalization (no need)
% T_sim = mapminmax('reverse',t_sim,PS_t);

%% relative error
error = abs(T_sim-T_test)./T_test;

%% goodness of fit
% gof = goodnessOfFit(T_sim',T_test','MSE');
% disp(['goodness of fit:',num2str(gof)])
gof = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 

%% compare result
result = [T_sim',T_test',error']

%% plot
plot(1:N,T_sim,'r',1:N,T_test,'b')
string = {'goodness of fit:';['R^2=' num2str(gof)]};
title(string)
xlabel('sample')
ylabel('value')
legend('simulation','raw data')
