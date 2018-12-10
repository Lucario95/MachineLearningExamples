function height = doHeight(T)
%DOHEIGHT 
%     return condition:
    if T.isleaf == true
        height = 0;
%     recursion:
    else
        heightLeft = doHeight(T.left);
        heightRight = doHeight(T.right);
        height = max([heightLeft, heightRight]) + 1;
    end
end

