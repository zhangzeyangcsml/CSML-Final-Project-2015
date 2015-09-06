%range_alphaplus = (0.08:0.01:0.2);
%range_betaplus = (0.66:0.02:0.9);



group22 = zeros(13,13);


for i = 1:13
    for j = 1:13
    group222(i,j) = EvaluateHMM(range_alpha(i), range_beta(j), 20,44,11,8);
    end
end