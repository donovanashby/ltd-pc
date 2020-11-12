% function for identifying laps 
% Uses linear data

function [in,out]=lap_processing(file)

load (file,'linear','ts','filename')

[a b]=lap_process(linear,ts,1);
[c d]=lap_process(linear,ts,2);
[e f]=lap_process(linear,ts,3);

plot(linear(:,1),linear(:,2));hold on
%plot(linear(i_max,1),linear(i_max,2),'r*',linear(i_min,1),linear(i_min,2),'g*')

in=cat(2,a,c,e);
out=cat(2,b,d,f);

%highlight outgoing paths to check accuracy
for n=1:length(out)
    ind=[out(1,n):out(2,n)];
    plot(linear(ind,1),linear(ind,2),'g')
end

%highlight ingoing paths to check accuracy
for n=1:length(in)
    ind=[in(1,n):in(2,n)];
    plot(linear(ind,1),linear(ind,2),'r')
end

%remove laps that are not full length
lap_length=linear(out(2,:),2)-linear(out(1,:),2);
ind=lap_length'>550;
out(:,~ind)=[];

lap_length=linear(in(1,:),2)-linear(in(2,:),2);
ind=lap_length'>550;
in(:,~ind)=[];

save(filename,'in','out','-append')

end

