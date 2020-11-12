function [datafolder] = waveplot_v1(datafolder)
%load each CSC datafile sequentially, write normalized data in X,Y,Z
%Z contains string of file name
%Saves file as 'aggregate'
% provide datafolder as input

skip=[];

%For Stim Channel 1

idx = dir ([datafolder '*-S1.mat']);

l=length(idx);

if l~=0;
    
for k = 1:l

load ([datafolder idx(k).name]);

for m=1:length(data)
    %each range must be normalized
    range(1) = find (data(m).timestamps > 14,1,'first'); %first timestamp bigger than 1
    range(2) = find (data(m).timestamps < 19,1,'last'); %last timestamp smaller than 19
    
    baseline=mean(data(m).volts(range(1):range(2)));
    
    range(3) = find (data(m).timestamps > 10,1,'first');
    range(4)=(range(3)+585);

    X(k,:,m) = data(m).timestamps(range(3):range(4))-20;%zero timestamps around stimulation
    Y(k,:,m) = data(m).volts(range(3):range(4))-baseline;%normalize to baseline
end

[~, name, ~]=fileparts([datafolder idx(k).name]);
Z{k} = name;
Z{k}

end

clear EV data folder i str name ext

save ([datafolder 'aggregate-S1'],'X','Y','Z','datafolder','idx');

end

clear X Y Z idx

%For Stim Channel 2

idx = dir ([datafolder '*-S2.mat']);

l=length (idx);

if l~=0;
    
for k = 1:l;

load ([datafolder idx(k).name]);

for m=1:length(data);
    %each range must be normalized
    range(1) = find (data(m).timestamps > 14,1,'first'); %first timestamp bigger than 14
    range(2) = find (data(m).timestamps < 19,1,'last'); %last timestamp smaller than 19
    
    baseline=mean(data(m).volts(range(1):range(2)));
    
    range(3) = find (data(m).timestamps > 10,1,'first');
    range(4)=(range(3)+585);

    X(k,:,m) = data(m).timestamps(range(3):range(4))-20;%zero timestamps around stimulation
    Y(k,:,m) = data(m).volts(range(3):range(4))-baseline;%normalize to baseline
end

[~, name, ~]=fileparts([datafolder idx(k).name]);
Z{k} = name;
Z{k}

clear EV data folder i str name ext

end

save ([datafolder 'aggregate-S2'],'X','Y','Z','datafolder','idx');

end

end
