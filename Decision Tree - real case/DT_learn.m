function T = DT_learn(X,Y,depth,fileID)
%     plotted = 0;
    if (depth == 0 || length(unique(Y)) == 1 )
        T.isleaf = true;
        T.class = mode(Y);
%   Con il FIX non dovrebbe più accadere:
    elseif (isempty(X))
        T.isleaf = true;
        T.class = NaN;
    else
        T.isleaf = false;
        [n, d] = size(X);
        err_best = +Inf;
        for i1 = 1:d
            [vX, i] = sort(X(:,i1),'Ascend');
            vY = Y(i);
            if(length(unique(X(:,i1))) == 1)
               continue; 
            end
            for i2 = 1:n-1
                if (vY(i2) ~= vY(i2+1))
                    if(vX(i2) == vX(i2+1))
%                         PER EVENTUALI DEBUG FUTURI
%                         if plotted == 0
%                             figure, hold on, grid on
%                             plot(vX(vY == 1), vY(vY == 1), 'ob');
%                             plot(vX(vY == -1),vY(vY == -1),'or');
%                             plotted = 1;
%                         end
                        continue;
                    end
                    err = mean([vY(1:i2)~=mode(vY(1:i2));...
                                vY(i2+1:end)~=mode(vY(i2+1:end))]);
                    if (err_best > err)
                        err_best = err;
                        T.f = i1;
                        T.c = (vX(i2)+vX(i2+1))/2;
                    end
                end
            end
        end
%         fwrite(fileID,"--------------------------------------------");
%         fwrite(fileID,newline);
%         for i = 1:n
%             for j = 1:d
%                 fwrite(fileID,sprintf('%e, ',X(i,j)));
%             end
%             fwrite(fileID,newline);
%         end
        f = X(:,T.f) <= T.c;
        T.left = DT_learn(X(f,:),Y(f),depth-1,fileID);
        T.right = DT_learn(X(~f,:),Y(~f),depth-1,fileID);
    end
end