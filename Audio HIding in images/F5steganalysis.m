clc;
clear;
% imagefiles= dir('C:\Users\hadi\Desktop\washngton images\*.jpg');
% for i=1:length(imagefiles)
% 
%    cd('C:\Users\hadi\Desktop\washngton images');              %going to dataset folder for read images
%    currentfilename = imagefiles(i).name;
%    image = imread(currentfilename);
%    cd('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug');
%    imwrite(image,strcat(num2str(i),'.jpg'));
% end
% imagefiles= dir('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug\*.jpg');
% for i=1:length(imagefiles)
% cd('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug');
% input=strcat(num2str(i),'.jpg ');
% output=strcat('out',num2str(i),'.jpg');
% imwrite(randi([0,255],90,90),'secretimage.png');
% command =['F5 e -e secretimage.png -p mypasswd -q 70 ',input,' ',output];
% dos(command);
% movefile(output,'C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug\stegos')
% delete secretimage.png
% end

% coverfiles= dir('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug\covers\*.jpg');
% stegofiles= dir('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug\stegos\out*.jpg');
% numstego=length(stegofiles);
% numcover=length(coverfiles);
% 
% p=1;
% Dataset=zeros(numstego+numcover,1153);
% for i=1:numstego
% cd('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug\covers');              %going to dataset folder for read images
% currentcover = coverfiles(i).name;
% cover=rgb2gray(imread(currentcover));
% 
% cd('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug\stegos');
% currentstego = stegofiles(i).name;
% stego=rgb2gray(imread(currentstego));
% 
% cd('C:\Users\hadi\Desktop\curvelet transform')
% 
% scales_fdctCover = fdct_wrapping(cover,1,1);
% end_scaleCover=scales_fdctCover{(end)};
% end_1_scaleCover=scales_fdctCover{(end-1)};
% scales_fdct = fdct_wrapping(stego,1,1);
% end_scale=scales_fdct{(end)};
% end_1_scale=scales_fdct{(end-1)};
% 
% cvr_ENDsubbands=length(end_scaleCover);
% cvr_END_1subbands=length(end_1_scaleCover);
% 
% len_ENDsubbands=length(end_scale);
% len_END_1subbands=length(end_1_scale);
% cd('C:\Users\hadi\Desktop')
% %--------------------------defenition stego---------------------------------
% Correlation=zeros(1,64);
% Homogeneity=zeros(1,64);
% Contrast=zeros(1,64);
% Energy=zeros(1,64);
% Entrop=zeros(1,64);
% Mean=zeros(1,64);
% variance=zeros(1,64);
% skew=zeros(1,64);
% kurt=zeros(1,64);
% 
% Correlation2=zeros(1,64);
% Homogeneity2=zeros(1,64);
% Contrast2=zeros(1,64);
% Energy2=zeros(1,64);
% Entrop2=zeros(1,64);
% Mean2=zeros(1,64);
% variance2=zeros(1,64);
% skew2=zeros(1,64);
% kurt2=zeros(1,64);
% 
% %-------------------------defenition cover---------------------------------
% Correlation3=zeros(1,64);
% Homogeneity3=zeros(1,64);
% Contrast3=zeros(1,64);
% Energy3=zeros(1,64);
% Entrop3=zeros(1,64);
% Mean3=zeros(1,64);
% variance3=zeros(1,64);
% skew3=zeros(1,64);
% kurt3=zeros(1,64);
% 
% Correlation4=zeros(1,64);
% Homogeneity4=zeros(1,64);
% Contrast4=zeros(1,64);
% Energy4=zeros(1,64);
% Entrop4=zeros(1,64);
% Mean4=zeros(1,64);
% variance4=zeros(1,64);
% skew4=zeros(1,64);
% kurt4=zeros(1,64);
% 
% %------------------------calculate fetures for stego-----------------------
% %-----------------------features from end scale stego----------------------
% for k=1:64
% endscaleMin=min(min(end_scale{k}));
% endscaleMax=max(max(end_scale{k}));
% endnormalized=uint16(mapping(end_scale{k},endscaleMin,endscaleMax,1,65536));
% stats = graycoprops(endnormalized);
% Correlation(k)=stats.Correlation;
% Homogeneity(k)=stats.Homogeneity;
% Contrast(k)=stats.Contrast;
% Energy(k)=stats.Energy;
% Entrop(k) = Entropy(endnormalized);
% Mean(k)=mean(mean(end_scale{k}));
% variance(k)=var(var(end_scale{k},1),1);
% skew(k)=skewness(skewness(end_scale{k}));
% kurt(k)=kurtosis(kurtosis(end_scale{k}));
% end
% %-----------------------features from end-1 scale stego--------------------
% for k=1:64
% end_1scaleMin=min(min(end_1_scale{k}));
% end_1scaleMax=max(max(end_1_scale{k}));
% end_1normalized=uint16(mapping(end_1_scale{k},end_1scaleMin,end_1scaleMax,1,65536));
% stats2 = graycoprops(end_1normalized);
% Correlation2(k)=stats2.Correlation;
% Homogeneity2(k)=stats2.Homogeneity;
% Contrast2(k)=stats2.Contrast;
% Energy2(k)=stats2.Energy;
% Entrop2(k) = Entropy(end_1normalized);
% Mean2(k)=mean(mean(end_1_scale{k}));
% variance2(k)=var(var(end_1_scale{k},1),1);
% skew2(k)=skewness(skewness(end_1_scale{k}));
% kurt2(k)=kurtosis(kurtosis(end_1_scale{k}));
% end
% DatasetHalf1=horzcat(Correlation,Homogeneity,Contrast,Energy,Entrop,Mean,variance,skew,kurt);
% DatasetHalf2=horzcat(Correlation2,Homogeneity2,Contrast2,Energy2,Entrop2,Mean2,variance2,skew2,kurt2);
% Dataset(p,:)=horzcat(DatasetHalf1,DatasetHalf2,1);
% p=p+1;
% %-----------------------calculate fetures for cover------------------------
% %-----------------------features from end scale cover----------------------
% for j=1:64
% Min=min(min(end_scaleCover{j}));
% Max=max(max(end_scaleCover{j}));
% normalized=uint16(mapping(end_scaleCover{j},Min,Max,1,65536));
% stats = graycoprops(normalized);
% Correlation3(j)=stats.Correlation;
% Homogeneity3(j)=stats.Homogeneity;
% Contrast3(j)=stats.Contrast;
% Energy3(j)=stats.Energy;
% Entrop3(j) = Entropy(normalized);
% Mean3(j)=mean(mean(end_scaleCover{j}));
% variance3(j)=var(var(end_scaleCover{j},1),1);
% skew3(j)=skewness(skewness(end_scaleCover{j}));
% kurt3(j)=kurtosis(kurtosis(end_scaleCover{j}));
% end
% %----------------------features from end-1 scale cover --------------------
% for j=1:64
% end_1scaleMin=min(min(end_1_scaleCover{j}));
% end_1scaleMax=max(max(end_1_scaleCover{j}));
% end_1normalized=uint16(mapping(end_1_scaleCover{j},end_1scaleMin,end_1scaleMax,1,65536));
% stats2 = graycoprops(end_1normalized);
% Correlation4(j)=stats2.Correlation;
% Homogeneity4(j)=stats2.Homogeneity;
% Contrast4(j)=stats2.Contrast;
% Energy4(j)=stats2.Energy;
% Entrop4(j) = Entropy(end_1normalized);
% Mean4(j)=mean(mean(end_1_scaleCover{j}));
% variance4(j)=var(var(end_1_scaleCover{j},1),1);
% skew4(j)=skewness(skewness(end_1_scaleCover{j}));
% kurt4(j)=kurtosis(kurtosis(end_1_scaleCover{j}));
% end
% DatasetHalf1=horzcat(Correlation3,Homogeneity3,Contrast3,Energy3,Entrop3,Mean3,variance3,skew3,kurt3);
% DatasetHalf2=horzcat(Correlation4,Homogeneity4,Contrast4,Energy4,Entrop4,Mean4,variance4,skew4,kurt4);
% Dataset(p,:)=horzcat(DatasetHalf1,DatasetHalf2,0);
% p=p+1;
% end
cd('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug')
%save('Dataset.mat')
load('Dataset.mat')
[row,col]=size(Dataset);
row_train = round(row*0.7);
seq = randperm(row);
TrainData = Dataset(seq(1:row_train),:);
TestData = Dataset(seq(row_train+1:end),:);
train_label=TrainData(:,end);
test_label=TestData(:,end);
Test_features=TestData(:,1:end-1);
Train_feature=TrainData(:,1:end-1);
% fun=@meandata;
% [Selection , SelectionValue]=psoSelection(Train_feature,Test_features,train_label,test_label,500,20,8,fun );
% 

% [row,col]=size(Selection);
% row_train = round(row*0.7);
% seq = randperm(row);
% TrainData = Dataset(seq(1:row_train),:);
% TestData = Dataset(seq(row_train+1:end),:);
% train_label=TrainData(:,end);
% test_label=TestData(:,end);
% Test_features=TestData(:,1:end-1);
% Train_feature=TrainData(:,1:end-1);
SVMStruct = fitcsvm(Train_feature,train_label);
out_label = predict(SVMStruct,Test_features);
comparison=xor(out_label,test_label);
ER=length(find(comparison==1))/length(test_label);     % mohasebe error baraxe Accuracy=(FP+FN)/(FP+FN+TP+TN)
