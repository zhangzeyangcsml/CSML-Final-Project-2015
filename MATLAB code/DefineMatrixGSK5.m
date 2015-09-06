% The names of these parameters are in line with the ones in our report. We can set the values manually. 
% clear all
% define transition matrix between 3 states
alpha = 0.18;
beta = 0.76;
% 
 tran_h = [1- alpha, 0, 0, 0,0, 0.9; alpha, 0.1, 0, 0, 0, 0; 0, 0.9, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0; 0, 0, 0, 1, beta, 0; 0, 0, 0, 0, 1- beta, 0.1];
 


%Design 3 emission matrix for 1 step change 
%Create the emission matrix for stable state

sigma = 15;

psta = zeros (52,52);
for  i=1:52
    for j= 1:52
        psta(i,j) = exp(-((j-i)^2)/sigma);
    end
end
%Normalisation and transpose
normf = sum(psta,2);
dnormf = repmat(normf,1,52);
psta = psta./dnormf;
psta = psta';
        
%Create the emission matrix for increasing state

lambda = 39;

pinc = zeros (52,52);
for i=1:49
    for j= i+3 :52
        pinc(i,j) = exp(-((j-(i+9))^2)/lambda);
    end
end
%Normalisation and transpose
normf = sum(pinc,2);
normf(50:52) = [1;1;1];
dnormf = repmat(normf,1,52);
pinc = pinc./dnormf;
pinc = pinc';


%Create the emission matrix for decreasing state

pdec = zeros (52,52);
for i=4:52
    for j= 1 : i-3
        pdec(i,j) = exp(-((j-(i-6))^2)/lambda);
    end
end
%Normalisation and transpose
normf = sum(pdec,2);
normf(1:3) = [1;1;1];
dnormf = repmat(normf,1,52);
pdec = pdec./dnormf;
pdec = pdec';

% Create similar emission matrix for 2 steps change 

gamma = 20;

psta2 = zeros (52,52);
for  i=1:52
    for j= 1:52
        psta2(i,j) = exp(-((j-i)^2)/gamma);
    end
end
%Normalisation and transpose
normf = sum(psta2,2);
dnormf = repmat(normf,1,52);
psta2 = psta2./dnormf;
psta2 = psta2';
        
%Create the emission matrix for increasing state

delta = 44;

pinc2 = zeros (52,52);
for i=1:49
    for j= i+3 :52
        pinc2(i,j) = exp(-((j-(i+11))^2)/delta);
    end
end
%Normalisation and transpose
normf = sum(pinc2,2);
normf(50:52) = [1;1;1];
dnormf = repmat(normf,1,52);
pinc2 = pinc2./dnormf;
pinc2 = pinc2';


%Create the emission matrix for decreasing state

pdec2 = zeros (52,52);
for i=4:52
    for j= 1 : i-3
        pdec2(i,j) = exp(-((j-(i-8))^2)/delta);
    end
end
%Normalisation and transpose
normf = sum(pdec2,2);
normf(1:3) = [1;1;1];
dnormf = repmat(normf,1,52);
pdec2 = pdec2./dnormf;
pdec2 = pdec2';


% Define initial states ph1 as long term equivalent states
% A = tran_h - eye(size(tran_h,1));
% A = [A(1:size(tran_h,1)-1,:); ones(1,size(tran_h,1))];
% B = [zeros(size(tran_h,1 )- 1, 1); 1];
% ph1 = linsolve(A,B)

ph1 = [1;0;0;0;0;0]