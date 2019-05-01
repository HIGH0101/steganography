clc;
clear;
s=double(imread('stego.png'));
[Len,wid,Height] =size(s);
R=s(:,:,1);
G=s(:,:,2);
B=s(:,:,3);
R=R(:);
G=G(:);
B=B(:);
%------------------------receive key for extract---------------------
load('seed_key.mat')
rng(seed_key);
len_secret=floor((L*w)/3);
key=randperm(len_secret);
%-------------------extract lsb bits--------------------------------
secretBit=zeros(3*len_parts+1,1);
for i = 1 :len_parts
    cur_pos=key(i);          %cur_pos: current position
    inR(i)=bitget(R(cur_pos),1);
    inG(i)=bitget(G(cur_pos),1);
    inB(i)=bitget(B(cur_pos),1);
end
secretBit(1:len_parts,1)=inR;
secretBit(len_parts+1:2*len_parts,1)=inG;
secretBit(2*len_parts+1:end-1,1)=inB;
secret=reshape(secretBit,512,512);
imwrite(secret,'ex_secret.jpg')

