%
% Trabalho de Logica Nebulosa
% Guiar um robo por uma linha reta 
%
% Autores:  Marcos Augusto Nolasco do Amaral
%           Patricia Martins Rocca Crestani
%           Thales de Souza Machado

close all
clear all
clc

% Não mostrar as mensagens de Warning
warning off all

vetor_passo = [];
vetor_angulo = [];

% Variaveis que definem o "mundo virtual"
yi=0; yf=100;
xi=0; xf=100;

% Plotagem do "mundo virtual"
Axis = ([xi xf yi yf]);
plot([xi xf xf xi xi],[yi yi yf yf yi]);

% Variaveis para plotagem da linha
yLinha = 3; % Altura da linha que o robo ira seguir
plot_line(0, 100, yLinha, yLinha);
hold on;

fprintf('=>  SISTEMA DE CONTROLE DO ROBO  <= \n \n');
tmp_arq = readfis('roboSeguidorLinha');

controle_passo = 0;
distanciaSensores = 2;
xSensor1 = 0;
xSensor2 = 20;
ySensor1 = 13;
ySensor2 = -13;
xCentro = (xSensor2 + xSensor1) / 2;
yCentro = (ySensor2 + ySensor1) / 2;
plot(xCentro, yCentro);
plot_line(xSensor1, xSensor2, ySensor1, ySensor2);
t = text(xCentro, yCentro, string(controle_passo));
hold on;

axis([0 100 0 100]);

while(xCentro < 100)
   coeficienteAngular = (ySensor2 - ySensor1)/(xSensor2 - xSensor1);
   arctan = atan(coeficienteAngular);
   arctan_deg = arctan * (180/pi);
   saida = evalfis([arctan_deg yCentro], tmp_arq);
   anguloCorrecao = (saida(1) * pi)/180;
   
   xSensor1Passado = xSensor1;
   xSensor2Passado = xSensor2;
   ySensor1Passado = ySensor1;
   ySensor2Passado = ySensor2;
   
   xSensor1 = (xSensor1Passado * cos(anguloCorrecao)) - (ySensor1Passado * sin(anguloCorrecao));
   ySensor1 = (xSensor1Passado * sin(anguloCorrecao)) + (ySensor1Passado * cos(anguloCorrecao));
   xSensor2 = (xSensor2Passado * cos(anguloCorrecao)) - (ySensor2Passado * sin(anguloCorrecao));
   ySensor2 = (xSensor2Passado * sin(anguloCorrecao)) + (ySensor2Passado * cos(anguloCorrecao));
   
   
   xSensor1 = xSensor1 + 1;
   xSensor2 = xSensor2 + 1;
   
   xCentro = (xSensor1 + xSensor2) /2;
   yCentro = (ySensor1 + ySensor2) /2;
   
   plot(xCentro, yCentro);
   plot_line(xSensor1, xSensor2, ySensor1, ySensor2);
   controle_passo = controle_passo + 1;
   t = text(xCentro, yCentro, string(controle_passo));
   fprintf("-----------------------------------------------");
   fprintf("\nPasso %d: \n", controle_passo);
   fprintf("Coeficiente angular %d \n", coeficienteAngular);
   fprintf("xSensor1 %f \n", xSensor1);
   fprintf("Arctan %f \n", arctan_deg);
   fprintf("yCentro %f \n", yCentro);
   fprintf("Angulo correcao %f \n", rad2deg(anguloCorrecao));
   pause(0.0005);
end

