function [ samples ] = bin2sample(vec_bin,A,B,C,D)
msb=1;
lsb=8;
sample_bin=zeros(length(vec_bin)/8,8);
for i=1:(length(vec_bin)/8)              %convert vector CA binery to 8 coulmns 
   sample_bin(i,:)=vec_bin(1,msb:lsb);
   msb=msb+8;
   lsb=lsb+8;
end
nomap=bi2de(sample_bin,'left-msb');
samples = ((D-(C))*nomap - (A+B))/(B-A); % mapping number between  [A B] to [C,D]


end

