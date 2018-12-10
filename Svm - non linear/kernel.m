function [output] = kernel(u, v, gamma)
%KERNEL 
    output = exp(-gamma*pdist2(u,v));
end

