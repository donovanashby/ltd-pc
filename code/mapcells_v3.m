function [map]=mapcells_v3(spike,t,Nx,in,ts)
%THIS VERSION IS FOR LINEARIZED DATA, stacked - using Nx (normalized X)
%just calculates the map for each spike, in each epoch
%map(1,1)=cell 1, epoch 1
%map(1,2)=cell 1, epoch 2
% spike - spike cell array
% t - position timestamps (position(:,1))
% Nx - normalized position Nlinear
% in - timestamp index list specifying inward/outward paths
% ts - ts pairs specifying epoch

for n=1:size(spike,2)%for each spike
    
    s=spike{n};
    
    for m=1:2:size(ts,2)%for each time series pair


ind=any(bsxfun(@ge, s, t(in(1,:))') & bsxfun(@le, s, t(in(2,:))'), 2) & s>t(ts(m)) & s<t(ts(m+1));

%filtered spikes
z=s(ind);

%filtered positions
x=t(ts(m):ts(m+1));
y=Nx(ts(m):ts(m+1));

% compute firing map variable
map(n,((m+1)/2))=Map([x y],z,'smooth',1);
    end
    
end
