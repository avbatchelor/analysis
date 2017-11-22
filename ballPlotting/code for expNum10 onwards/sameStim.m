% Input a stim struct, output tells you which stimuli are the same class and frequency 

function stimType = sameStim(StimStruct)

numStim = length(StimStruct);
stimType = nan(1,numStim);
for i = numStim:-1:1
    stimTypeCount = i;
    for j = numStim:-1:1
        struct1 = StimStruct(i).stimObj;
        struct2 = StimStruct(j).stimObj;
        classLog = strcmp(struct1.class,struct2.class);
        freqLog = struct1.carrierFreqHz == struct2.carrierFreqHz;
        if classLog && freqLog
            stimType(j) = stimTypeCount;
        end
    end
end