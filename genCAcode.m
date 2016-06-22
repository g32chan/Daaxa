function cacode = genCAcode(codeRate, sfreq, svnum, codeCycles)
%% Generate CA Code
code = generateCAcode(svnum);

%% Resize CA Code to sampling size
step = codeRate / sfreq;
temp1 = 0:step:(1023 * codeCycles - step);
temp2 = floor(temp1);
temp3 = rem(temp2 ./ (codeRate / 1000), 1);
index = floor(temp3 .* (codeRate / 1000)) + 1;
% index = floor(temp1) + 1;
cacode = code(index);

end

