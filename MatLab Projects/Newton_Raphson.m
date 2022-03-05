
clc
clear all

%Definición variable n, cantidad de nodos del sistema.
n = 5;
%Contador de iteraciones.
k = 1;
%Límite para la norma infinito.
eps = 1e-6;
%Número de iteraciones.
N = 2;
%Variable de almacenamiento de la norma infinito
dif = 1;

%Vector solución inicial.
x0 = [ 0.0 0.0 0.0 0.0 1.0 1.0].';
%Matriz de admitancias del sistema.
Y = [2-20i -1+10i 0 -1+10i 0;-1+10i 3-30i -1+10i -1+10i 0;0 -1+10i 2-20i 0 -1+10i;-1+10i -1+10i 0 3-30i -1+10i;0 0 -1+10i -1+10i 2-20i];

%Datos conocidos del sistema.
PG2 = 0.8830;
PG3 = 0.2076;
SG2 = 0;
SG3 = 0;
V1 = 1;
Tetta1 = 0;
V2 = 1;
V3 = 1;

SD4 = 1.7137 + 0.5983i;
SD5 = 1.7355 + 0.5496i;

%Reaciones nodales de generación y carga.

P2 = PG2;
P3 = PG3;
P4 = -(real(SD4));
P5 = -(real(SD5));
Q4 = 1 -(imag(SD4)); %Iyección de potencia reactiva gracias a la cap conectada.
Q5 = 0.8 -(imag(SD5)); %Iyección de potencia reactiva gracias a la cap conectada.

%Definición de vectores que almacenan la relación anterior.
P = [0 P2 P3 P4 P5].';
Q = [0 0 0 Q4 Q5].';
 
%Definición del vector que almacenará las respuestas iterativas del
%sistema.
x = 0;
%Declaración de las variables no conocidas.
Tetta2 = 0;
Tetta3 = 0;
Tetta4 = 0;
Tetta5 = 0;
V4 = 1;
V5 = 1;

%Declaración de los vectores que almacenarán las fases y voltajes del
%sistema.
Tetta = [Tetta1;Tetta2;Tetta3;Tetta4;Tetta5];
V =  [V1;V2;V3;V4;V5];

%Declaración del vector que almacenará la diferencia de cada iteración.
deltax = zeros(6,1);
%Pre declaración matriz jacobiana.
Jx = zeros(6);


