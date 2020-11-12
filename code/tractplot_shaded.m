%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots waveforms from data in 'aggregate' files
% Plots max/min amplitude of 4 channels across time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [datafolder] = tractplot_shaded(datafolder,tract)

load(datafolder) %
baseline=11:30;
skip=[]; %
stimrange=1:size(X,3); %
ind=tract;
          
eval(['Tract' int2str(ind)]); %

E{1} = strncmp (A,Z,6);
E{2} = strncmp (B,Z,6); 
E{3} = strncmp (C,Z,6); 
E{4} = strncmp (D,Z,6); 

%print the current channels
Z(E{1})
Z(E{2})
Z(E{3})
Z(E{4})

%%%change colors
 rg{1,:}=1:30;
 rg{2,:}=31:60; 
 rg{3,:}=61:stimrange(end);
%%%change colors
 color{1}='-b';
 color{2}='-g';
 color{3}='-r';

for m=1:size(rg,1)

    for p=1:4
    subplot (2,4,p)%
    x=squeeze(X(E{p},:,1)); %
    y=squeeze(Y(E{p},:,rg{m,:}))'; %
    
    shadedErrorBar(x,y,{@mean, @std},'lineprops',color{m});
    
    xlabel('Time(ms)')
    ylabel('Amplitude(mV)')
    xlim([-10 30]) 
    
    r1 = find (X(E{p},:,1) > 3,1,'first'); %time index 3ms post stim
    r2 = find (X(E{p},:,1) < 20,1,'last'); %time index 20ms post stim
    
    mx = max(max(abs(Y(E{p},r1:r2,1:size(X,3))),[],2)); %
    
    ylim([-mx mx])
    
    title (Z(E{p})) 
    
    hold all
    end
    
end

% make scatterplot
    hold off

for m=stimrange

    if any(m==skip)
        continue
    else
        
    X_ind(m) = m;
    
    for p=1:4
         
    r1 = find (X(E{p},:,m) > 3,1,'first'); %time index 3ms post stim
    r2 = find (X(E{p},:,m) < 20,1,'last'); %time index 20ms post stim
    
    Y_max(p,m) = max((Y(E{p},r1:r2,m)),[],2);
    Y_min(p,m) = min((Y(E{p},r1:r2,m)),[],2);

    end
    end
    
end

mycolor(1,:) = [0 0 .8];
mycolor(2,:) = [0 .8 0];
mycolor(3,:) = [.8 .8 0];
mycolor(4,:) = [.8 0 0];

mycolorscheme{1} = mycolor;
set(0,'DefaultAxesColorOrder',mycolorscheme{1})

subplot(2,4,5:8);

for n=1:4
    
if abs(mean(Y_min(n,:)))>abs(mean(Y_max(n,:)))
    Y_percent(n,:)=Y_min(n,:)/median(Y_min(n,baseline));
    scatter(X_ind,Y_percent(n,:),'filled');
else
    Y_percent(n,:)=Y_max(n,:)/median(Y_max(n,baseline));
    scatter(X_ind,Y_percent(n,:),'filled');
end

hold all

end

legend(A,B,C,D)
xlabel('Stimulation')
ylabel('Normalized Amplitude')
ylim([0 2])
set(gca,'YGrid','on')

end

