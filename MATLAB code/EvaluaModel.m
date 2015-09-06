% Import the pre-proccessed data, as expained in the report. 
ExacData = readtable('ExacData.csv');
ExacData.Subject_ID = categorical(ExacData.Subject_ID);

% Extract index of the starting day of all subjects. 
total_row = size(ExacData,1);
IndiScore = [];
for i = 1:total_row
    if (ExacData.Studyday(i) == 1)
        IndiScore = [IndiScore, i];
    end
end

% All add one to the score to avoid 0 score. 
ExacData.Total = ExacData.Total + 1;

% Now, create a new column that scores the detection results of the HMM
Exacerbation_Status_pred = [];
for n = 1:size(IndiScore,2)
    %disp(n)
    score = ExacData.Total(IndiScore(n):(IndiScore(n)+ ExacData.SubjectTotalDaysData(IndiScore(n)) - 1)); % Extract the health score of each patient
    % If we want a non-homogeneous transition distribution for each
    % individual , we can then make changes within this loop, as shown
    % below to alter the value of alpha for each individual. 
    % 
    alpha = 0.12 + 0.01*log(ExacData.Historical_Exacerbations(IndiScore(n)));
    tran_h = [1- alpha, 0, 0, 0,0, 1-alpha; alpha, alpha, 0, 0, 0, 0; 0, 1 - alpha, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0; 0, 0, 0, 1, beta, 0; 0, 0, 0, 0, 1- beta, alpha];
    %Exac_pred = HMMviterbiGSK3(score, tran_h, ph1,pdec, psta, pinc);
    Exac_pred = HMMviterbiGSK5(score, tran_h, ph1,pdec, psta, pinc,pdec2,psta2,pinc2);
    % Since we are considering a gradual increase in 2 steps, then for simplicaity, if an
    % increasing state detected we manually change the day before it to
    % exacerbation too as it is also in that gradual increase as well . 
    for m = 2:size(score,1) 
        if (Exac_pred(m) == 2)
            Exac_pred(m-1) = 2;
        end
    end
    Exacerbation_Status_pred = [Exacerbation_Status_pred, Exac_pred]; % add up the detected results of all individuals. 
end


%Combine the predicted result to the table
T = table(Exacerbation_Status_pred');
T.Properties.VariableNames{'Var1'} = 'Exacerbation_Status_pred';
ExacData = [ExacData T];

% Extract number of exacerbation days by doctor: a+c,      as in the report. 
idx_doctor = ismember(ExacData.Exacerbation_Status_by_doctor,{'1'});
num_exac_doctor = size(ExacData(idx_doctor,:),1);


% Extract number of exacerbation days by our prediction: a+b 
idx_HMM = ExacData.Exacerbation_Status_pred ~= 1;
num_exac_HMM = size(ExacData(idx_HMM,:),1);

% Precision/Recall Analysis 
ExacData_doctor = ExacData(idx_doctor,:);                 
idx_doctor_HMM = ExacData_doctor.Exacerbation_Status_pred ~= 1;
num_captured = size(ExacData_doctor(idx_doctor_HMM,:),1); % Count a

Recall = num_captured/num_exac_doctor                     % Recall = a/(a+c)
Precision = num_captured/num_exac_HMM                   %Precision = a/(a+b)
% Van Rijsbergen's F
F = 1/(0.85*(1/Recall)+0.15*(1/Precision))




%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SOME  PLOTs    %%%%%%%%%%%%%%%%%%%%%% 
%{
idx5 = ExacData.Subject_ID == '5';
Data5 = ExacData(idx5,:);
Show_Exac_by_doc_5 = [];
for o = 1:size(Data5,1)
    if (ismember(Data5.Exacerbation_Status_by_doctor(o),{'1'}))
        Show_Exac_by_doc_5(o) = 52;
    else
        Show_Exac_by_doc_5(o) = 48;
    end
end

plot(Data5.Studyday, Data5.Total, Data5.Studyday, Data5.Exacerbation_Status_pred, Data5.Studyday, Show_Exac_by_doc_5) 




idx144 = ExacData.Subject_ID == '144';
Data144 = ExacData(idx144,:);
Show_Exac_by_doc_144 = [];
for o = 1:size(Data144,1)
    if (ismember(Data144.Exacerbation_Status_by_doctor(o),{'1'}))
        Show_Exac_by_doc_144(o) = 30;
    else
        Show_Exac_by_doc_144(o) = 0;
    end
end

Show_Exac_by_doc_144 = Show_Exac_by_doc_144';

for o = 1:size(Data144,1)
    if (Data144.Exacerbation_Status_pred(o) == 1)
        Data144.Exacerbation_Status_pred(o) =0 ;
    else
        Data144.Exacerbation_Status_pred(o) =30 ;
    end
end

%Data144.Exacerbation_Status_pred = Data144.Exacerbation_Status_pred + 51;

plot(Data144.Studyday, Data144.Total, Data144.Studyday, Data144.Exacerbation_Status_pred, Data144.Studyday, Show_Exac_by_doc_144)       


idx98 = ExacData.Subject_ID == '98';
Data98 = ExacData(idx98,:);
Show_Exac_by_doc_98 = [];
for o = 1:size(Data98,1)
    if (ismember(Data98.Exacerbation_Status_by_doctor(o),{'1'}))
        Show_Exac_by_doc_98(o) = 30;
    else
        Show_Exac_by_doc_98(o) = 0;
    end
end
Show_Exac_by_doc_98 = Show_Exac_by_doc_98';

for o = 1:size(Data98,1)
    if (Data98.Exacerbation_Status_pred(o) == 1)
        Data98.Exacerbation_Status_pred(o) =0 ;
    else
        Data98.Exacerbation_Status_pred(o) =30 ;
    end
end

plot(Data98.Studyday, Data98.Total, Data98.Studyday, Data98.Exacerbation_Status_pred, Data98.Studyday, Show_Exac_by_doc_98)   

        
%}