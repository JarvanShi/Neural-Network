%% ��˫����S�ͺ���

% f(x) = 1/(1+exp(-ax)) df = f(x)*(1-f(x))
fplot(@(x) 1/(1+exp(-x)),[-10 10],'r')
hold on

% f(x) = 1/(1+exp(ax)) df = f(x)*(1-f(x))
fplot(@(x) 1/(1+exp(x)),[-10 10],'r')
hold on

% f(x) = 2/(1+exp(-ax))-1 df = a*(1-f(x)^2)/2
fplot(@(x) 2/(1+exp(-x))-1,[-10 10],'b--')
hold on

% f(x) = 2/(1+exp(ax))-1 df = a*(1-f(x)^2)/2
fplot(@(x) 2/(1+exp(x))-1,[-10 10],'b--')
hold on

% 3. tansig(x)˫��S�ͺ���
% 4. logsig(x)S�ͺ���
x = -10:0.1:10;
plot(x,tansig(x),'k',x,logsig(x),'k')