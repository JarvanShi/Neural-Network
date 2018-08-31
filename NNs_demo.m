%%
% 辛烷值是衡量汽油品质的重要指标，最近发展起来的近红外光谱分析方法（NIR）测定辛烷值
% 采集60组汽油样品，每组401个数据值

%% 3.1 清空环境变量
clear all
clc

%% 3.2 产生训练集、测试集、（验证集）
%%
% 1.导入数据
load spectra_data.mat

%%
% 2.产生随机数据集，训练集和测试集，（验证集）

temp = randperm(size(NIR,1));

%训练集----50样本
P_train = NIR(temp(1:50),:)';
T_train = octane(temp(1:50),:)';

%测试集----10样本
P_test = NIR(temp(51:end),:)';
T_test = octane(temp(51:end),:)';

N = size(P_test,2);

%% 3.3 归一化处理
[p_train,PS_input] = mapminmax(P_train,0,1); %得到输入数据的归一化配置信息
p_test = mapminmax('apply',P_test,PS_input);

[t_train,PS_output] = mapminmax(T_train,0,1); %得到输出数据的归一化配置信息

%% 3.4 BP神经网络创建、训练、仿真
% 1.创建网络
net = feedforwardnet(9);  % 9 hidden layers
% newff在新版本中已经被替换为feedforwardnet

%%
% 2.设置网络参数
% net = configure(net,I_train,O_train); %自动设置参数
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-3;
net.trainParam.lr = 0.01;

%%
% 3.训练网络
net = train(net,p_train,t_train);

%%
% 4. 仿真测试
t_sim = sim(net,p_test);

%%
% 5. 反归一化
T_sim = mapminmax('reverse',t_sim,PS_output);

%% 3.5 性能评价
%%
% 1.相对误差
error = abs(T_sim - T_test)./T_test;

%%
% 2.拟合优度
% gof = goodnessOfFit(T_sim',T_test','MSE');
% disp(['拟合优度：',num2str(gof)])
gof = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 

%%
% 3.结果对比
result = [T_sim',T_test',error']

%% 3.6 绘图
plot(1:N,T_sim,'r-',1:N,T_test,'b--')
string = {'辛烷值含量预测对比',['R^2=：',num2str(gof)]};
title(string)
xlabel('样本')
ylabel('辛烷值含量')
legend('估计值','原始值')
