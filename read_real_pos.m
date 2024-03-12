clc;
clear all;

file = 'D:/robot_dynamic_identify/generate_trajectory/position.txt';

file_da = 'D:/robot_dynamic_identify/generate_trajectory/torque.txt';


fid = fopen(file, 'r');
C = textscan(fid, 'Position: [ %f, %f, %f, %f, %f, %f, %f ]');  % 按行读取数据
fclose(fid);

y = fopen(file_da, 'r');
D = textscan(fid, 'Torque: [ %f, %f, %f, %f, %f, %f, %f ]');  % 按行读取数据
fclose(fid);

position_data = [C{1}, C{2}, C{3}, C{4}, C{5}, C{6}, C{7}];
torque_data = [D{1}, D{2}, D{3}, D{4}, D{5}, D{6}, D{7}];

figure;
plot(position_data(:, 1),'r');
hold on;
plot(position_data(:, 2), 'g');
plot(position_data(:, 3), 'b');
plot(position_data(:, 4), 'c');
plot(position_data(:, 5), 'm');
plot(position_data(:, 6), 'y');
plot(position_data(:, 7), 'k');
xlabel('t');
ylabel('position');
title('Plot of position Data');  % 设置图标题
legend('joint 1', 'joint 2', 'joint 3', 'joint 4','joint 5', 'joint 6', 'joint 7');  % 添加图例，对应每个数据系列的标签
figure;
plot(torque_data(:, 1),'r');
hold on;
plot(torque_data(:, 2), 'g');
plot(torque_data(:, 3), 'b');
plot(torque_data(:, 4), 'c');
plot(torque_data(:, 5), 'm');
plot(torque_data(:, 6), 'y');
plot(torque_data(:, 7), 'k');
xlabel('t');
ylabel('torque');
title('Plot of torque Data');  % 设置图标题
legend('joint 1', 'joint 2', 'joint 3', 'joint 4','joint 5', 'joint 6', 'joint 7');  % 添加图例，对应每个数据系列的标签
% plot(t, position_data(1,:)*180/pi, 'r', ...
%      t, position_data(2,:)*180/pi, 'g', ...
%      t, position_data(3,:)*180/pi, 'b', ...
%      t, position_data(4,:)*180/pi, 'c', ...
%      t, position_data(5,:)*180/pi, 'm', ...
%      t, position_data(6,:)*180/pi, 'y', ...
%      t, position_data(7,:)*180/pi, 'k','LineWidth', 1.0);
%  