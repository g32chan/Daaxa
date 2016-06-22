function config = readConfigFile(filename)
%% Check if valid filename
fid = fopen(filename);
if fid == -1
    error('Cannot open config file');
end

%% Read config file
frewind(fid);
i = 0;
while ~feof(fid)
    temp = fread(fid, 1, '*char');
    if temp == '/'
        temp = fread(fid, 1, '*char');
        if temp == 'I'
            i = i + 1;
            config(i).SV            = fscanf(fid, '%d', 1);
            config(i).CAlow         = fscanf(fid, '%d', 1);
            config(i).CAhigh        = fscanf(fid, '%d', 1);
            config(i).DopplerOffset = fscanf(fid, '%d', 1);
            config(i).DopplerRange  = fscanf(fid, '%d', 1);
            config(i).DopplerStep   = fscanf(fid, '%d', 1);
            config(i).FrontEnd      = fscanf(fid, '%d', 1);
            config(i).DopplerBin    = fscanf(fid, '%d', 1);
            config(i).CodeSlide     = fscanf(fid, '%f', 1);
            config(i).NoiseFloor    = fscanf(fid, '%f', 1);
            config(i).LogTime       = fscanf(fid, '%f', 1);
            config(i).StartLogMs    = fscanf(fid, '%d', 1);
            config(i).BlockOffset   = fscanf(fid, '%d', 1);
            config(i).BitOffset     = fscanf(fid, '%d', 1);
            config(i).IntTime       = fscanf(fid, '%f', 1);
            config(i).IntOffset     = fscanf(fid, '%f', 1);

            config(i).IntTimeInt = uint32(config(i).IntTime);
            if config(i).IntTimeInt < 1
                config(i).IntTimeInt = 1;
            end
            if config(i).IntTime < 1
                temp = config(i).IntOffset + config(i).IntTime;
                if temp > 1
                    config(i).IntOffset = 0;
                end
            end
        end
    end
end

fclose(fid);

end

