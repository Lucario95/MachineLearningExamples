clc;
clear;
close all;
%% Ottengo un dataset per il learning:

% Parametri del problema:
n = 200;
d = 2;
c = 2;
C = 1;
minPrecision = 10^-5;
colors = "broygkc";

[X, Y] = generateDataset(n,d);
figure, hold on, box on, grid on
for j = 1:n
    if(Y(j) == 1)
        plot(X(j,1),X(j,2), 'or');
    else
        plot(X(j,1),X(j,2), 'ob');
    end
end

%% Training:
nMaxExp = 30;
k = 50;
testSet = 40;
gaps = zeros(k,k);

for nExp = 1:nMaxExp
    sprintf("Iterazione n° %d/%d", nExp, nMaxExp)
%     [X, Y] = generateDataset(n,d);
    [X, Y, XT, YT] = permDataset(X,Y, 0.70);
    nTemp = size(X,1);
    i = 0;
    for gamma = logspace(-8,8,k)
        i = i + 1;
%         Q = zeros(n,n);
%         for i1 = 1:n
%             for j1 = 1:n
%                 sprintf("%d| %d",i1,j1);
%                 Q(i1,j1) = Y(i1)*Y(j1)*kernel(X(i1),X(j1),gamma);
%             end
%         end
        Q = diag(Y)*kernel(X,X,gamma)*diag(Y);
%         Q = diag(Y)*(X*X')*diag(Y);
        j = 0;
        for C = logspace(-8,8,k)
            j = j + 1;
%             sprintf("Iterazione n° %d | %d | %d", nExp, i, j)
            [~,~,alpha,b] = SMO2_ab(nTemp,Q,-ones(nTemp,1),Y',zeros(nTemp,1),C*ones(nTemp,1), ...
                10^6,10^-3,zeros(nTemp,1));
%         N° alpha > "0"     
%         gaps(i,j) = gaps(i,j) + sum(alpha > C/1000);
%         Valore duality gap
%         dualitygap = getDualityGap(nTemp,alpha,Q,Y,X,b,C,gamma);
%         gaps(i,j) = gaps(i,j) + dualitygap;
%         N°errori di test
%         gaps(i,j) = gaps(i,j) + test(testSet,d,gamma,alpha,X,Y,b);
        gaps(i,j) = gaps(i,j) + testNew(gamma,alpha,b,X,Y,XT,YT);
        end 
    end
end
gaps = gaps/nMaxExp;
minGap = min(gaps(:));
[row,col] = find(gaps==minGap);
row = row(1);
col = col(1);
space = logspace(-8,8,k);
C_best = space(col);
gamma_best = space(row);
[X, Y] = generateDataset(n,d);

Q = diag(Y)*kernel(X,X, gamma_best)*diag(Y);
% Q = diag(Y)*X*X'*diag(Y);
[~,~,alpha,b] = SMO2_ab(n,Q,-ones(n,1),Y',zeros(n,1),C_best*ones(n,1), ...
        10^6,10^-3,zeros(n,1));

% alpha = quadprog(Q,-ones(n,1),[],[],Y',0,zeros(n,1),C*ones(n,1));
% b = 0;
% for i = 1:length(alpha)
%     if alpha(i) > minPrecision
%        b = Y(i) - kernel(X,X(i,:), gamma_best)'*(alpha.*Y);
%     end
% end

%% Forward dei dati del test set:
testSet = 400;
[XV, YV] = generateDataset(testSet,d);
YP = kernel(XV,X, gamma_best)*diag(Y)*alpha+b;
% YP = XV*X'*diag(Y)*alpha + b;
YP = sign(YP(:,1));
err = sum(YV ~= YP);
sprintf("N° errori = %d/%d \n", err, testSet)

%%
figure, hold on, box on, grid on

plot(XV(YV<0,1),XV(YV<0,2),'oc','MarkerSize',5)
plot(XV(YV>0,1),XV(YV>0,2),'om','MarkerSize',5)
plot(XV(YV<-1,1),XV(YV<-1,2),'ob','MarkerSize',5)
plot(XV(YV>+1,1),XV(YV>+1,2),'or','MarkerSize',5)

%%
% figure, hold on, box on, grid on
% plot(X(alpha==0,1),X(alpha==0,2),'sg','MarkerSize',10,'linewidth',5)
% plot(X(alpha>0&alpha<C,1),X(alpha>0&alpha<C,2),'sk','MarkerSize',10,'linewidth',5)
% plot(X(alpha==C,1),X(alpha==C,2),'sy','MarkerSize',10,'linewidth',5)

%%
dualitygap = getDualityGap(n,alpha,Q,Y,X,b,C_best,gamma_best);
title(sprintf('DG: %e',dualitygap))