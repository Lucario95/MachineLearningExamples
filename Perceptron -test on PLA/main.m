clc
clear;
close all;
%% LOAD DEI DATI

X = importdata('face_x.txt');
Y = importdata('face_y.txt');

maxIterations = 10^7;
sigma = 1;
wi = sigma*randn(size(X,2),1);
bi = sigma*randn();
tic;
[w,b,iterations] = PLA1(X,Y,wi,bi,maxIterations);
elapsedTime1 = toc;
if iterations >= maxIterations
   sprintf("Attenzione, numero massimo di iterazioni superato"+ ...
        " confrontando classi %d e %d,\nprobabilmente non sono"+ ...
        " classi linearmente separabili.\nIl test di"+...
        " comparazione fra i tempi di calcolo non sarà reliable",CLASSES(i,1),CLASSES(i,2))
end

tic;
[w,b,iterations] = PLA2(X,Y,wi,bi,maxIterations);
elapsedTime2 = toc;
risparmio = (-elapsedTime2+elapsedTime1)/iterations*1000;
elapsedTime1 = round(elapsedTime1*100)/100;
elapsedTime2 = round(elapsedTime2*100)/100;

sprintf("Tempo di calcolo dell'algoritmo base: %.2d secondi\n"+...
    "Tempo di calcolo dell'algoritmo ottimizzato: %.2d secondi\n"+...
    "Su un totale di %d iterazioni (%.2e ms risparmiati ad iterazione)",...
    elapsedTime1,elapsedTime2,iterations,risparmio)