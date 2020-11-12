%%%tolias distance
% takes two sets of waveforms x and b (n by 128 matrices), calculates the d1 and d2
% tolias distances between the average waveforms of each set
% 
% additional numbers it gives: d1 value for each waveform in b (dd1)
% 
% a=waveform{1};
% b=waveform{2};
% channels =[1 2 3 4], in case one channel is dead

function [d1,d2]=tolias(a,b,channels)

%scale x by a to minimize the sum of squared differences between x and y
%%%%

%take average waveforms
x=mean(a,1);
y=mean(b,1);

%reshape into four channels
x=reshape(x,32,4);
y=reshape(y,32,4);

%%% d1 calcuation %%%
%calculates d1 value for each waveform of cell b, vs the
%average waveform of a: each d1 value is a sum across the 4 channels

for i=1:4
n = fminbnd(@(n) sumsquare(n,x(:,i),y(:,i)),0,2);
m(i)=n;
end
n=m;

%calculate scaled values of x using n values
scaled=repmat(n,32,1).*x;
dd=scaled-y; %vector difference between scaled x and y

for i=1:4
    d(i)=norm(dd(:,i))/norm(y(:,i));
end

d1=mean(d(channels))*4; %sum of four channels, or interp of three   

%%% d2 caculation %%%
% sum of the maximum absolute value of the log of the scaling
% factor and the max value of the difference between scaling factors

m=log(n(channels)); %log of four n values
q=repmat(m,length(m),1)-repmat(m,length(m),1)'; %matrix of differences between pairs of n values

d2=max(abs(m(:)))+max(abs(q(:)));
