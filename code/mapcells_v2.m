function [map]=mapcells_v2(spike,t,Nx,ts)
%THIS VERSION IS FOR LINEARIZED DATA - using Nx (normalized X)
%just calculates the map for each spike, in each epoch
%map(1,1)=cell 1, epoch 1
%map(1,2)=cell 1, epoch 2

for n=1:size(spike,2)%for each spike
    
    for m=1:2:size(ts,2)%for each time series pair
        
%index for each spike
ind=spike{n}>t(ts(m)) & spike{n}<t(ts(m+1));
%ind=spike{n}>Nposition(ts(m),1) & spike{n}<Nposition(ts(m+1),1);

%filtered spikes
z=spike{n}(ind);

%filtered positions
x=t(ts(m):ts(m+1));
y=Nx(ts(m):ts(m+1));

% compute firing map variable
map(n,((m+1)/2))=Map([x y],z,'smooth',1);
    end
    
end
