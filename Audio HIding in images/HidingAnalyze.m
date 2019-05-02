% 
%           
%       
function [avgPSNR,avgKL,avgerr,avgPsnrAttack,AvgSNR,AvgSSIM] = HidingAnalyze(S,Fs,main_folder,Delta)

LS=liftwave('haar','int2int');
[CA,CD]=lwt(double(S),LS);                             % take integer wavelet transfrm from  audio sample
CA_bin=sample2bin(CA,-1,1,0,255);                      % vector of CA sample bits
x= sprintf('length of secret message is %s bit',num2str(length(CA_bin)));
clc;
disp(x); 
        %================ divided secret bits to two parts ================

Sub_CA1=CA_bin (1:floor(length(CA_bin))/2);      % part 1 is for Cb embeding
Sub_CA2=CA_bin (floor(length(CA_bin)/2)+1:end);  % part 2 is for Cr embeding

%------------------ image preprocessing & cover selection -----------------
imagefiles= dir(strcat(main_folder,'\Dataset1\*.jpg'));
mkdir('suitable covers')
mkdir('rejected covers')
mkdir('stego images')
nfiles = length(imagefiles);                           % Number of images
n=1;
for ii=1:nfiles
   cd(strcat(main_folder,'\Dataset1'));              %going to dataset folder for read images
   currentfilename = imagefiles(ii).name;
   %[pathstr,name,ext] = fileparts(currentfilename);
   image = imread(currentfilename);              % read each image
   R=image(:,:,1);
   G=image(:,:,2);
   B=image(:,:,3);
   [r,c]=size(B);
   
   %============= compute variance on blocks(8*8) for each image ==========
   
   block_varianceR=zeros(round(r/8),round(c/8));
   block_varianceG=zeros(round(r/8),round(c/8)); % primary of block variance
   block_varianceB=zeros(round(r/8),round(c/8));
    l=1;
    for i=1:8:r
        k=1;
        for j=1:8:c
            tmpR=double(R(i:i+7,j:j+7));
            tmpG=double(G(i:i+7,j:j+7));
            tmpB=double(B(i:i+7,j:j+7));
            block_varianceR(l,k)=var(tmpR(:),1);     % matrix from block variances
            block_varianceG(l,k)=var(tmpG(:),1);
            block_varianceB(l,k)=var(tmpB(:),1);
            k=k+1;
        end
        l=l+1;
    end
     if length(block_varianceR(block_varianceR>400))>3000
        if length(block_varianceG(block_varianceG>400))>3000
           if length(block_varianceB(block_varianceB>400))>3000
              copyfile (currentfilename,strcat(main_folder,'\suitable covers'))
              cd(main_folder)

       %================== for selecting a image as cover =================

% [filename, pathname] = uigetfile({'*.png;*.jpg','MATLAB Files (*.png,*.jpg)'},...
% 'select image from suitble images');   
% imagefile=strcat(pathname,filename);
% cover=imread(imagefile);

%------------------------ concealing process ------------------------------
tic
stego=conceal(Sub_CA1,Sub_CA2,image,Delta,main_folder); %hiding secret bit
concealTime=toc;

imwrite(stego,fullfile(strcat(main_folder,'\stego images'),currentfilename),'jpeg')

PSNRstego(n)=psnr(stego,image,255);     % evaluate stego security 
%mse(n)=immse(stego,cover);
KLstego(n)=kullback_Leibler(stego,image);
SSIMstego(n)=ssim(image,stego);



%--------------------------- attacks process ------------------------------
   
        %========================= Gaussian noise (SNR)====================
    
 stegoNoise=uint8(zeros(r,c,3));
 stegoNoise(:,:,3)=double(addNoise(double(stego(:,:,3)),60)); 
 stegoNoise(:,:,2)=double(addNoise(double(stego(:,:,2)),60));
 stegoNoise(:,:,1)=double(addNoise(double(stego(:,:,1)),60)); 
   
        %============================== filters ===========================
    
%filt = fspecial('gaussian',[3,3],0.5);     %gaussian filter
%stegofilter=imfilter(stego,filt);

% filt = fspecial('laplacian',0.5);           % laplacian filter
% stegofilter=imfilter(double(stego),filt);   % apply filter
% stego_gaus=double(stego)-stegofilter;         %laplacian enhancement
   
        %============================ Add noise ===========================
     
