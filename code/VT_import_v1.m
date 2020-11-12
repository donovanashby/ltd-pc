function [filename]=VT_import_v1(folder,outputfolder,file)

% Function for importing VT files and EV files 
% NEED: folder, outputfolder, file
% folder is the input folder from neuralynx
% output folder should correspond to the ratID
% file should correspond to the day

VTfilename = [folder 'VT1.nvt'];
VTFieldSelection(1) = 1;%timestamps
VTFieldSelection(2) = 1;%extract x
VTFieldSelection(3) = 1;%extract y
VTFieldSelection(4) = 0;%extract angle
VTFieldSelection(5) = 0;%targets
VTFieldSelection(6) = 0;%points
VTExtractHeader = 1;%extract header? 1=yes 0=no
VTExtractMode = 1;%1-all,2-Idxrange,3-Idxarray,4-TSrange,5-TSarray **IMPORTANT
VTExtractVector = [1];

[VT.timestamps, VT.x, VT.y, VT.header] = Nlx2MatVT(VTfilename, VTFieldSelection, VTExtractHeader, VTExtractMode, VTExtractVector);

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


filename = [outputfolder file];
%save to file
if isdir(outputfolder)
    disp('folder already exists')
else
mkdir(outputfolder);
end
save(filename,'folder','filename','EV','VT');
end