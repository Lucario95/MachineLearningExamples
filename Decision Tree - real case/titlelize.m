function titlelize(fid,titleName)
%TITLELIZE 
    fwrite(fid, "------------------------------------"...
            + "----------------------------");
fwrite(fid, newline);
fwrite(fid, titleName);
fwrite(fid, newline);
fwrite(fid, "------------------------------------"...
            + "----------------------------");
fwrite(fid, newline);
end

