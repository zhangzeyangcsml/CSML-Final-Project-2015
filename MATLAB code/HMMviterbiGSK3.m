function [maxstate]=HMMviterbiGSK3(v,phghm,ph1,pdec, psta, pinc)
%HMMVITERBI Viterbi most likely joint hidden state of a HMM
% [maxstate logprob]=HMMviterbi(v,phghm,ph1,pdec,psta,pinc)
%
% Inputs:
% v : visible (obervation) sequence being a vector v=[2 1 3 3 1 ...]
% phghm : homogeneous transition distribution phghm(i,j)=p(h(t)=i|h(t-1)=j)
% ph1 : initial distribution
% pdec : customised emission disrtributions for a decreasing state.
% psta : customised emission disrtributions for a 'no change' state.
% pinc : customised emission disrtributions for a increasing state.
%
% Outputs:
% maxstate : most likely joint hidden (latent) state sequence
import brml.*
T=length(v); H=size(phghm,1);
mu(:,T)=ones(H,1);
for t=T:-1:2
	tmp = repmat([psta(v(t),v(t-1)),pinc(v(t),v(t-1)),psta(v(t),v(t-1)),psta(v(t),v(t-1)),pdec(v(t),v(t-1))]'.*mu(:,t),1,H).*phghm; %max over h(t) values.
    % We can see from above that it exapnds a column of stable state distribution as we adopt duration model in Model 3  
	mu(:,t-1)= condp(max(tmp)'); % normalise to avoid underflow
end
% backtrack
[val, hs(1)]=max(ph1.*mu(:,1)); %Need further improvement in definition  
for t=2:T % backtrack for t equals to 2 or above
	tmp = [psta(v(t),v(t-1)),pinc(v(t),v(t-1)),psta(v(t),v(t-1)),psta(v(t),v(t-1)),pdec(v(t),v(t-1))]'.*phghm(:,hs(t-1));
	[val, hs(t)]=max(tmp.*mu(:,t));
end
maxstate=hs;