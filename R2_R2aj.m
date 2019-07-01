function [R2, R2aj] = R2_R2aj(input, expected_output, output)
    RSS = sum((expected_output - output) .^ 2);
    TSS = sum((expected_output - mean(expected_output)) .^ 2);
    k = size(input, 2);
    n = length(expected_output);

    R2 = 1 - (RSS / TSS);
    R2aj = 1 - ((RSS / (n - k)) / (TSS / (n - 1)));
end

