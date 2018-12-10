clc;
clear;
close all;
%% Ottengo un dataset per il learning:

% Parametri del problema:
n = 100;
d = 2;
c = 2;
C = 10^7;
gamma = 10^-4;
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
% Q = diag(Y)*kernel(X,X, gamma)*diag(Y);
Q = zeros(n,n);
for i = 1:n
    for j = 1:n
        Q(i,j) = Y(i)*Y(j)*kernel(X(i),X(j),gamma);
    end
end
% alpha = quadprog(Q,-ones(n,1),[],[],Y',0,zeros(n,1),C*ones(n,1));
% b = 0;
% for i = 1:length(alpha)
%     if alpha(i) > minPrecision
%        b = Y(i) - kernel(X,X(i,:), gamma)'*(alpha.*Y);
%     end
% end
[~,~,alpha,b] = SMO2_ab(n,Q,-ones(n,1),Y',zeros(n,1),C*ones(n,1), ...
    10^9,10^-4,zeros(n,1));

%% Forward dei dati del test set:
testSet = 10000;
[XV, YV] = generateDataset(testSet,d);
YP = (kernel(XV,X,gamma)*(Y.*alpha)) + b*ones(size(XV,1),1);
err = sum(sign(YV(:,1)) ~= sign(YP(:,1)));
sprintf("N° errori = %d/%d \n", err, testSet)

%%
figure, hold on, box on, grid on

plot(XV(YP<0,1),XV(YP<0,2),'oc','MarkerSize',5)
plot(XV(YP>0,1),XV(YP>0,2),'om','MarkerSize',5)
plot(XV(YP<-1,1),XV(YP<-1,2),'ob','MarkerSize',5)
plot(XV(YP>+1,1),XV(YP>+1,2),'or','MarkerSize',5)

%%
% figure, hold on, box on, grid on
% plot(X(alpha==0,1),X(alpha==0,2),'sg','MarkerSize',10,'linewidth',5)
% plot(X(alpha>0&alpha<C,1),X(alpha>0&alpha<C,2),'sk','MarkerSize',10,'linewidth',5)
% plot(X(alpha==C,1),X(alpha==C,2),'sy','MarkerSize',10,'linewidth',5)

%%
dualcost = -(.5*alpha'*Q*alpha-ones(n,1)'*alpha);
primalcost = .5*(Y.*alpha)'*(kernel(X,X,gamma)*(Y.*alpha))+ ...
    C*sum(max(0,1-diag(Y)*((kernel(X,X,gamma)*(Y.*alpha)) + b*ones(size(X,1),1)))); 
dualitygap = abs(dualcost-primalcost);
title(sprintf('DG: %e',dualitygap))