clc;
clear;
close all;
% Laboratorio 1
% Comunicações Móveis 2022Q2
% Autor: Alex Zaneratto Cavalcante

% Vetores Das medidas

htx = 1.07; % Altura da antena de transmissão [metros]
hrx = 1;    % Altura da antena Móvel [metros]

dvec = [1 2 3 4 5 6 7 8 9];  % Vetor de distancias em [metros]
dref = dvec(1);

PrdBmvec = [-32 -43 -46 -48 -50 -59 -68 -65 -73]; % Vetor de Potencias medidas em [Dbm]
PrxdBmRef = PrdBmvec(1);

% Parâmetros
f= 900e6; c=3e8; lamb= c/f;

% Distancia critica
Dc = (4*htx*hrx/lamb)

syms gam  ; % Variavel simbolica que representa o coeficiente de propagação

PrxdBmvec = subs(zeros(1,length(PrdBmvec)));

%% variaveis auxiliares
k = 0;
n = 1;
m = 1;
%%


while n <= length(PrxdBmvec)
    
  PrxdBmvec(n) = PrxdBmRef + 10*gam*log10(dref/dvec(n));
  mmse_gama(n) = (PrdBmvec(n)- PrxdBmvec(n))^2;
  k = k +  PrxdBmvec(n);
  n = n+1;
end
d = 0;

while m <= length(mmse_gama)
   d = d + mmse_gama(m);
   m = m+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%

D(gam) = d;
derivada_gama = diff(d);
gama = solve(derivada_gama);  %%valor do coeficiente
disp(gama);

var_shadow = D(gama)/length(dvec);
disp(var_shadow);  %% valor da variancia

sigma_shadow = sqrt(var_shadow);
disp(sigma_shadow); %% valor do desvio padrão

%%%%%%%%%%%%%%%%%%%%%%%%%%%


Pr_dBm_100m =  PrxdBmRef - 10*gama*log10(100/dref); % potencia recebida a 100 m






% Calculo das potências recebidas
x = 1 : 0.01 : 9;

GaussRandom= sigma_shadow.*randn;

PrDbm_sem_sh =PrxdBmRef - 10*gama*log10(x./dref); 
PrDbm_com_sh = PrxdBmRef + 10*gama*log10(dref./x) + GaussRandom


%% plot dos gráficos
figure;
semilogx(x, PrDbm_sem_sh,'b', dvec, PrdBmvec, 'r'); grid;
xlabel('distância (m)'); ylabel('P_r (dBm)');

legend('Potencia Recebida Sem efeito Shadowing', 'Potência Medida');

figure;
plot(x, PrDbm_sem_sh,'b', dvec, PrdBmvec, 'r'); grid;
xlabel('distância (m)'); ylabel('P_r (dBm)');
title('Potência Recebida x Tempo');
legend('Potencia Recebida Sem efeito Shadowing', 'Potência Medida');

