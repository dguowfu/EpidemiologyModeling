clear all;

% a+b+c+d+e+f = 1024;
% a+2*b+3*c+4*d+5*e+6*f = 7260;
% x1+y1 = a;
% x2+y2+z2 = b;
% x3+y3 = c;
% x4+y4+z4 = d;
% x5+y5 = e;
% x6+y6 = f;
% x1+2*x2+y4+x5+2*y6 = 375;
% y1+y2+2*z2+x3+2*y3+x4+y4+2*z4+2*x5+2*y5+2*x6+2*y6 = 1887;
% y2+2*x3+y3+3*x4+y4+2*z4+2*x5+3*y5+4*x6+3*y6 = 738;


% a = [x1
% y1
% x2
% y2
% z2
% x3
% y3
% x4
% y4
% z4
% x5
% y5
% x6
% y6];
%     x1y1x2y2z2x3y3x4y4z4x5y5x6y6
% B = [1 1 1 1 1 1;
%     1 2 3 4 5 6];
% re = [1024;7260];
% B\re
a = 266;
b = 402;
c = 388;
d = 159;
e = 20;
f = 5;

eq1=sym('x1+y1 = 266')
eq2=sym('x2+y2+z2 = 402')
eq3=sym('x3+y3 = 388')
eq4=sym('x4+y4+z4 = 159')
eq5=sym('x5+y5 = 20')
eq6=sym('x6+y6 = 5')
eq7=sym('x1+2*x2+y4+x5+2*y6 = 375')
eq8=sym('y1+y2+2*z2+x3+2*y3+x4+y4+2*z4+2*x5+2*y5+2*x6+2*y6 = 1887')
eq9=sym('y2+2*x3+y3+3*x4+y4+2*z4+2*x5+3*y5+4*x6+3*y6 = 738')
[x1,y1,x2,y2,z2,x3,y3,x4,y4,z4,x5,y5,x6,y6]=solve(eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8,eq9, 'x1,y1,x2,y2,z2,x3,y3,x4,y4,z4,x5,y5,x6,y6')


% A = [1 1 0 0 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 1 1 1 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 1 1 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 1 1 1 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 1 1 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 1 1;
%      1 0 2 0 0 0 0 0 1 0 1 0 0 2;
%      0 1 0 1 2 1 2 1 1 2 2 2 2 2;
%      0 0 0 1 0 2 1 3 1 2 2 3 4 3];
%  b = [a b c d e f 375 1887 738]';
%  
%  x = A\b;
