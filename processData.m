function [valInt, valIntIdx] = processData(log, config, ms, valInt, valIntIdx, data1, data2)
parameters;

numSamples = samples * config.IntTimeInt;

freq = loFreqCentre + config.DopplerOffset - config.DopplerRange;
freqMax = 1;
if config.DopplerStep ~=0 && config.DopplerRange ~= 0
    freqMax = 2 * config.DopplerRange / config.DopplerStep;
end

intLoopLow = 1;
intLoopHigh = numSamples;
if config.IntTime < 1
    intLoopLow = samples * config.IntOffset;
    intLoopHigh = intLoopLow + numSamples;
    if intLoopHigh > numSamples
        intLoopHigh = numSamples;
    end
end

dopplerBin = 0;

for f = 1:freqMax
    freq = freq + config.DopplerStep;
    dopplerBin = dopplerBin + 1;
    
    rate = codeRate + (freq - loFreqCentre) / 1540;
    cacode = genCAcode(rate, samplingFrequency, config.SV, config.IntTime);
    
    timestep = 0.001 / samples;
    t = 0:timestep:0.001 - timestep;
    sinv = sin(2 * pi * freq * t);
    cosv = cos(2 * pi * freq * t);
    
    idx = 0;
    val = zeros(1, config.CAhigh - config.CAlow);
    for c = config.CAlow:config.CAhigh - 1
        idx = idx + 1;
        code = floor(c + (ms - 1) * samplingSlide);
        if code > samples
            code = code - samples;
        end
        
        n = length(intLoopLow:intLoopHigh);
        first = code + 1;
        last = code + n;
        if config.FrontEnd == 1
            temp = data1(first:last);
            Xv = temp .* cacode;
        elseif config.FrontEnd == 4
            temp = data2(first:last);
            Xv = temp .* cacode;
        else
            Xv = zeros(1, n);
        end
        
        Iv = Xv.*sinv;
        Qv = Xv.*cosv;
        I = sum(Iv) / double(numSamples);
        Q = sum(Qv) / double(numSamples);
        
        val(idx) = I^2 + Q^2;
    end
    
    if dopplerBin < maxIntDoppBins
        logFlag = rem(double(ms) / config.StartLogMs, 1) == 0;
        if logFlag
            fprintf(log, '%1d %1d %1d %12.6f %1d', config.SV, config.CAlow, config.CAhigh, freq, ms);
        end
        for i = 1:idx
            temp = valIntIdx(config.CAlow + i) - config.CAlow;
            valInt(dopplerBin, i) = valInt(dopplerBin, i) + val(temp) - config.NoiseFloor;
            if logFlag
                fprintf(log, ' %12.8f', valInt(dopplerBin, i));
                if config.StartLogMs ~= 1
                    valInt(dopplerBin, i) = 0;
                end
            end
        end
        if logFlag
            fprintf(log, '\n');
        end
    end
end

temp = valIntIdx(config.CAlow:config.CAlow + idx - 1);
valIntIdx(config.CAlow:config.CAlow + idx - 1) = temp + config.CodeSlide;

disp(['Finished ms ' num2str(ms)])

end

