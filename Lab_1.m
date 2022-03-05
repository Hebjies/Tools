clc
clear

%% Punto 1
% Seccion A. Generar vector aleatorio
B = randn(50,1);

% Seccion B.  Generar matriz A
A = zeros(10,5);
n = 1;

for i = 1:10
    for j = 1:5
        A(i,j) = B(n);
        n = n + 1;
    end
end

% Seccion C.
origen = [3 3];
N1 = [-10 5];
N2 = [-3 20];
N3 = [4 3];
N4 = [15 20];
N5 = [0 30];

d1 = norm(N1 - origen);
d2 = norm(N2 - origen);
d3 = norm(N3 - origen);
d4 = norm(N4 - origen);
d5 = norm(N5 - origen);

%% Punto 2
f = 2*10^(9);
T = 1/f;
fs = f*25;
Ts = 1/fs;
t = 0:Ts:6*T;

% Señales S1,S2 y S3
s1 = 8*sin(2*pi*f*t);
s2 = -4*sawtooth(2*pi*f*t);
s3 = 5*sin((2*pi*f*t)+(pi/4));
s4 = s1 + s2 - s3;

plot(t,s1,'--');
hold on
grid on
plot(t,s2,'--');
plot(t,s3,'--');
plot(t,s4);
xlabel('Tiempo (seg)');
ylabel('Amplitud');
title('Señales');
legend('S1','S2','S3','S4');
hold off