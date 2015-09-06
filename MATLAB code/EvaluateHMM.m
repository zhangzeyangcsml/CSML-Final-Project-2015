function [F_Index] =  EvaluateHMM(alpha, beta, gamma, delta, inc, dec)

%Create the emission matrix for 'no change' state

psta = zeros (52,52);
for  i=1:52
    for j= 1:52
        psta(i,j) = exp(-((j-i)^2)/(gamma-5));
    end
end

normf = sum(psta,2);
dnormf = repmat(normf,1,52);
psta = psta./dnormf;
psta = psta';
        
%Create the emission matrix for increasing state

pinc = zeros (52,52);
for i=1:49
    for j= i+3 :52
        pinc(i,j) = exp(-((j-(i+(inc -2)))^2)/(delta - 5));
    end
end

normf = sum(pinc,2);
normf(50:52) = [1;1;1];
dnormf = repmat(normf,1,52);
pinc = pinc./dnormf;
pinc = pinc';


%Create the emission matrix for decreasing state

pdec = zeros (52,52);
for i=4:52
    for j= 1 : i-3
        pdec(i,j) = exp(-((j-(i-(dec -2)))^2)/delta - 5);
    end
end

normf = sum(pdec,2);
normf(1:3) = [1;1;1];
dnormf = repmat(normf,1,52);
pdec = pdec./dnormf;
pdec = pdec';

% Create similar emission matrix for 'no change' state in 2 time steps

psta2 = zeros (52,52);
for  i=1:52
    for j= 1:52
        psta2(i,j) = exp(-((j-i)^2)/gamma);
    end
end

normf = sum(psta2,2);
dnormf = repmat(normf,1,52);
psta2 = psta2./dnormf;
psta2 = psta2';
        
%Create the emission matrix for increasing state in 2 time steps

pinc2 = zeros (52,52);
for i=1:49
    for j= i+3 :52
        pinc2(i,j) = exp(-((j-(i+ inc))^2)/delta);
    end
end

normf = sum(pinc2,2);
normf(50:52) = [1;1;1];
dnormf = repmat(normf,1,52);
pinc2 = pinc2./dnormf;
pinc2 = pinc2';


%Create the emission matrix for decreasing state in 2 time steps

pdec2 = zeros (52,52);
for i=4:52
    for j= 1 : i-3
        pdec2(i,j) = exp(-((j-(i - dec))^2)/delta);
    end
end

normf = sum(pdec2,2);
normf(1:3) = [1;1;1];
dnormf = repmat(normf,1,52);
pdec2 = pdec2./dnormf;
pdec2 = pdec2';
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ph1 = [1;0;0;0;0;0];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%      EvaluaModel     %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ExacData = readtable('ExacData.csv');
ExacData.Subject_ID = categorical(ExacData.Subject_ID);

% Extract index of the starting day of all subjects. 
total_row = size(ExacData,1);
IndiScore = find(ExacData.Studyday == 1);

% All add one to the score to remove 0 score. 
ExacData.Total = ExacData.Total + 1;


Exacerbation_Status_pred = zeros(1,total_row);
for n = 1:size(IndiScore,1)
    % disp(n)
    score = ExacData.Total(IndiScore(n):(IndiScore(n)+ ExacData.SubjectTotalDaysData(IndiScore(n)) - 1));  % Extract the health score of each patient
    % If we want a non-homogeneous transition distribution for each
    % individual , we can then make changes within this loop, as shown
    % below to alter the value of alpha for each individual. 
    % 
    %alpha = alpha + 0.01*log(ExacData.Historical_Exacerbations(IndiScore(n))- 1);
    %clear tran_h;
    tran_h = [1- alpha, 0, 0, 0,0, 0.9; alpha, 0.1, 0, 0, 0, 0; 0, 0.9, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0; 0, 0, 0, 1, beta, 0; 0, 0, 0, 0, 1- beta,0.1];

    Exac_pred = HMMviterbiGSK5(score, tran_h, ph1,pdec, psta, pinc,pdec2,psta2,pinc2);
    for m = 2:size(score,1)
        if (Exac_pred(m) == 2)
            Exac_pred(m-1) = 2;
        end
    end
    Exacerbation_Status_pred(IndiScore(n):(IndiScore(n)+ ExacData.SubjectTotalDaysData(IndiScore(n)) - 1)) = Exac_pred;  % add up the detected results of all individuals. 
end


%Combine the predicted result to the table
T = table(Exacerbation_Status_pred');
T.Properties.VariableNames{'Var1'} = 'Exacerbation_Status_pred';
ExacData = [ExacData T];

% Extract number of exacerbation days by doctor
idx_doctor = ismember(ExacData.Exacerbation_Status_by_doctor,{'1'});
num_exac_doctor = size(ExacData(idx_doctor,:),1);


% Extract number of exacerbation days by our prediction
idx_HMM = ExacData.Exacerbation_Status_pred ~= 1;
num_exac_HMM = size(ExacData(idx_HMM,:),1);

% Precision/Recall Analysis 
ExacData_doctor = ExacData(idx_doctor,:);
idx_doctor_HMM = ExacData_doctor.Exacerbation_Status_pred ~= 1;
num_captured = size(ExacData_doctor(idx_doctor_HMM,:),1);  % Count a

Recall = num_captured/num_exac_doctor;                   % Recall = a/(a+c)
Precision = num_captured/num_exac_HMM;                %Precision = a/(a+b)
% Van Rijsbergen's F with alpha = 0.8
F_Index = 1/(0.8*(1/Recall)+0.2*(1/Precision));

