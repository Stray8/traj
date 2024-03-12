a = load('dq.txt');
% t = t.';
% dq = q.';
% dq = [dq];
% all = [t, dq];
a = a.';
dlmwrite('a.txt',a,'delimiter',',');
% dlmwrite('dq1.txt',dq,'delimiter',',');
% dlmwrite('x.txt',x,'delimiter',',');
