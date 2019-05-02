clc;
clear;
%imagefiles= dir('C:\Users\hadi\Desktop\arborgreens\*.jpg');
% for i=1:1000
%    cd('C:\Users\hadi\Desktop\arborgreens');              %going to dataset folder for read images
%    currentfilename = imagefiles(i).name;
%    image = imread(currentfilename);
%    cd('C:\Users\hadi\Desktop\steganography algorithm\jp hide&seek');
%    imwrite(image,strcat(num2str(i),'.jpg'));
% end
passphrase='123456';
for i=1:1000
cd('C:\Users\hadi\Desktop\steganography algorithm\jp hide&seek');
input=strcat(num2str(i),'.jpg ');
output=strcat(' out',num2str(i),'.jpg');
command =['jphide ',input,output,' secretimage.jpg'];
%[k1,l1]=system('jphide  1.jpg out1.jpg secretimage.jpg');
[status,cmdout]=dos('jphide 1.jpg out1.jpg secretimage.jpg ; 123456 ;  123456');
dos(passphrase)
dos(passphrase)
end

coverfiles= dir('C:\Users\hadi\Desktop\New folder\*.jpg');
stegofiles= dir('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug\out*.jpg');
p=1;
Dataset=zeros(2000,1153);
for i=1:1000
cd('C:\Users\hadi\Desktop\New folder');              %going to dataset folder for read images
currentcover = coverfiles(i).name;
cover=imread(currentcover);
cd('C:\Users\hadi\Desktop\curvelet transform')
scales_fdctCover = fdct_wrapping(cover,1,1);
end_scaleCover=scales_fdctCover{(end)};
end_1_scaleCover=scales_fdctCover{(end-1)};
cd('C:\Users\hadi\Desktop\steganography algorithm\F5\f5-steganography-master_C#\F5Console\bin\Debug');
currentstego = stegofiles(i).name;
stego=imread(currentstego);
stego=rgb2gray(stego);
cd('C:\Users\hadi\Desktop\curvelet transform')
scales_fdct = fdct_wrapping(stego,1,1);
end_scale=scales_fdct{(end)};
end_1_scale=scales_fdct{(end-1)};
len_ENDsubbands=length(end_scale);
len_END_1subbands=length(end_1_scale);
cd('C:\Users\hadi\Desktop')
%--------------------------defenition--------------------------------------
corrcoef=zeros(1,len_ENDsubbands);
Correlation=zeros(1,len_ENDsubbands);
Homogeneity=zeros(1,len_ENDsubbands);
Contrast=zeros(1,len_ENDsubbands);
Energy=zeros(1,len_ENDsubbands);
Entrop=zeros(1,len_ENDsubbands);
Mean=zeros(1,len_ENDsubbands);
variance=zeros(1,len_ENDsubbands);
skew=zeros(1,len_ENDsubbands);
kurt=zeros(1,len_ENDsubbands);

Correlation2=zeros(1,len_END_1subbands);
Homogeneity2=zeros(1,len_END_1subbands);
Contrast2=zeros(1,len_END_1subbands);
Energy2=zeros(1,len_END_1subbands);
Entrop2=zeros(1,len_END_1subbands);
Mean2=zeros(1,len_END_1subbands);
variance2=zeros(1,len_END_1subbands);
skew2=zeros(1,len_END_1subbands);
kurt2=zeros(1,len_END_1subbands);

