function message=Extract(component_stego,len_msg,project_folder)

len_block=4;
wid_block=4;

cd(strcat(project_folder,'\curvelet transform'));
curveletT=fdct_wrapping(component_stego,1,1);
cd(project_folder);

sub_band=curveletT{(end)};
len_first_level=length(sub_band);
m=1;                          % counter for extract bit
msgVec=zeros(1,len_msg);      % message vetor 
for i=1:len_first_level      % for all subband
    temp=sub_band{i};
    [row,col]=size(temp);
    end_col=floor(col/len_block);        % divding subband columns for blocking    
    end_row=floor(row/wid_block);        % divding subband rows  for blocking
    if len_msg<m
        break
    end
    for k=1:wid_block:(end_row*wid_block)
        for j=1:len_block:(end_col*len_block)    % traverse all blocks(k,j)
            if len_msg<m
                 break
            else
                block=temp(k:(k+wid_block)-1,j:(j+len_block)-1);  % seperate block(k,j)
                c1=block(2,2);    % coefficient(2,2)in block
                c2=block(2,3);
                c3=block(3,2);
                c4=block(3,3);
                 %sum_block1=sum(sum(innerblock1));
                 %sum_block2=sum(sum(innerblock2));
                 if c1>c2 && c1>c3 && c1>c4    % extract secret messege(m)=00 if c1> c2,c3,c4 
                     msgVec(m)=0;
                     msgVec(m+1)=0;
                     m=m+2;
                 elseif c2>c1 && c2>c3 && c2>c4   % extract secret messege(m)=01 if c2> c1,c3,c4 
                     msgVec(m)=0;
                     msgVec(m+1)=1;
                     m=m+2;
                 elseif c3>c1 && c3>c2 && c3>c4    % extract secret messege(m)=10 if c3> c2,c1,c4 
                     msgVec(m)=1;
                     msgVec(m+1)=0;
                     m=m+2;
                 elseif c4>c1 && c4>c2 && c4>c3     % extract secret messege(m)=11 if c4> c2,c3,c1 
                     msgVec(m)=1;
                     msgVec(m+1)=1;
                     m=m+2;
                 end
            end
        end
    end
end
message=msgVec;
if length(msgVec)>len_msg && mod(length(msgVec),2)==0
message=msgVec(1:end-1);
end

end