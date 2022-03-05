
%% Cargar datos de Simulink
load('errores.mat');

M = 2;
EbNo = 0:12;
Exp = [BER0(7501,1) BER1(7501,1) BER2(7501,1) BER3(7501,1) BER4(7501,1) BER5(7501,1) BER6(7501,1) BER7(7501,1) BER8(7501,1) BER9(7501,1) BER10(7501,1) BER11(7501,1) BER12(7501,1)];
theory =  berawgn(EbNo,'fsk',M, 'noncoherent');
semilogy(EbNo,theory);
xlim([0 12])
grid on 
hold on
semilogy(EbNo,Exp)
xlim([0 12])
title('BFSK AWGN noncoherent detection')
ylabel('BER')
xlabel('Eb/No (dB)')
legend('Teórico', 'Experimental')