% takes processes location data (X,Y)
% and 3*5*2 vertices martix (epoch*vertex*XY)
% outputs 1-D linearized location data

function [linear,Nlinear]=linearization(file,vertices)

load(file,'ts','position','filename','folder')

for m=1:3
    clear a L D Lposition Dposition m1 m2 m3
    %close all
    
    index=ts(m*2-1):ts(m*2);%m=1;%epoch
%index=ts(3):ts(4);%m=2;%epoch
%index=ts(5):ts(6);%m=3;%epoch
a=squeeze(vertices(m,:,:));
%run for each line segment (a-b;b-c;c-d;d-e)
%will give 5x2xN set of values
for n=1:4
[L(n,:) D(n,:)]=linearize_v2(position(index,2:3),a(n,:),a(n+1,:));
end

%stack each segment onto the max value of the preceding segment
%to create one long vector of L values (point along the reference line)
% and D values (distance from reference line)
%adjust extra segment starting points
m1=max(L(1,:));
m2=max(L(2,:));
m3=max(L(3,:));
L(2,:)=L(2,:)+m1;
L(3,:)=L(3,:)+m2+m1;
L(4,:)=L(4,:)+m3+m2+m1;

% find index value of min D for each data point
% in order to reference to the appropriate line segement
[c,i]=min(D); 

% Assign a single L, D value for the session
Lposition=zeros(size(i));
Dposition=zeros(size(i));
for n=1:length(i)
    Lposition(n)=L(i(n),n);
    Dposition(n)=D(i(n),n);
end

%plot x and y values, along with linear plot to check accuracy
figure(m);
subplot(3,1,1);plot(position(index,2))
subplot(3,1,2);plot(position(index,3))
subplot(3,1,3);plot(Lposition)

%write Lposition into final linear variable
linear(index,2)=Lposition; 
linear(index,3)=Dposition;

Nlinear(index)=normalize_location(Lposition)'; %write normalized Lposition into Nlinear

end

%%%% set timestamps after all ts sections done
linear(:,1)=position(:,1); %timestamps

save(filename,'linear','Nlinear','vertices','-append');

end
