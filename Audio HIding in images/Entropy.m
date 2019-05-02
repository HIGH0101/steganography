function [ output ] = Entropy(x)

IL = unique(x(:));       % Get all intensity levels
%L = numel(IL);                  % Number of intensity levels
p = histogram(x,IL,'Normalization','probability');
output=-sum((p.Values).*log2(p.Values));
end

