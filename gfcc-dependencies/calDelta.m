function [ delta ] = calDelta( ccData )
% Calculate delta features of input features
% ritten by Yang Shao, and adapted by Xiaojia Zhao in Oct'11

    %calculate Delta coefficient, using the formula from HTK
    C1  = [ccData(:, 2:end) ccData(:, end)];
    C_1 = [ccData(:, 1)  ccData(:, 1:end-1)];
    C2  = [ccData(:, 3:end) ccData(:, end) ccData(:, end)];
    C_2 = [ccData(:, 1) ccData(:, 1) ccData(:, 1:end-2)];
    delta = (C1 - C_1) ./10 + 2 .* (C2 - C_2) ./ 10;  %2*(1^2+2^2);
    
