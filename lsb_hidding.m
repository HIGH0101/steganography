clc;
clear;
%---------------------read cover and calculate capacity--------------------
c = double(imread('cover.jpg'));
[Len,wid,Height] =size(c);
capacity=Len*wid*Height;
%---------------read secret image & convert into binary vector-------------
secret=rgb2gray(imread('secret.jpg'));
secret=double(imbinarize(secret));
[L,w]=size(secret);
if L~=w
    error('secret image dimension must be square');
end 
bin=secret(:);
if length(bin)>capacity
    error('secret image can not be embeded.select a smaller secret picture');
end
len_parts=floor(length(bin)/3);
%-----------------------generate random key--------------------
seed_key=rng;
key=randperm(len_parts);
save('seed_key.mat')
%-------------------components are converted to vector----------------------
R=c(:,:,1);
G=c(:,:,2);
B=c(:,:,3);
R=R(:);
G=G(:);
B=B(:);
%-------------------split secret bits into 3 part-----------------------

inR=bin(1:len_parts,1);
inG=bin(len_parts+1:2*len_parts,1);
inB=bin(2*len_parts+1:end,1);
%----------------secrets bit are embeded by LSB method and key-----------
for i = 1 : len_parts
    cur_pos=key(i);          %cur_pos: current position
    bin=de2bi(R(cur_pos),8,'left-msb');
    bin(8)=inR(i);
    R(cur_pos)=bi2de(bin,'left-msb');
    
    bin=de2bi(G(cur_pos),8,'left-msb');
    bin(8)=inG(i);
    G(cur_pos)=bi2de(bin,'left-msb');
    
    bin=de2bi(B(cur_pos),8,'left-msb');
    bin(8)=inB(i);
    B(cur_pos)=bi2de(bin,'left-msb');
end
%-------------------reconstruct stego image-----------------------------
stego_R=reshape(R,Len,wid);
stego_G=reshape(G,Len,wid);
stego_B=reshape(B,Len,wid);
stego=zeros(Len,wid,3);
stego(:,:,1)=stego_R;
stego(:,:,2)=stego_G;
stego(:,:,3)=stego_B;
%------------------------evaluate stego image----------------------------
PSNR=psnr(uint8(c),uint8(stego),255);
imwrite(uint8(stego), 'stego.png');