%Declaración del proceso iterativo en terminos de la variables k y dif.
while (k<=N)&&(dif>eps)
    
    %Creación de vectores y matrices necesarias las cuales se actualizarán
    %por cada iteración.
    Px = zeros(n,1);
    Qx = zeros(n,1);
    fx = zeros(6,1);
    
    J11 = zeros(4);
    J12 = zeros(4,2);
    J21 = zeros(2,4);
    J22 = zeros(2);
    
    %Actualización de las potencias activa y reactuva en terminos de las
    %incognitas. Es importante el uso de las funciones sind y cosd por
    %relación grados y rads.
    for i=2:n
        for j=1:n
            
            Px(i) = Px(i) + (abs(V(i)))*abs(V(j))*((real(Y(i,j)))*cosd((Tetta(i))-Tetta(j)) + (imag(Y(i,j)))*sind((Tetta(i))-Tetta(j)));
            
            if i>=4 
                Qx(i) = Qx(i) + (abs(V(i)))*abs(V(j))*((real(Y(i,j)))*sind((Tetta(i))-Tetta(j)) - (imag(Y(i,j)))*cosd((Tetta(i))-Tetta(j)));
            end
        end
    
        
    end
   
  
  %Actualización de las submatrices jacobianas. Importante usar funciones
  %sind y cosd para evitar errores. 
   for u = 1:n
       for f = 1:n
           
           %Creaciòn J11
           if (u<=4)&&(f<=4)
               J11(u,f) = (abs(V(u+1)))*(abs(V(f+1)))*((real(Y(u+1,f+1)))*sind(Tetta(u+1)-Tetta(f+1))-(imag(Y(u+1,f+1)))*cosd(Tetta(u+1)-Tetta(f+1)));
           
           elseif (u == f)&&(u<=4)&&(f<=4)
               J11(u,f) = -Qx(u+1) - (imag(Y(u+1,u+1)))*((abs(V(u+1)))^2);
           end
          
           %Creación J12
           if  (u<=4)&&(f<=2)
               J12(u,f) = (abs(V(u+1)))*((real(Y(u+1,f+3)))*cosd(Tetta(u+1)-Tetta(f+3)) + (imag(Y(u+1,f+3)))*sind(Tetta(u+1) - Tetta(f+3)));
           elseif (u==3) && (f ==1)
               J12(u,f) = (Px(u+1))/(abs(V(u+1))) + (real(Y(u+1,u+1)))*abs(V(u+1));
           elseif (u==4) && (f==2)     
               J12(u,f) = (Px(u+1))/(abs(V(u+1))) + (real(Y(u+1,u+1)))*abs(V(u+1));
           end
           
           %Creaicón J21
           if (u<=2)&&(f<=4)
               J21(u,f) = -(abs(V(u+3)))*(abs(V(f+1)))*((real(Y(u+3,f+1)))*cosd(Tetta(u+3)-Tetta(f+1)) +(imag(Y(u+3,f+1)))*sind(Tetta(u+3)-Tetta(f+1)));
           elseif (u==1)&&(f==3)
               J21(u,f) = (Px(u+3))-(real(Y(u+3,u+3)))*((abs(V(u+3)))^2);
           elseif (u==2)&&(f==4)
               J21(u,f) = (Px(u+3))-(real(Y(u+3,u+3)))*((abs(V(u+3)))^2);
           
           end
           
           %Creación J22
           if (u<=2)&&(f<=2)
               J22(u,f) = (abs(V(u+3)))*((real(Y(u+3,f+3)))*sind(Tetta(u+3)-Tetta(f+3)) -(imag(Y(u+3,f+3)))*cosd(Tetta(u+3)-Tetta(u+3)));
           elseif (u==1)&&(f==1)
               J22(u,f) = (Qx(u+3))/(abs(V(u+3))) -(imag(Y(u+3,u+3)))*(abs(V(u+3)));
           elseif (u==2)&&(f==2)
               J22(u,f) = (Qx(u+3))/(abs(V(u+3))) -(imag(Y(u+3,u+3)))*(abs(V(u+3)));
           
           end
       
       end   
   end

   %Actualización matriz jacobiana con submatrices ya actualizadas.
    Jx = [J11 J12; J21 J22];
 
    %Actualización vector mismatch.
    for hh = 1:6
        
       if(hh<=4)
          fx(hh) =  P(hh+1)-Px(hh+1);
       else
           fx(hh) = Q(hh-1)-Qx(hh-1);
       end
    
    end 
    
    deltax = (inv(Jx))*(fx);
    %Como el resultado anterior entrega resultados en rads, es importante
    %hacer el respectivo cambio a grados.
    for mm3 =1:4
          deltax(mm3) = radtodeg(deltax(mm3));
    end
    
    %Proceso de actualización de vector solución y demás vectores
    %necesarios.
    x = x0 + deltax;
    V =[V1;V2;V3;x(5);x(6)];
    Tetta=[Tetta1;x(1);x(2);x(3);x(4)];
    x0 = x;
    
    %Se van actualizando las condiciones de parada.
    k = k+1;
    dif = norm(x-x0,inf);
    

end

%Calculo de Potencia compleja en Nodo Slack
Volt = [V(1)*exp(1i*((Tetta(1)))) V(2)*exp(1i*((Tetta(2)))) V(3)*exp(1i*((Tetta(3)))) V(4)*exp(1i*((Tetta(4))))].';
sumS = 0;
for kk = 1:4
    
    sumS = sumS + (conj(Y(1,kk)))*(conj(Volt(kk)));
end

S1 = (Volt(1))*sumS;

%Cálculo perdidas del sistema

Perd = 0;
for dd =1:n
    Perd = Perd + Px(dd);
end


