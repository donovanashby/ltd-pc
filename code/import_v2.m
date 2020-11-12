function outputfolder = import_v2(folder,outputfolder)
%Data Import Function, for importing neuralynx data into matlab
%It should: take a data folder, extract event information,use this
%event information to import data sequentially for each channel into
%separate files (CSC*.mat or EEG*.mat).

EVfilename = [folder 'Events.nev'];
EVFieldSelection(1) = 1;%timestamps
EVFieldSelection(2) = 0;%eventIDs(not useful)
EVFieldSelection(3) = 1;%TTL values
EVFieldSelection(4) = 0;%extras (not needed)
EVFieldSelection(5) = 1;%event strings
EVExtractHeader = 1;%extract header? 1=yes 0=no
EVExtractMode = 1;%1-all,2-Idxrange,3-Idxarray,4-TSrange,5-TSarray
EVExtractVector = [1];%not needed for ExtractMode=1

[EV.timestamps,EV.ttls,EV.strings,EV.header] = Nlx2MatEV(EVfilename,EVFieldSelection,EVExtractHeader,EVExtractMode,EVExtractVector);

%print header
EV.header

%vector of index values for every occurence of stims
i=find(EV.ttls==65528);%-8: stim channel 1
j=find(EV.ttls==65524);%-12: stim channel 2
%THIS TTL value might change!!

outputfolder

data_import
    function data_import
if isdir(outputfolder);
    warning('folder already exists');
    reply=input('Press 1 to abort:');
    if reply==1;
        error('script aborted');
    end
else
    mkdir (outputfolder);
end

%write EV.strings to a text file
dlmwrite([outputfolder 'events.txt'], char(EV.strings), 'delimiter', '');

%make index of files end with .ncs in folder
idx = dir ([folder '*.ncs']);
l = length (idx);

for k = 1:l;
if idx(k).bytes>18000;
CSCfilename = [folder idx(k).name];
CSCFieldSelection(1) = 1;%timestamps
CSCFieldSelection(2) = 0;%channel numbers
CSCFieldSelection(3) = 0;%sample frequency
CSCFieldSelection(4) = 0;%number of valid samples
CSCFieldSelection(5) = 1;%samples
CSCExtractHeader = 1;%extract header? 1=yes 0=no
CSCExtractMode = 4;%1-all,2-Idxrange,3-Idxarray,4-TSrange,5-TSarray **IMPORTANT

Computing=idx(k).name

%Extract Waveforms for Stim 1
if ~isempty(i); %only runs loop if number of stims is non zero
    
for n=1:size(i,2);
    r=EV.timestamps(i(n)); %timestamp for event in exact microseconds 1000=1ms
    q=(r-200000); %set extraction window to 200ms before, 400ms after
    s=(r+400000); %

CSCExtractVector = [q s];

%MEX extraction script
[timestamps,samples,header] = Nlx2MatCSC(CSCfilename,CSCFieldSelection,CSCExtractHeader,CSCExtractMode,CSCExtractVector);

%Compute timestamps for each of the 512 samples within each record
for b=1:(size(timestamps,2)-1);
    timestamps(2:512,b) = round(timestamps(1,b)+((1:511)*(timestamps(1,(b+1))-timestamps(1,b))/512));
end;

b=b+1;
timestamps(2:512,b) = round(timestamps(1,b)+((1:511)*(timestamps(1,(b))-timestamps(1,(b-1)))/512));

data(n).timestamps = (timestamps(:)-r)/1000; %zero timestamp to event, change to milliseconds
data(n).samples = samples(:); %flatten samples
data(n).header = header;

a = strfind(data(n).header,'-ADBitVolts'); %find matching string in header cell array
b = find(~cellfun('isempty', a)); %which index contains string

data(n).bitvolts = textscan(data(n).header{b},'%*s %f');%extract numerical value, skipping string
data(n).bitvolts = data(n).bitvolts{1};%convert from cell array to number

%multiply samples by ADbitvolts to get volts, *1000 for mV
data(n).volts = (data(n).samples)*(data(n).bitvolts)*1000;

%Completed=n

end;


%Save data into mat file in outputfile folder
[str, name, ext]=fileparts([folder '/' idx(k).name]);%extract filename without .ncs extension
save([outputfolder name '-S1'],'EV','data','i','folder');

end;

clear data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extract Waveforms for Stim 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(j); %only runs loop if number of stims is non zero
    
for n=1:size(j,2);
    r=EV.timestamps(j(n)); %timestamp for event in exact microseconds 1000=1ms
    q=(r-200000); %set extraction window to 200ms before, 400ms after
    s=(r+400000); %

CSCExtractVector = [q s];

%MEX extraction script
[timestamps,samples,header] = Nlx2MatCSC(CSCfilename,CSCFieldSelection,CSCExtractHeader,CSCExtractMode,CSCExtractVector);

%Compute timestamps for each of the 512 samples within each record
for b=1:(size(timestamps,2)-1);
    timestamps(2:512,b) = round(timestamps(1,b)+((1:511)*(timestamps(1,(b+1))-timestamps(1,b))/512));
end;

b=b+1;
timestamps(2:512,b) = round(timestamps(1,b)+((1:511)*(timestamps(1,(b))-timestamps(1,(b-1)))/512));

data(n).timestamps = (timestamps(:)-r)/1000; %zero timestamp to event, change to milliseconds
data(n).samples = samples(:); %flatten samples
data(n).header = header;

a = strfind(data(n).header,'-ADBitVolts'); %find matching string in header cell array
b = find(~cellfun('isempty', a)); %which index contains string

data(n).bitvolts = textscan(data(n).header{b},'%*s %f');%extract numerical value, skipping string
data(n).bitvolts = data(n).bitvolts{1};%convert from cell array to number

%multiply samples by ADbitvolts to get volts, *1000 for mV
data(n).volts = (data(n).samples)*(data(n).bitvolts)*1000;

%Completed=n

end;

[str, name, ext]=fileparts([folder '/' idx(k).name]);%extract filename without .ncs extension
save([outputfolder name '-S2'],'EV','data','j','folder');

end;

clear data

end

    end

end
end

