%video tracking pre-processing
% base filter is 1-3
%filter 1: removes all points outside designated tracking window
%filter 2: descibes each data point as a difference from the local mean
%and removes data points that differ from the local mean by 25 px
%filter 3: removes isolated points that are bounded by NaNs
%
%filter 4: gaussian smoothing, 10 sample window
%

function [filename]=placecell_v1(file,event)

load(file)

t=VT.timestamps/1000000;%convert to seconds
x=VT.x;
y=VT.y;

figure(1);subplot(2,1,1);plot(x);subplot(2,1,2);plot(y)%plot

%run base filter
[x y] = base_filter(x,y,[10 700],[1 600]); %linear

figure(2);subplot(2,1,1);plot(x);subplot(2,1,2);plot(y)%plot

% figure(3);scatter(x,y)
% 
% %After manual editing with brushing assign NaNs to both values (must link
% %plot)
% y(isnan(x))=NaN;
% x(isnan(y))=NaN;

%simple interpolation
x0=x;
y0=y;

i=(1:length(x0));
iV=i(~isnan(x0));
V=x0(~isnan(x0));
x=interp1(iV,V,i,'linear');

i=(1:length(y0));
iV=i(~isnan(y0));
V=y0(~isnan(y0));
y=interp1(iV,V,i,'linear');

%pad any NaNs with dummy values
x(isnan(x))=300;
y(isnan(y))=300;

%gaussian smoothing, 10 sample
x=Smooth(x,10);
y=Smooth(y,10);

figure(4);subplot(2,1,1);plot(x0);subplot(2,1,2);plot(y0)%plot
figure(5);subplot(2,1,1);plot(x);subplot(2,1,2);plot(y)%plot

%find first position timestamp
timestamps=EV.timestamps/1000000; %convert to seconds

%create position matrix from time, x and y column
position(1,:)=t;
position(2,:)=x;
position(3,:)=y;
position=position';

%normalize position
minx=50;
maxx=700;

miny=0;
maxy=600;

Nposition(:,1)=position(:,1);
Nposition(:,2)=normalize_location(position(:,2),minx,maxx);
Nposition(:,3)=normalize_location(position(:,3),minx,maxx);

for n=1:length(event)
[~,ts(n)]=min(abs(position(:,1)-timestamps(event(n)))); %index of closest value
end

save(filename,'position','Nposition','event','ts','-append');

end



