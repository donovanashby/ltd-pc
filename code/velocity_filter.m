%Velocity Filter function
%
% calculates velocity, then calculates quiet (non moving) periods
% using LinearVelocity, QuietPeriods, InIntervals functions
% exports a filtered spike cell array based on input

function [spike_f]=velocity_filter(position,spike,spike_n)

%calculate instantaneous velocity with 15 sample gaussian smoothing (half
%second) - CALCULATE FROM 2D POSITION DATA, NOT LINEARIZED DATA
V=LinearVelocity(position,30);

%max velocity: 15 (approx 2.5cm/s)
%min duration: 0.5 
[periods q]=QuietPeriods(V,15,0.5,0.5);

%calculate filtered spikes
for n=1:length(spike)
[status{n}]=InIntervals(spike{n},periods);
spike_f{n}=spike{n}(~status{n}); %index into each spike list with status
end
