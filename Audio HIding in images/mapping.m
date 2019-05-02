%If your number X falls between A and B, and you would like Y to fall between C and D,
%you can apply the following linear transform:
%Y = (X-A)/(B-A) * (D-C) + C
function  output  = mapping(matrix,min,max,C,D)
output=(double(matrix-min))/(max-min)*(D-C)+C;
end

