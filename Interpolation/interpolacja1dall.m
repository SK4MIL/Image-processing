%interpolacja all
clear;
clc;

%% %%spline
x = 0.01:2*pi/2048:2*pi;
y = sin(1./x);
xx = 0.01 :(2*pi)/512 : (2*pi);

% Interpolacja
 yy =interp1(x, y, xx, 'spline');
 
% wyśwetlanie wykresów
hold on;
subplot(3,1,1)
plot(x,y,'y .',xx,yy,'r', xx, sin(1./xx),'-- b')
%'Markersize',2
title("Interpolacja sin(1/x) - Spline")
axis([-0.2 6.5 -1.3 1.3]);
%% %%cubic
subplot(3,1,2)

% Interpolacja
yy =interp1(x, y, xx, 'cubic');
plot(x,y,'y .',xx,yy,'- r', xx, sin(1./xx),'-- b')
title("Interpolacja sin(1/x) - Keys")
hold on

axis([-0.2 6.5 -1.3 1.3]);

%% %% ndgrid
%oś czsu
t = 0.01:2*pi/512:2*pi;

%oś x - f. interpolowana
x = sign(sin(8*(t)))';

ts = linspace(0.01,(2*pi),512);

[Ts,T] = ndgrid(ts,t);

dt = 2*pi/512;

y = sinc((Ts - T)/dt)*x;
a = 0.01:2*pi/512:2*pi;
b = sign(sin(8*t));
subplot(3,1,3)
plot(t,x,'y .', ts, y, 'r')
title("Interpolacja sin(1/x) - Sinc")
hold on

plot(a,b,'-- b')
hold on

axis([-0.2 6.5 -1.3 1.3]);