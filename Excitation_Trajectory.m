%激励轨迹设计与优化主函数
clc
clear all
%% 自定义参数
joint_num = 7;  %关节数目
T = 10;    %轨迹运行周期T
dt = 0.1;   %采样间隔dt，dt=0.002导致数据点过多运行时间过久，因此设置dt=0.1
t = 0:dt:T; %时间t
N = size(t,2); %返回轨迹点数
w = 2*pi/T;    %频率w
Fourier_N = 3;  %傅里叶级数

%% 设置关节约束
% qmin:关节角度最小值; qmax:关节角度最大值; dqmin:关节角速度最大值; qmin:关节角加速度最大值;
qmin = [-165;-115;-165;-115;-165;-115;-355]/180*pi;   %qmin = -ones(6,1)*120/180*pi;
qmax = [165;115;165;115;165;115;355]/180*pi; %qmax = ones(6,1)*120/180*pi;
dqmax = [2.175;2.175;2.175;2.175;2.610;2.610;2.610]; %/180*pi;%dqmax = ones(6,1)*80/180*pi; %dqmax = ones(6,1)*40/180*pi; 
ddqmax = [15;7.5;10;10;15;15;20]; %/180*pi;%ddqmax = ones(6,1)*24/180*pi; %ddqmax = ones(6,1)*12/180*pi;
q_offset = (qmin+qmax)/2; %角度约束中点

%% 优化
A=[];
b=[];
Aeq=[];
beq=[];
lb=[];
ub=[];

OPTIONS =optimoptions('fmincon','Algorithm','active-set');  

%设置傅里叶级数系数x的初始值
%1) 一开始,可以选择从随机数开始
x_temp = -1+rand(joint_num*(2*Fourier_N+1),1)*2;
%2）从之前某次的优化结果开始
% loadpath = 'Traj_fuhe_002_20s_3_newcon1_80.mat';
% x_temp =  load(loadpath);
% x_temp = x_temp.x;


%优化目标为矩阵条件数COND(x)，约束为mycon(x), 优化傅里叶级数系数x
% fmincon函数：
% 四个返回值：x是最优解，fval返回函数在x处的解，exitflag为退出条件的值，output是优化过程信息的结构体
% [x,fval,exitflag,output] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
% fun为优化函数，x0为
[x,fval,exitflag,output] = fmincon(@(x) COND(x),x_temp,A,b,Aeq,beq,lb,ub,@(x) mycon(x),OPTIONS);


%% 根据优化系数计算傅里叶级数激励轨迹
dt = 0.01;   %此时更改dt=0.002
t = 0:dt:T; %时间t
N = size(t,2); %轨迹点数

q = zeros(joint_num,N); dq = zeros(joint_num,N); ddq = zeros(joint_num,N);
for i = 1:joint_num
    for j = 1:Fourier_N
        q(i,:) = q(i,:) + x(2*j-1+(2*Fourier_N+1)*(i-1))/(w*j)*sin(w*j*t) - x(2*j+(2*Fourier_N+1)*(i-1))/(w*j)*cos(w*j*t);
        dq(i,:) = dq(i,:) + x(2*j-1+(2*Fourier_N+1)*(i-1))*cos(w*j*t) + x(2*j+(2*Fourier_N+1)*(i-1))*sin(w*j*t);
        ddq(i,:) = ddq(i,:) + (-x(2*j-1+(2*Fourier_N+1)*(i-1))*w*j*sin(w*j*t) + x(2*j+(2*Fourier_N+1)*(i-1))*w*j*cos(w*j*t));
    end
    q(i,:) = q(i,:) + x((2*Fourier_N+1)*i);
end

% 画图
figure,
% plot(t,q'*180/pi)
plot(t, q(1,:)*180/pi, 'r', ...
     t, q(2,:)*180/pi, 'g', ...
     t, q(3,:)*180/pi, 'b', ...
     t, q(4,:)*180/pi, 'c', ...
     t, q(5,:)*180/pi, 'm', ...
     t, q(6,:)*180/pi, 'y', ...
     t, q(7,:)*180/pi, 'k','LineWidth', 1.0);
title('激励轨迹关节角度曲线'); xlabel('时间(s)'); ylabel('角度(rad)');
legend('关节1', '关节2','关节3', '关节4','关节5', '关节6','关节17');


q = [q].';
t = [t].';
dlmwrite('dq.txt',q,'delimiter',',');
dlmwrite('t.txt',t,'delimiter',',');


%% 扩展成多周期
% q = [q,q]; dq = [dq,dq]; ddq = [ddq,ddq];
% t = [0:0.002:0.002*(size(q,2)-1)];