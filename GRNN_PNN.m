%% clear environment variable
clear all
clc

%% load data
load iris_data.mat

%% stochastic sampling
P_train = [];
T_train = [];
P_test = [];
T_test = [];
temp = randperm(50);
for i=1:3
  P_train = [P_train features(temp(1:40)+(i-1)*50,:)'];
  T_train = [T_train classes(temp(1:40)+(i-1)*50)'];
  
  P_test = [P_test features(temp(41:end)+(i-1)*50,:)'];
  T_test = [T_test classes(temp(41:end)+(i-1)*50)'];
end

%% create and simulate networks
result_grnn = [];
result_pnn = [];
t_grnn = [];
t_pnn = [];
for i=1:4
  for j=i:4
    p_train = P_train(i:j,:);
    p_test = P_test(i:j,:);

    %% generalized regression neural network
    t = cputime;
    % creation
    net_grnn = newgrnn(p_train,T_train);
    % simulation
    t_sim_grnn = sim(net_grnn,p_test);
    T_sim_grnn = round(t_sim_grnn);
    
    t = cputime - t;
    % performance and result
    t_grnn = [t_grnn  t];
    result_grnn = [result_grnn T_sim_grnn'];
    
    %% probabilistic neural network
    t = cputime;
    % creation
    t_train = ind2vec(T_train);
    net_pnn = newpnn(p_train,t_train);
    % simulation
    t_sim_pnn = sim(net_pnn,p_test);
    T_sim_pnn = vec2ind(t_sim_pnn);
    
    t = cputime - t;
    % performance and result 
    t_pnn = [t_pnn t];
    result_pnn = [result_pnn T_sim_pnn'];
  end
end

%% performance and result
% result
result = [T_test' result_grnn result_pnn]

% cost time
t = [t_grnn;t_pnn]

% accuracy
accuracy_grnn = [];
accuracy_pnn = [];
for i=1:10
  accuracy_grnn = [accuracy_grnn length(find(T_test' == result_grnn(:,i)))/length(T_test)];
  accuracy_pnn = [accuracy_pnn length(find(T_test' == result_pnn(:,i)))/length(T_test)];
end
accuracy = [accuracy_grnn; accuracy_pnn]

%% visualization
figure(1)
% accuracy comparison
plot(1:10,accuracy(1,:),'r-*',1:10,accuracy(2,:),'b:p')
title('GRNN and PNN accuracy comparison')
xlabel('model numble')
ylabel('accuracy value')
legend('GRNN','PNN')

figure(2)
% prediction classification result
plot(1:30,T_test,'k-*',1:30,result_grnn(:,4)','r-o',1:30,result_pnn(:,4)','b-p')
string = ['accuracy:' num2str(accuracy(1,4)*100) '%(GRNN)' ' VS ' num2str(accuracy(2,4)*100) '%(PNN)'];
title(string)
xlabel('sample')
ylabel('classification')
legend('raw data','GRNN','PNN')

figure(3)
% performance
plot(1:10,t(1,:),'r-p',1:10,t(2,:),'b-o')
title('performance comparison')
xlabel('model numble')
ylabel('cost time')
legend('GRNN','PNN')
  