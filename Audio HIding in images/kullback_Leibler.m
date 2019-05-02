function KL=kullback_Leibler(stego,cover)
stego=double(stego(:));
cover=double(cover(:));
U_cover=unique(cover);
U_stego=unique(stego);
pd_stego=histc(stego,U_stego)/length(stego); % probability distribution stego 
pd_cover=histc(cover,U_cover)/length(cover); % probability distribution cover

for i=1:length(U_cover)
    result=ismember(U_cover(i),U_stego);
    if result==0
    pd_stego=vertcat(pd_stego,0);
    end
end

for i=1:length(U_stego)
    result=ismember(U_stego(i),U_cover);
    if result==0
    pd_cover=vertcat(pd_cover,0);
    end
end
temp=pd_cover.*log2(pd_cover./pd_stego);
temp(isnan(temp))=0;
KL=sum(temp);
end