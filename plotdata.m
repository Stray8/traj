% clc;
% clear all;
% data = load('all1.txt');
% % t = data.t;
% % q = data.q;
% t = data(:, 1);
% 
% % % 画图
% % figure,
% % % plot(t,q'*180/pi)
% % plot(t, q(1,:) , 'r', ...
% %      t, q(2,:), 'g', ...
% %      t, q(3,:), 'b', ...
% %      t, q(4,:), 'c', ...
% %      t, q(5,:), 'm', ...
% %      t, q(6,:), 'y', ...
% %      t, q(7,:), 'k','LineWidth', 1.0);
% % title('激励轨迹关节角度曲线'); xlabel('时间(s)'); ylabel('角度(rad)');
% % legend('关节1', '关节2','关节3', '关节4','关节5', '关节6','关节17');
% 
% % 画图
% figure,
% % plot(t,q*180/pi)
% plot(t, data(:, 2)*180/pi, 'r', ...
%      t, data(:, 3)*180/pi, 'g', ...
%      t, data(:, 4)*180/pi, 'b', ...
%      t, data(:, 5)*180/pi, 'c', ...
%      t, data(:, 6)*180/pi, 'm', ...
%      t, data(:, 7)*180/pi, 'y', ...
%      t, data(:, 8)*180/pi, 'k','LineWidth', 1.0);
% title('激励轨迹关节角度曲线'); xlabel('时间(s)'); ylabel('角度(rad)');
% legend('关节1', '关节2','关节3', '关节4','关节5', '关节6','关节17');
data = load('Traj_fuhe_001_10s_newcon1_80.mat');

joint_num = 7;  %关节数目
T = 10;    %轨迹运行周期T
dt = 0.1;   %采样间隔dt，dt=0.002导致数据点过多运行时间过久，因此设置dt=0.1
t = 0:dt:T; %时间t
N = size(t,2); %返回轨迹点数
w = 2*pi/T;    %频率w
Fourier_N = 3;  %傅里叶级数
x = data.x;
tt = data.t;
qq = data.q;

%% 根据优化系数计算傅里叶级数激励轨迹
dt = 0.002;   %此时更改dt=0.002
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

figure,
% plot(t,q*180/pi)
plot(t, q(1,:)*180/pi, 'r', ...
     t, q(2, :)*180/pi, 'g', ...
     t, q(3, :)*180/pi, 'b', ...
     t, q(4,:)*180/pi, 'c', ...
     t, q(5,:)*180/pi, 'm', ...
     t, q(6,:)*180/pi, 'y', ...
     t, q(7,:)*180/pi, 'k','LineWidth', 1.0);
title('激励轨迹关节角度曲线'); xlabel('时间(s)'); ylabel('角度(rad)');
legend('关节1', '关节2','关节3', '关节4','关节5', '关节6','关节17');

figure,
% plot(t,q*180/pi)
plot(tt, qq(1,:)*180/pi, 'r', ...
     tt, qq(2,:)*180/pi, 'g', ...
     tt, qq(3, :)*180/pi, 'b', ...
     tt, qq(4,:)*180/pi, 'c', ...
     tt, qq(5,:)*180/pi, 'm', ...
     tt, qq(6,:)*180/pi, 'y', ...
     tt, qq(7,:)*180/pi, 'k','LineWidth', 1.0);
title('激励轨迹关节角度曲线qq'); xlabel('时间(s)'); ylabel('角度(rad)');
legend('关节1', '关节2','关节3', '关节4','关节5', '关节6','关节17');
q = q.';
dlmwrite('dq.txt',q,'delimiter',',');

