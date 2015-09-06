


range_alpha = (0.06:0.01:0.18);
range_beta = (0.66:0.02:0.9);



group11 = zeros(13,13);


for i = 1:13
    for j = 1:13
    group111(i,j) = EvaluateHMM(range_alpha(i), range_beta(j), 20, 40, 9, 9);
    end
end