function [c,e,spike,channels,waveform]=spike_import_v1(file)
%Imports and sorts CSV spike timestamps exported from plexon offline sorter
%filename is the full path to a .txt file
%includes waveform import
% c: unique tetrodes
% e: number of cells on each tetrode
% spike: cell array of spike timestamps
% channels: tetrode id for each spike
% waveform: cell array of waveforms for each spike

load(file)

f=dir([folder 'TT*.txt']);
f.name
if size(f,1)>1
    disp('multiple TT files, specify')
    f.name
else 

data=importdata([folder f.name],',');

i=1; 
c=unique(data(:,1)); %list of unique channels
for n=1:length(c)%for each channel channels
    channel=logical(data(:,1)==c(n)); %logical index for given channel
    d=unique(data(channel,2)); %list of unique cells
    d=d(d~=0); %remove unsorted
    e(n)=length(d);%number of cells for each channel
    for m=1:length(d) %for each cell
        cell=logical(data(:,2)==d(m));%logical index for given cell
        spike{i}=data(channel&cell,3); %spike timestamp
        waveform{i}=data(channel&cell,4:end);%array with waveforms
        i=i+1;
    end
end

channels(1:sum(e))=c(1);
cum_cell=cumsum(e);
for i=2:length(e)
channels((cum_cell(i-1)+1):cum_cell(i))=c(i);
end

save(filename,'c','e','spike','channels','waveform','-append');

end
