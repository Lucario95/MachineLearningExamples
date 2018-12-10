function Y = DT_forw(T,X,fid)
    n = size(X,1);
    Y = zeros(n,1);
    for i = 1:n
        Ttmp = T;
        fwrite(fid, "------------------------------------"...
            + "----------------------------");
        fwrite(fid, newline);
        fwrite(fid, sprintf("Classificazione dell dato X-%d: [",i));
        fwrite(fid, sprintf(";%f",X(i,:)));
        fwrite(fid, "]");
        fwrite(fid, newline);
        while (true)
            if (Ttmp.isleaf)
                Y(i) = Ttmp.class;
                fwrite(fid, sprintf("Classificazione dell dato %d, scelta CLASSE %d",i, Y(i)));
                fwrite(fid, newline);
%                 fwrite(fid,sprintf('Y(%d)=%d\n',i,Ttmp.class));
                break
            else
                if (X(i,Ttmp.f)<=Ttmp.c)
                    fwrite(fid, sprintf("Classificazione in basse alla feature %d, scelta LEFT"+...
                        " ( %d < %d )",Ttmp.f,X(i,Ttmp.f), Ttmp.c));
                    fwrite(fid, newline);
%                     fwrite(fid,sprintf('X(%d,%d)<=%e\n',i,Ttmp.f,Ttmp.c));
                    Ttmp = Ttmp.left;
                else
                    fwrite(fid, sprintf("Classificazione in basse alla feature %d, scelta RIGHT"+...
                        " ( %d > %d )",Ttmp.f,X(i,Ttmp.f), Ttmp.c));
                    fwrite(fid, newline);
%                     fwrite(fid,sprintf('X(%d,%d)>%e\n',i,Ttmp.f,Ttmp.c));
                    Ttmp = Ttmp.right;
                end
            end
        end
    end
end