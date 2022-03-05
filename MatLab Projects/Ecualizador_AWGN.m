
%% Ecualizador con AWGN

nSamp=5; %muestras por simbolo
Fs=100; %Frecuencia de muestreo
Ts=1/Fs; %Tiempo de muestreo
Tsym=nSamp*Ts; %Periodo de simbolo

k=6; %Define los límites del canal
t=-k*Tsym:Ts:k*Tsym; %Vector tiempo canal

h=1./(1+(t/Tsym).^2); %Modelo del canal

N0=0.1; %Desviación estándar del canal AWGN
varA=1
varN=N0^2;
SNR=10*log(sqrt(varA/varN))

h=h+N0*randn(1,length(h)); %Adición del ruido al canal

h_c=h(1:nSamp:end); %Submuestreo para representar la tasa de muestreo del símbolo

t_inst=t(1:nSamp:end); %Muestreo del vector de tiempo

figure;

plot(t,h); hold on;

stem(t_inst,h_c,'r');

title('Modelo del canal');
xlabel('Tiempo')
ylabel('Amplitud')

nTaps=14; %Número deseado de elementos del ecualizador
[h_eq,MSE,optDelay]=ecualizadorMMSE(h_c,SNR,nTaps);

xn=h_c; %Canal muestreado
yn=conv(h_eq,xn) %Respuesta del sistema

[H_c,W]=freqz(h_c); %Respuesta en frecuencia (radianes) del canal
[H_eq,W]=freqz(h_eq); %Respuesta en frecuencia del filtro
[H_sys,W]=freqz(yn); %Respuesta en frecuencia del sistema

figure;
plot(W, 20*log(abs(H_c)/max(abs(H_c))),'g'); hold on;
plot(W, 20*log(abs(H_eq)/max(abs(H_eq))),'r'); 
plot(W, 20*log(abs(H_sys)/max(abs(H_sys))),'k'); 
title('Equalizer response')
xlabel('Frequency')
ylabel('Normalized Magnitude(dB)')
