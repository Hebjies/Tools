function [h_eq,MSE,optDelay]= ecualizadorMMSE(h_c,SNR,N)

h_c=h_c(:); %Vector columna
L=length(h_c);
H=convMatrix(h_c,N); %Matriz (L+N-1)*(N-1)
s=size(conj(H')*H);
I=eye(s);
[~,optDelay]=max(diag(H*inv(conj(H')*H+SNR*I)*conj(H'))); %Encontramos el delay optimo
optDelay=optDelay-1; %Cambio para que coincida con indices de Matlab

n0=optDelay;

d=zeros(N+L-1,1); %vector dirac

d(n0+1)=1; %Esgino el elemento distinto de cero

h_eq=inv(conj(H')*H+(SNR)*I)*conj(H')*d; %Encuentro los coeficientes del ecualizador

MSE=inv(SNR)*(1-d'*H*inv(conj(H')*H+(SNR)*I)*conj(H')*d); %Error


end