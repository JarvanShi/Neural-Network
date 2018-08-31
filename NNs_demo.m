%%
% ����ֵ�Ǻ�������Ʒ�ʵ���Ҫָ�꣬�����չ�����Ľ�������׷���������NIR���ⶨ����ֵ
% �ɼ�60��������Ʒ��ÿ��401������ֵ

%% 3.1 ��ջ�������
clear all
clc

%% 3.2 ����ѵ���������Լ�������֤����
%%
% 1.��������
load spectra_data.mat

%%
% 2.����������ݼ���ѵ�����Ͳ��Լ�������֤����

temp = randperm(size(NIR,1));

%ѵ����----50����
P_train = NIR(temp(1:50),:)';
T_train = octane(temp(1:50),:)';

%���Լ�----10����
P_test = NIR(temp(51:end),:)';
T_test = octane(temp(51:end),:)';

N = size(P_test,2);

%% 3.3 ��һ������
[p_train,PS_input] = mapminmax(P_train,0,1); %�õ��������ݵĹ�һ��������Ϣ
p_test = mapminmax('apply',P_test,PS_input);

[t_train,PS_output] = mapminmax(T_train,0,1); %�õ�������ݵĹ�һ��������Ϣ

%% 3.4 BP�����紴����ѵ��������
% 1.��������
net = feedforwardnet(9);  % 9 hidden layers
% newff���°汾���Ѿ����滻Ϊfeedforwardnet

%%
% 2.�����������
% net = configure(net,I_train,O_train); %�Զ����ò���
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-3;
net.trainParam.lr = 0.01;

%%
% 3.ѵ������
net = train(net,p_train,t_train);

%%
% 4. �������
t_sim = sim(net,p_test);

%%
% 5. ����һ��
T_sim = mapminmax('reverse',t_sim,PS_output);

%% 3.5 ��������
%%
% 1.������
error = abs(T_sim - T_test)./T_test;

%%
% 2.����Ŷ�
% gof = goodnessOfFit(T_sim',T_test','MSE');
% disp(['����Ŷȣ�',num2str(gof)])
gof = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 

%%
% 3.����Ա�
result = [T_sim',T_test',error']

%% 3.6 ��ͼ
plot(1:N,T_sim,'r-',1:N,T_test,'b--')
string = {'����ֵ����Ԥ��Ա�',['R^2=��',num2str(gof)]};
title(string)
xlabel('����')
ylabel('����ֵ����')
legend('����ֵ','ԭʼֵ')
