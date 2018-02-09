% Input a stim struct, output tells you which stimuli are the same class and frequency 

function stimType = sameStim(StimStruct)

numStim = length(StimStruct);
stimType = nan(1,numStim);
for i = numStim:-1:1
    stimTypeCount = i;
    for j = numStim:-1:1
        struct1 = StimStruct(i).stimObj;
        struct2 = StimStruct(j).stimObj;
        if strcmp(struct1.class,'noStimulus') && strcmp(struct2.class,'noStimulus')
            stimType(j) = stimTypeCount;
            continue
        elseif strcmp(struct1.class,'noStimulus') || strcmp(struct2.class,'noStimulus')
            continue
        end
        classLog = strcmp(struct1.class,struct2.class);
        freqLog = struct1.carrierFreqHz == struct2.carrierFreqHz;
        if classLog && freqLog
            stimType(j) = stimTypeCount;
        end
    end
end