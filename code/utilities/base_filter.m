
%%%base filter script - called from placecell_scripts_v3.m
%%% removes off maze points, runs difference filter
%filter 1: removes all points outside designated tracking window
%filter 2: descibes each data point as a difference from the local mean
%and removes data points that differ from the local mean by 25 px (might
%filter 3: removes isolated points that are bounded by NaNs
%%%
function [x y] = base_filter(x,y,x_range,y_range)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%remove all off-zone points
good=x<x_range(2) & x>x_range(1); %x values
x(~good)=NaN;
y(~good)=NaN;

good=y<y_range(2) & y>y_range(1); %y values
x(~good)=NaN;
y(~good)=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%difference filter
%x value
difference=ones(1,length(x));
window=16;
for n=9:length(x)-window/2;
    range=((n-window/2):(n+window/2));
    difference(n)=x(n)-nanmedian(x(range));
end
%set x outliers
outliers=(abs(difference)>25);
x(outliers)=NaN;
y(outliers)=NaN;

%y value
difference=ones(1,length(y));
window=8;
for n=5:length(y)-window/2;
    range=((n-window/2):(n+window/2));
    difference(n)=y(n)-nanmedian(y(range));
end
%set y outliers
outliers=(abs(difference)>25);
x(outliers)=NaN;
y(outliers)=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Remove isolated points
%this script finds values bounded by NaNs, and removes these values
%as they are likely erroneous
log=~isnan(x);
for ind=2:(length(log)-1)
    if log(ind-1)==0 && log(ind+1)==0
        log(ind)=0;
    end
end
x(~log)=NaN;
y(~log)=NaN;

log=~isnan(y);
for ind=2:(length(log)-1)
    if log(ind-1)==0 && log(ind+1)==0
        log(ind)=0;
    end
end
x(~log)=NaN;
y(~log)=NaN;
end
