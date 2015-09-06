function [maxstate]=HMMviterbiGSK4(v,phghm,ph1,pdec, psta, pinc,pdec2,psta2,pinc2)
%HMMVITERBI Viterbi most likely joint hidden state of a HMM
% Inputs:
% v : visible (obervation) sequence being a vector v=[2 1 3 3 1 ...]
% phghm : homogeneous transition distribution phghm(i,j)=p(h(t)=i|h(t-1)=j)
% ph1 : initial distribution
% pdec : customised emission disrtributions for a decreasing state.
% psta : customised emission disrtributions for a 'no change' state.
% pinc : customised emission disrtributions for a increasing state.
% pdec2 : customised emission disrtributions for a decreasing state in 2 time steps.
% psta2 : customised emission disrtributions for a 'no change' state in 2 time steps.
% pinc2 : customised emission disrtributions for a increasing state in 2 time steps.
%
% Outputs:
% maxstate : most likely joint hidden (latent) state sequence
import brml.*
T=length(v); H=size(phghm,1);
mu(:,T)=ones(H,1);

%Backward Recursion from T to t=3 step. 
for t=T:-1:3
	tmp = repmat([psta2(v(t),v(t-2)),pinc2(v(t),v(t-2)),psta2(v(t),v(t-2)),psta2(v(t),v(t-2)),pdec2(v(t),v(t-2))]'.*mu(:,t),1,H).*phghm; %max over h(t) values.  
	mu(:,t-1)= condp(max(tmp)'); % normalise to avoid underflow
end

% Arrangement for the t=2 step to get mu(t=1)
tmp = repmat([psta(v(2),v(1)),pinc(v(2),v(1)),psta(v(2),v(1)),psta(v(2),v(1)),pdec(v(2),v(1))]'.*mu(:,2),1,H).*phghm; %max over h(2) values.  
	mu(:,1)= condp(max(tmp)'); % normalise to avoid underflow
    
% backtrack
hs = zeros(1,T);
[~, hs(1)]=max(ph1.*mu(:,1)); %Need further improvement in definition  

for t=2 % backtrack for t=2 
	tmp = [psta(v(t),v(t-1)),pinc(v(t),v(t-1)),psta(v(t),v(t-1)),psta(v(t),v(t-1)),pdec(v(t),v(t-1))]'.*phghm(:,hs(t-1));
	[~, hs(t)]=max(tmp.*mu(:,t));
end

for t=3:T % backtrack for t=3
	tmp = [psta2(v(t),v(t-2)),pinc2(v(t),v(t-2)),psta2(v(t),v(t-2)),psta2(v(t),v(t-2)),pdec2(v(t),v(t-2))]'.*phghm(:,hs(t-1));
	[~, hs(t)]=max(tmp.*mu(:,t));
end

maxstate=hs;