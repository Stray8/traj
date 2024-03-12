%�����켣������Ż�������
clc
clear all
%% �Զ������
joint_num = 7;  %�ؽ���Ŀ
T = 10;    %�켣��������T
dt = 0.1;   %�������dt��dt=0.002�������ݵ��������ʱ����ã��������dt=0.1
t = 0:dt:T; %ʱ��t
N = size(t,2); %���ع켣����
w = 2*pi/T;    %Ƶ��w
Fourier_N = 3;  %����Ҷ����

%% ���ùؽ�Լ��
% qmin:�ؽڽǶ���Сֵ; qmax:�ؽڽǶ����ֵ; dqmin:�ؽڽ��ٶ����ֵ; qmin:�ؽڽǼ��ٶ����ֵ;
qmin = [-165;-115;-165;-115;-165;-115;-355]/180*pi;   %qmin = -ones(6,1)*120/180*pi;
qmax = [165;115;165;115;165;115;355]/180*pi; %qmax = ones(6,1)*120/180*pi;
dqmax = [2.175;2.175;2.175;2.175;2.610;2.610;2.610]; %/180*pi;%dqmax = ones(6,1)*80/180*pi; %dqmax = ones(6,1)*40/180*pi; 
ddqmax = [15;7.5;10;10;15;15;20]; %/180*pi;%ddqmax = ones(6,1)*24/180*pi; %ddqmax = ones(6,1)*12/180*pi;
q_offset = (qmin+qmax)/2; %�Ƕ�Լ���е�

%% �Ż�
A=[];
b=[];
Aeq=[];
beq=[];
lb=[];
ub=[];

OPTIONS =optimoptions('fmincon','Algorithm','active-set');  

%���ø���Ҷ����ϵ��x�ĳ�ʼֵ
%1) һ��ʼ,����ѡ����������ʼ
x_temp = -1+rand(joint_num*(2*Fourier_N+1),1)*2;
%2����֮ǰĳ�ε��Ż������ʼ
% loadpath = 'Traj_fuhe_002_20s_3_newcon1_80.mat';
% x_temp =  load(loadpath);
% x_temp = x_temp.x;


%�Ż�Ŀ��Ϊ����������COND(x)��Լ��Ϊmycon(x), �Ż�����Ҷ����ϵ��x
% fmincon������
% �ĸ�����ֵ��x�����Ž⣬fval���غ�����x���Ľ⣬exitflagΪ�˳�������ֵ��output���Ż�������Ϣ�Ľṹ��
% [x,fval,exitflag,output] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
% funΪ�Ż�������x0Ϊ
[x,fval,exitflag,output] = fmincon(@(x) COND(x),x_temp,A,b,Aeq,beq,lb,ub,@(x) mycon(x),OPTIONS);


%% �����Ż�ϵ�����㸵��Ҷ���������켣
dt = 0.01;   %��ʱ����dt=0.002
t = 0:dt:T; %ʱ��t
N = size(t,2); %�켣����

q = zeros(joint_num,N); dq = zeros(joint_num,N); ddq = zeros(joint_num,N);
for i = 1:joint_num
    for j = 1:Fourier_N
        q(i,:) = q(i,:) + x(2*j-1+(2*Fourier_N+1)*(i-1))/(w*j)*sin(w*j*t) - x(2*j+(2*Fourier_N+1)*(i-1))/(w*j)*cos(w*j*t);
        dq(i,:) = dq(i,:) + x(2*j-1+(2*Fourier_N+1)*(i-1))*cos(w*j*t) + x(2*j+(2*Fourier_N+1)*(i-1))*sin(w*j*t);
        ddq(i,:) = ddq(i,:) + (-x(2*j-1+(2*Fourier_N+1)*(i-1))*w*j*sin(w*j*t) + x(2*j+(2*Fourier_N+1)*(i-1))*w*j*cos(w*j*t));
    end
    q(i,:) = q(i,:) + x((2*Fourier_N+1)*i);
end

% ��ͼ
figure,
% plot(t,q'*180/pi)
plot(t, q(1,:)*180/pi, 'r', ...
     t, q(2,:)*180/pi, 'g', ...
     t, q(3,:)*180/pi, 'b', ...
     t, q(4,:)*180/pi, 'c', ...
     t, q(5,:)*180/pi, 'm', ...
     t, q(6,:)*180/pi, 'y', ...
     t, q(7,:)*180/pi, 'k','LineWidth', 1.0);
title('�����켣�ؽڽǶ�����'); xlabel('ʱ��(s)'); ylabel('�Ƕ�(rad)');
legend('�ؽ�1', '�ؽ�2','�ؽ�3', '�ؽ�4','�ؽ�5', '�ؽ�6','�ؽ�17');


q = [q].';
t = [t].';
dlmwrite('dq.txt',q,'delimiter',',');
dlmwrite('t.txt',t,'delimiter',',');


%% ��չ�ɶ�����
% q = [q,q]; dq = [dq,dq]; ddq = [ddq,ddq];
% t = [0:0.002:0.002*(size(q,2)-1)];