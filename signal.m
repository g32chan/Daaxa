function sig = signal(raw)
sign = uint32(0);
for i = 0:3
    temp = fread(raw, 1, 'uint8=>uint32');
    temp1 = bitand(uint32(255), temp);
    sign = bitor(bitshift(temp1, i * 8), sign);
end

mag = uint32(0);
for i = 0:3
    temp = fread(raw, 1, 'uint8=>uint32');
    temp1 = bitand(uint32(255), temp);
    mag = bitor(bitshift(temp1, i * 8), mag);
end

sig = zeros(1, 32);
for i = 1:32
    temp = uint32(bitshift(1, i - 1));
    if bitand(sign, temp) > 0
        if bitand(mag, temp) > 0
            sig(i) = 3;
        else
            sig(i) = 1;
        end
    else
        if bitand(mag, temp) > 0
            sig(i) = -3;
        else
            sig(i) = -1;
        end
    end
end

end

