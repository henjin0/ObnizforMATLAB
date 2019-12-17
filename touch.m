function touch(filename)
    fileID = fopen(filename,'w');
    fclose(fileID);
end