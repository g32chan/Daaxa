function [ ] = readRawData(filename, config, entry)
%% Check if valid filename
raw = fopen(filename);
if raw == -1
    error('Cannot open raw data file');
end

%% Get PPS Information
pps = fopen('RI_PPS.dat', 'w');
getPPS(pps, raw);
fclose(pps);

%% Process Data
parameters;
log = fopen(['DaaxaOut' num2str(entry) '.dat'], 'w');

blksRead = 0;
startBlk = config.BlockOffset;
stopBlkCount = floor((config.LogTime + double(config.IntTimeInt) / 1000) / secondsInBlock) + 2;

place = 1;
firstBit = config.BitOffset + 1;
msNum = 0;

freqMax = 1;
if config.DopplerStep ~=0 && config.DopplerRange ~= 0
    freqMax = 2 * config.DopplerRange / config.DopplerStep;
end
valInt = zeros(freqMax, config.CAhigh - config.CAlow);
valIntIdx = 1:samples;

frewind(raw);
fseek(raw, startBlk, 'bof');

while ~feof(raw)
    sig1 = signal(raw);
    sig2 = signal(raw);
    
    blksRead = blksRead + 1;
    inBlk = blksRead <= stopBlkCount;
    
    if ~feof(raw) && inBlk
        if (place + 31) > (2 * config.IntTimeInt * samples)
            k = 2 * config.IntTimeInt * samples - place + 1;
            i = 1:k;
            n = length(i);
            data1(place:place + n - 1) = sig1(i);
            data2(place:place + n - 1) = sig2(i);
            
            msNum = msNum + config.IntTimeInt;
            [valInt, valIntIdx] = processData(log, config, msNum, valInt, valIntIdx, data1, data2);
            
            place = 1;
            
            i = 0:config.IntTimeInt * samples - 1;
            n = length(i);
            data1(place:place + n - 1) = data1(config.IntTimeInt * samples + i);
            data2(place:place + n - 1) = data2(config.IntTimeInt * samples + i);
            place = place + n;
            
            data1(config.IntTimeInt * samples:end) = 0;
            data2(config.IntTimeInt * samples:end) = 0;
            
            i = k:32;
            n = length(i);
            data1(place:place + n - 1) = sig1(i);
            data2(place:place + n - 1) = sig2(i);
            place = place + n;
        else
            i = firstBit:32;
            n = length(i);
            data1(place:place + n - 1) = sig1(i);
            data2(place:place + n - 1) = sig2(i);
            place = place + n;
            firstBit = 1;
        end
    end
    if ~inBlk
        break
    end
end


fclose(log);

end

