
% Analyze Hiding Audio Signal in Coefficients' Curvelet Transform

% Input:
        % Detaset of images(768*1024)
        
        % Delta(treshold): determine embed Power for modifying coefficients
        %                    This is a integer number between 15 and 100    
        
        % audio signals with 32k,65k,131k and 256k samples
% Output:
        %AvgPsnr : average of images PSNRs after hiding audio  
        %AvgKl :   average of images Kullback–Leibler divergence after hiding audio
        %AvgErr : average of bit error rate from extracted audio(with or without attack) 
        %AvgPsnrAttack : average of images PSNRs after attack to images
        % AvgSNR : average of signal to noise ratio on audios
        
clc;
clear;
 % this is defualt curevelet scales for 768*1024 image
Delta=25;
fprintf('Embed power is %i ',Delta);
clc;
%concealTime=1.35;
%extractTime=1.200;
s=RandStream('mt19937ar' , 'seed' , 'shuffle');%num of sections that can be perform in your computer
RandStream.setGlobalStream(s);
rng(1);
key=randi(2016,[1,2016]);
main_folder =uigetdir('F:\','select project folder'); 
rng(1);
key1=randi(2016,[1,2016]);
AudioFile = uigetfile('*.wav','Select secret audio file'); 
[Sample,Fs]=audioread(AudioFile);  % read secret audio

[AvgPsnr,AvgKl,AvgErr,AvgPsnrAttack,AvgSNR,AvgSSIM]=HidingAnalyze(Sample,Fs,main_folder,Delta);
cd(strcat(main_folder,'\steganalysis')); 
stegoanalysis_error=ensembele_steganalysis(main_folder);
