function [w,b,iterations] = PLA(x,y,wi,bi, maxIterations)
%UNTITLED 
%     err = n. of misclassified samples 
    w = wi;
    b = bi;
    err = Inf;
    i = 1; 
    iterations = 0;
   
    F = zeros(size(x,1),1);
    F(i) = x(i,:)*w + b;
    % Iteration phase:  
    while err > 0
        f = F(i);
        if y(i)*f <= 0 
            w = w + y(i)*x(i,:)';
            b = b + y(i);
            [err, F] = computeError(x,y,w,b);
        end
        iterations = iterations + 1;
        i = max(mod(i + 1, size(x,1)+1), 1);
        if iterations > maxIterations
            break;
        end
    end
end