%stegoSalt = imnoise(stego,'salt & pepper',0.001);
%stego_gaus = imnoise(stego,'gaussian',0,0.001);

        %============================= JPEG2000 ===========================
      
% cd('C:\Users\hadi\Desktop\Jpeg2000Gui')
% stegocompress = jpeg2000kakadu(stego,0.8,1,0,'parse',1);
% cd('F:\aeshad\dars\project\curvelet project')
% imwrite(stegocompress,'stegocompress.jpg')

        %======================  evaluate after attacks ===================

 %PSNRnoise(n)=psnr(uint8(stego_gaus),stego,255);
% KLnoise(n)=kullback_Leibler(stego_gaus,stego);
% SSIMnoise(n)=ssim(uint8(stego_gaus),stego);
% PSNRcompress(n)=psnr(stegocompress,stego,255);
% KLcompress(n)=kullback_Leibler(stegocompress,stego);


%----------------------- extracting process -------------------------------

    stego=rgb2ycbcr(stego);   % input can be imcompress,stegolap,stegonoise,stegofilter,without attack(stego)
    Cr=stego(:,:,3);
    Cb=stego(:,:,2);
    tic;
    ext_CA1=Extract(Cb,length(Sub_CA1),main_folder)'; 
    ext_CA2=Extract(Cr,length(Sub_CA2),main_folder)'; 
    extractTime=toc;

   fprintf('image %i: conceal Time %4.2f  extract Time %4.2f \n',ii,concealTime,extractTime)
    ext_CA_bin=(vertcat(ext_CA1,ext_CA2))';
    [~,biterrCA(n)] = biterr(CA_bin,ext_CA_bin);
    
    SNR(n)=10*log((sum(ext_CA_bin)/length(ext_CA_bin))/mse(ext_CA_bin,CA_bin));

    n=n+1;
        else
         copyfile (currentfilename,strcat(main_folder,'\rejected covers'))
         fprintf('image %i: is rejected \n',ii)
         end
        else
         copyfile (currentfilename,strcat(main_folder,'\rejected covers'))
         fprintf('image %i: is rejected \n',ii)
        end
        else
         copyfile (currentfilename,strcat(main_folder,'\rejected covers'))
         fprintf('image %i: is rejected \n',ii)
    end
end
%-----------seperate test and train stego images for steganalysis-----------
mkdir('StegoTestImages')
StegoImages= dir(strcat(main_folder,'\stego images\*.jpg'));
StegoTestImages=StegoImages(1:2:end); 
mfiles = length(StegoTestImages);
cd(strcat(main_folder,'\stego images')); 
for i=1:mfiles
    status=movefile(StegoTestImages(i).name,strcat(main_folder,'\StegoTestImages'));
end
cd(main_folder); 
%=================== write extracted audio ======================== 

ext_CA=bin2sample(ext_CA_bin,0,255,-1,1);
    audiowrite('audioextract.wav',ext_CA,round(Fs/2))   % extract audio from last suitable cover image

figure;
title('Original and extracted audio from last image')
subplot(2,1,1)
dt = 1/Fs;
t = 0:dt:(length(S)*dt)-dt;
plot(t,S); xlabel('Seconds'); ylabel('Amplitude');
axis([0,max(t),-2,2])
title('Original Audio','color','b')
subplot(2,1,2)
dt = 1/(Fs/2);
t = 0:dt:(length(ext_CA)*dt)-dt;
plot(t,ext_CA); xlabel('Seconds'); ylabel('Amplitude');
axis([0,max(t),-2,2])
title('Extracted Audio','color','r')

   

%------------------evaluate based on average of total images --------------

 avgPSNR=mean(PSNRstego);
 avgKL=mean(KLstego);
 AvgSSIM=mean(SSIMstego);
 avgerr=mean(biterrCA);

%avgPSNRnoise=mean(PSNRnoise);
%avgKLnoise=mean(KLnoise);
%avgSSIMnoise=mean(SSIMnoise);
%avgmse=mean(mse);
avgPsnrAttack=[];%mean(PSNRnoise); 
AvgSNR=mean(SNR);
%avdKLAttack=mean(KLcompress);

end

