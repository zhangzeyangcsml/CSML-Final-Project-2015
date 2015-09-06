%range_alphaplus = (0.08:0.01:0.2);
%range_betaplus = (0.66:0.02:0.9);



group55 = zeros(13,13);


for i = 1:13
    for j = 1:13
    group55(i,j) = EvaluateHMM(range_alpha(i), range_beta(j), 24, 46, 10, 8);
    end
end