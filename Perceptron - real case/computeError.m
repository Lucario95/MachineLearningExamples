function [e, YP] = computeError(x,y,w,b)
%COMPUTEERROR 
    e = 0;
%     for i = 1:size(x,1)
%         yp = x(i,:)*w + b;
%         if sign(yp) ~= y(i)
%            e = e + 1; 
%         end
%     end
    YP = x*w + b;
    e = sum(sign(YP) ~= y);
end