%------------------------calculate fetures for stego-----------------------
%-----------------------features from end scale stego----------------------
for k=1:len_ENDsubbands
endscaleMin=min(min(end_scale{k}));
endscaleMax=max(max(end_scale{k}));
endnormalized=uint16(mapping(end_scale{k},endscaleMin,endscaleMax,1,65536));
stats = graycoprops(endnormalized);
Correlation(k)=stats.Correlation;
Homogeneity(k)=stats.Homogeneity;
Contrast(k)=stats.Contrast;
Energy(k)=stats.Energy;
Entrop(k) = Entropy(endnormalized);
Mean(k)=mean(mean(end_scale{k}));
variance(k)=var(var(end_scale{k},1),1);
skew(k)=skewness(skewness(end_scale{k}));
kurt(k)=kurtosis(kurtosis(end_scale{k}));
%-----------------------features from end-1 scale stego--------------------
end_1scaleMin=min(min(end_1_scale{k}));
end_1scaleMax=max(max(end_1_scale{k}));
end_1normalized=uint16(mapping(end_1_scale{k},end_1scaleMin,end_1scaleMax,1,65536));
stats2 = graycoprops(end_1normalized);
Correlation2(k)=stats2.Correlation;
Homogeneity2(k)=stats2.Homogeneity;
Contrast2(k)=stats2.Contrast;
Energy2(k)=stats2.Energy;
Entrop2(k) = Entropy(end_1normalized);
Mean2(k)=mean(mean(end_1_scale{k}));
variance2(k)=var(var(end_1_scale{k},1),1);
skew2(k)=skewness(skewness(end_1_scale{k}));
kurt2(k)=kurtosis(kurtosis(end_1_scale{k}));
end
DatasetHalf1=horzcat(Correlation,Homogeneity,Contrast,Energy,Entrop,Mean,variance,skew,kurt);
DatasetHalf2=horzcat(Correlation2,Homogeneity2,Contrast2,Energy2,Entrop2,Mean2,variance2,skew2,kurt2);
Dataset(p,:)=horzcat(DatasetHalf1,DatasetHalf2,1);
p=p+1;
%-----------------------calculate fetures for cover------------------------
%-----------------------features from end scale cover----------------------
for j=1:len_ENDsubbands
Min=min(min(end_scaleCover{j}));
Max=max(max(end_scaleCover{j}));
normalized=uint16(mapping(end_scaleCover{j},Min,Max,1,65536));
stats = graycoprops(normalized);
Correlation(j)=stats.Correlation;
Homogeneity(j)=stats.Homogeneity;
Contrast(j)=stats.Contrast;
Energy(j)=stats.Energy;
Entrop(j) = Entropy(normalized);
Mean(j)=mean(mean(end_scaleCover{j}));
variance(j)=var(var(end_scaleCover{j},1),1);
skew(j)=skewness(skewness(end_scaleCover{j}));
kurt(j)=kurtosis(kurtosis(end_scaleCover{j}));
%----------------------features from end-1 scale cover --------------------
end_1scaleMin=min(min(end_1_scaleCover{j}));
end_1scaleMax=max(max(end_1_scaleCover{j}));
end_1normalized=uint16(mapping(end_1_scaleCover{j},end_1scaleMin,end_1scaleMax,1,65536));
stats2 = graycoprops(end_1normalized);
Correlation2(j)=stats2.Correlation;
Homogeneity2(j)=stats2.Homogeneity;
Contrast2(j)=stats2.Contrast;
Energy2(j)=stats2.Energy;
Entrop2(j) = Entropy(end_1normalized);
Mean2(j)=mean(mean(end_1_scaleCover{j}));
variance2(j)=var(var(end_1_scaleCover{j},1),1);
skew2(j)=skewness(skewness(end_1_scaleCover{j}));
kurt2(j)=kurtosis(kurtosis(end_1_scaleCover{j}));
end
DatasetHalf1=horzcat(Correlation,Homogeneity,Contrast,Energy,Entrop,Mean,variance,skew,kurt);
DatasetHalf2=horzcat(Correlation2,Homogeneity2,Contrast2,Energy2,Entrop2,Mean2,variance2,skew2,kurt2);
Dataset(p,:)=horzcat(DatasetHalf1,DatasetHalf2,0);
p=p+1;
end
[row,col]=size(Dataset);
row_train = round(row*0.7);
seq = randperm(row);
TrainData = Dataset(seq(1:row_train),:);
TestData = Dataset(seq(row_train+1:end),:);
train_label=TrainData(:,end);
test_label=TestData(:,end);
Test_features=TestData(:,1:end-1);
Train_feature=TrainData(:,1:end-1);
SVMStruct = svmtrain(Train_feature,train_label);
out_label = svmclassify(SVMStruct,Test_features);
comparison=xor(out_label,test_label);
ER=length(find(comparison==1))/length(test_label);     % mohasebe error baraxe Accuracy=(FP+FN)/(FP+FN+TP+TN)
