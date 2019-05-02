function [stego]=conceal(msgVec1_CA,msgVec2_CA,cover,Delta,main_folder)                    

YCbCr=rgb2ycbcr(cover);     % RGB to YCbCr
Cb=YCbCr(:,:,2);
Cr=YCbCr(:,:,3);
[C,R]=size(Cb);

cd(strcat(main_folder,'\curvelet transform'));
scales_fdct_Cb = fdct_wrapping(Cb,1,1);                   % take curvelet Cb
scales_fdct_Cr = fdct_wrapping(Cr,1,1);  % take curvelet Cr
cd(main_folder);
        %==================== embeding in Cb component ==================== 

                      
scale=scales_fdct_Cb{(end)};                                   % select scale
[embeded_level] = Embeding(msgVec1_CA,scale,Delta);            % hiding part 1
scales_fdct_Cb{(end)}=embeded_level;                           % replace embeded scale  

        %===================== embeding in Cr component ===================


scale=scales_fdct_Cr{(end)};
[embeded_level] = Embeding(msgVec2_CA,scale,Delta);            % hiding part 2
scales_fdct_Cr{(end)}=embeded_level;


        %=================== inverse Cb & Cr curvelet =====================
cd(strcat(main_folder,'\curvelet transform'));
Cb=uint8(ifdct_wrapping(scales_fdct_Cb,1,C,R));
Cr=uint8(ifdct_wrapping(scales_fdct_Cr,1,C,R));
cd(main_folder);


YCbCr(:,:,3)=Cr;                             %replace embeded Cr component
YCbCr(:,:,2)=Cb;                             %replace embeded Cb component
stego=uint8(ycbcr2rgb(YCbCr));               % reconstruct stego image
end