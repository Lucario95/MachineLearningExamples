function nothing = plotAll(d,X,Y1,Y2)
feature = ["Temperature of patient", "Occurrence of nausea", "Lumbar pain",...
    "Urine pushing", "Micturition pains", "Burning of urethra"];
output = ["Inflammation of urinary bladder", "Nephritis of renal pelvis origin "];
%PLOTALL
for i = 1:d
    figure
    hist(X(:,i),40);
    legend(sprintf('feature %d - %s',i, feature(i)));
end
figure
hist(Y1,40);
legend(sprintf('output 1 - %s', output(2)));

figure
hist(Y2,40);
legend(sprintf('output 1 - %s', output(2)));
nothing = 0;
end

