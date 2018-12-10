function [dualitygap] = getDualityGap(n,alpha,Q,Y,X,b,C,gamma)
%GETDUALITYGAP
    dualcost = -(.5*alpha'*Q*alpha-ones(n,1)'*alpha);
    primalcost = .5*(Y.*alpha)'*(kernel(X,X,gamma)*(Y.*alpha))+ ...
        C*sum(max(0,1-diag(Y)*((kernel(X,X,gamma)*(Y.*alpha)) + b*ones(size(X,1),1)))); 
    dualitygap = abs(dualcost-primalcost);
end

