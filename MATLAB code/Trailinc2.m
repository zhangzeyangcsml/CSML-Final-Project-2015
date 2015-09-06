range_gamma = [20,22,24,26];
range_delta = [40,42,44,46];
range_inc = [8,9,10,11];
range_dec = [8,9,10,11];



ff = zeros(4,4,4,4);


for i = 1:4
    for j = 1:4
        for k = 1:4
            for m = 1:4
                 ff(i,j,k,m) = EvaluateHMM(0.07, 0.66,range_gamma(i), range_delta(j),range_inc(k),range_dec(m) );
            end
        end
    end
end