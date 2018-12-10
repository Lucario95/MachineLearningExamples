clear
close all
clc

%% LOAD dei dati:
data = load("data.csv");
[n, d] = size(data);
d = d-2;

Y1 = data(:,d+1);
Y2 = data(:,d+2);
X = data(:,1:d);
clear data;

%% NORMALIZZIAMO I DATI (fra [-1;1])
for i = 1:d
   m = min(X(:,i));
   M = max(X(:,i));
   X(:,i) = 2*(X(:,i)-m)/(M-m)-1;
end

%% Plot delle feature e degli output per verificarne la buona distribuzione:
% plotAll(d,X,Y1,Y2); %Uso questa funzione così posso evitare facilmente di
% plottare tutto quando non mi serve

%% Split dei dati:
% Abbiamo solo set per il learning e per il test
rndIdx = randperm(n);
distribution = 0.8;
il = rndIdx(1:round(n*distribution));
it = rndIdx(1 + round(n*distribution):end);

%% Costruzione decision tree
h = 16;

fid = fopen("log.txt","w");

% Aumento la possibilità di cache-hit eseguendo il sort degli indici random:
T1 = DT_learn(X(sort(il),:),Y1(sort(il)),h,fid);
T2 = DT_learn(X(sort(il),:),Y2(sort(il)),h,fid);

%%
titlelize(fid,"2 VARIABILE DECISIONALE");
YS2 = DT_forw(T2, X(sort(it),:),fid);
titlelize(fid,"1 VARIABILE DECISIONALE");
YS1 = DT_forw(T1, X(sort(it),:),fid);

effective_height1 = doHeight(T1);
effective_height2 = doHeight(T2);

err1 = sum(YS1~=Y1(sort(it)));
err2 = sum(YS2~=Y2(sort(it)));

sprintf("Errors made during test --> for y1: %d/%d; for y2: %d/%d",err1,length(it),err2,length(it))
fclose(fid);