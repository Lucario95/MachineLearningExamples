function [w,b,iterations] = PLA1(x,y,wi,bi,maxIterations)
%UNTITLED 
%     err = n. of misclassified samples 
    w = wi;
    b = bi;
    err = Inf;
    i = 1; 
    iterations = 0;
    
%   Iteration phase:  
    while err > 0
        f = x(i,:)*w + b;
        if y(i)*f <= 0 
            w = w + y(i)*x(i,:)';
            b = b + y(i);
            [err,~] = computeError(x,y,w,b);
        end
        iterations = iterations + 1;
        if iterations >= maxIterations
            break;
        end
        i = max(mod(i + 1, size(x,1)+1), 1);
    end
end