function [X, Y] = generateDataset(n,d)
%GENERATEDATASET Genera un numero n di sample in cui x ha dimensionalità d
%mentre y è uno scalare che rappresenta la classe del punto x.
%   La funzione scelta per modellare il set è y = x^2 + b ;
    epsilon = 2;
    sigma = 1;
    b = 4;
    X = [sigma*randn(n/2,d)+epsilon;sigma*randn(n/2,d)-epsilon];
    Y = [ones(n/2,1);-ones(n/2,1)];
%     X(:,1) = 20*randn(n,1);
%     X(:,2) = X(:,1).^2 + b;
%     Y = zeros(n,1);
%     j = 0;
%     for i = randperm(n)
%         j = j + 1;
%         if j > n/2
%             X(i,2) = X(i,2) + abs(epsilon*randn(1,1)) + sigma*randn(1,1);
%             Y(i) = 1;
%         else
%             X(i,2) = X(i,2) - abs(epsilon*randn(1,1)) + sigma*randn(1,1);
%             Y(i) = -1;
%         end
%     end
%% Normalizzazione dei dati [-1;1]
    for i = 1:d
       m = min(X(:,i));
       M = max(X(:,i));
       X(:,i) = 2*(X(:,i)-m)/(M-m)-1;
    end
end

