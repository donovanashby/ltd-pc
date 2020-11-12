% produces list of min and max indices for lap processing
% needs linearized position data (:,3)
% needs ts variable ts(1):ts(2)
% needs epoch (1,2,3)

function [in out]=lap_process(linear,ts,epoch)

m=(epoch*2)-1;
        
%select range
rng=ts(m):ts(m+1);

linear_S(rng)=Smooth(linear(rng,2),100);

%find minima and maxima for smoothed data

[v_max,i_max,v_min,i_min] = extrema(linear_S(rng));
i_max=i_max+ts(m)-1;
i_min=i_min+ts(m)-1;
fil=linear(i_max,2)<(max(linear(i_max,2))-150);
i_max(fil)=[];
fil=linear(i_min,2)>(min(linear(i_min,2))+150);
i_min(fil)=[];

%concatenate into array to remove repeaters
i_min(2,:)=0;
i_max(2,:)=1;
ext=[i_min i_max];
ext=sortrows(ext'); %sort based on time value

ext2=ext(:,2); %make comparator
ext2(end+1)=0; %pad comparator
ext2(2:end)=ext(1:end,2); %compator is ext shift +1
ext(end+1,:)=0; %pad ext

filt=ext(:,2)==ext2; %make filter
filt(1)=0; %first value is alway false
filt(end)=1; %last value always true

ext(filt,:)=[];

i_min=ext(ext(:,2)==0,1);
i_max=ext(ext(:,2)==1,1);

%plot(linear(i_max,1),linear(i_max,2),'r*',linear(i_min,1),linear(i_min,2),'g*')

if i_min(1)<i_max(1) %first value is min - min is going to be larger or same    
    out(1,:)=i_min(1:length(i_max));
    out(2,:)=i_max;
    in(1,:)=i_max(1:length(i_min)-1);%start at first value, ends last or 2nd last
    in(2,:)=i_min(2:end); %always starts at second value, ends last
else %fist value is max, max is larger or same
    in(1,:)=i_max(1:length(i_min));
    in(2,:)=i_min;
    out(1,:)=i_min(1:length(i_max)-1);
    out(2,:)=i_max(2:end);
end