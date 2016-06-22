function getPPS(pps, raw)
for i = 1:20
    temp2 = int32(0);
    for j = 0:3
        temp = fread(raw, 1, 'int8=>int32');
        temp1 = bitand(int32(255), temp);
        temp2 = bitor(bitshift(temp1, j * 8), temp2);
    end
    
    temp = fread(raw, 1, 'int8=>int32');
    temp1 = bitand(int32(255), temp);
    
    fread(raw, 3, 'int8=>int32');
    
    fprintf(pps, '%12d %4d\n', temp2, temp1);
end

end

