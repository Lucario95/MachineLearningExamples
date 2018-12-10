clc
clear;
close all;
%% LOAD DEI DATI

X = importdata('iris_x.txt');
Y = importdata('iris_y.txt');

maxIterations = 10^7;
sigma = 1;
wi = sigma*randn(size(X,2),1);
bi = sigma*randn();

%% NORMALIZZAZIONE

for i = 1:size(X,2)
    mi = min(X(:,i));
    ma = max(X(:,i));
    di = ma - mi;
    X(:,i) = 2*(X(:,i)-mi)/di-1;
end

%% SUDDIVISIONE DEI SET IN TRAINING E TEST

subdivision = 0.5;
allIdx = randperm(size(X,1))';
il = allIdx(1:round(subdivision*size(allIdx,1)));
it = allIdx(round(subdivision*size(allIdx,1))+1:end);

XT = X(it,:);
YT = Y(it,:);
X = X(il,:);
Y = Y(il,:);

colors = ["or","ob","og"];
figure, hold on, grid on
for i = 1:max(Y)
    plot(X(Y==i,1),X(Y==i,2), colors(i));
end
legend("Classe 1", "Classe 2", "Classe 3");

%% TRAINING PHASE - ALL VS. ALL

classes = combnk(unique(Y),2);
W = zeros(size(classes,1),size(X,2));
B = zeros(size(classes,1),1);
for i = 1:size(classes,1)
   Ytmp = Y(Y == classes(i,1) | Y == classes(i,2));
   Ytmp(Ytmp == classes(i,1),:) = Ytmp(Ytmp == classes(i,1),:)./Ytmp(Ytmp == classes(i,1),:);
   Ytmp(Ytmp == classes(i,2)) = -Ytmp(Ytmp == classes(i,2))./Ytmp(Ytmp == classes(i,2));
   [w,b,iterations] = PLA(X(Y == classes(i,1) | Y == classes(i,2),:),Ytmp,wi,bi,maxIterations);
   if iterations >= maxIterations
       sprintf("Attenzione, numero massimo di iterazioni superato"+ ...
            " confrontando classi %d e %d,\nprobabilmente non sono"+ ...
            " classi linearmente separabili",classes(i,1),classes(i,2))
   end
   B(i) = b;
   W(i,:) = w';
end

%% TEST PHASE

YP = zeros(size(XT,1),size(classes,1));
for i = 1:size(XT,1)
    for j = 1:size(classes,1)
        YP(i,j) = W(j,:)*XT(i,:)' + B(j);
        YP(i,j) = 0.5*((1-sign(YP(i,j)))*classes(j,2) + (1+sign(YP(i,j)))*classes(j,1));
    end
end
YPredicted = mode(YP,2);

testError = sum(YPredicted ~= YT);
testError = round(testError*100)/100;

%% PLOT DEI SEPARATORI E DEL TEST
figure, grid on, hold on
for i = 1:max(Y)
    plot(XT(YT==i,1),XT(YT==i,2),colors(i));
end

Xsep = randn(10^4, size(X,2));

for i = 1:size(X,2)
    mi = min(Xsep(:,i));
    ma = max(Xsep(:,i));
    di = ma - mi;
    Xsep(:,i) = 2*(Xsep(:,i)-mi)/di-1;
end

rgbColors = [[0.9290, 0.6940, 0.1250]; [0.75, 0, 0.75]; [0, 0.5, 0]];

for j = 1:size(classes,1)
    for i = 1:size(Xsep,1)
        Xsep(i,2) = -(W(j,1)*Xsep(i,1) + B(j))/W(j,2);
    end
    plot(Xsep(:,1),Xsep(:,2),'Color',rgbColors(j,:));
end
legend('Class 1','Class 2','Class 3',...
    sprintf("Separatore classe %d,%d",classes(1,1),classes(1,2)), ...
    sprintf("Separatore classe %d,%d",classes(2,1),classes(2,2)), ...
    sprintf("Separatore classe %d,%d",classes(3,1),classes(3,2)));
title(sprintf("Errore di classificazione nel test: %d/100",testError));