%% normalization 归一化

% 1. y = (x-min)/(max-min)
% 2. y = 2*(x-min)/(max-min)-1

x1 = [1 2 4; 1 1 1; 3 2 2; 0 0 0]
[y1,PS] = mapminmax(x1,ymin,ymax);
x2 = [5 2 3; 1 1 1; 6 7 3; 0 0 0];
y2 = mapminmax('apply',x2,PS);  %process setting 流程配置
x1_again = mapminmax('reverse',y1,PS);  % x1=x1_again