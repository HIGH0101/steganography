function [ vec_CA_bin ] = sample2bin(samples,A,B,C,D) 
mapped = round(((D+C) + (D-C) *samples ) / (B-(A))); %mapping [A,B] to [C,D]
CA_bin=de2bi(mapped,8,'left-msb');
vec_CA_bin=zeros(1,numel(CA_bin));  
msb=1;
lsb=8;
for i=1:length(CA_bin)
vec_CA_bin(1,msb:lsb)=CA_bin(i,:);
msb=msb+8;
lsb=lsb+8;
end


end

