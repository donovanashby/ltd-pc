function []=plotfig_v2(n,map)

% THIS VERSION IS FOR LINEARIZED DATA - 
% Where n is the cell number to be plotted

%plot heatmap
for e=1:size(map,2)
m(e)=0;
M(e)=prctile(map(n,e).z(:),95); %find 95th percentile of max rate for each lap
end
m=0;
M=max(M);
if M<1
    M=1;
end

figure(n);
for e=1:size(map,2)
subplot = @(m,n,p) subtightplot (m, n, p, [], [], []);
subplot(size(map,2),1,e);
PlotColorMap(map(n,e).z,map(n,e).time,'bar','off','cutoffs',[m M]);
set(gca,'XTick',[],'YTick',[]);
%axis image
end
