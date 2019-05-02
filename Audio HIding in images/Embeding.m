function [modifed_subband] = Embeding(msg,sub_band,treshold)
len_block=4;    % size of block
wid_block=4;    
len_first_level=length(sub_band);                   % compute number of subband in scale
m=1;                                                % counter for embeding bit
k=1;
for i=1:len_first_level                             % for all subband
    temp=sub_band{i};   
    [row,col]=size(temp);
    if m<length(msg)                                % compare counter m and length of message 
        end_col=floor(col/len_block);               % divding subband columns for blocking 
        end_row=floor(row/wid_block);               % divding subband rows  for blocking 
        for k=1:wid_block:(end_row*wid_block)
            for j=1:len_block:(end_col*len_block)  	% traverse all blocks
                if m<length(msg)                                 
                    block=temp(k:(k+wid_block)-1,j:(j+len_block)-1);  % seperate block(k,j)
                    c1=block(2,2);                  % coefficient(2,2)in block
                    c2=block(2,3);
                    c3=block(3,2);
                    c4=block(3,3);
                    
                    if msg(m)==0 && msg(m+1)==0      % modify c1 if secret messege(m)=00 

                       block(2,2)=treshold+c1;       % modify cofficient
                       m=m+2; 
                    elseif msg(m)==0 && msg(m+1)==1  % modify c2 if secret messege(m)=01 

                       block(2,3)=treshold+c2;
                       m=m+2;
                    elseif msg(m)==1 && msg(m+1)==0   % modify c3 if secret messege(m)=10 
                         
                       block(3,2)=treshold+c3;
                       m=m+2;
                    elseif msg(m)==1 && msg(m+1)==1   % modify c4 if secret messege(m)=11
                        
                       block(3,3)=treshold+c4;  
                       m=m+2;
                    end
                    temp(k:(k+wid_block)-1,j:(j+len_block)-1)=block; 
                else
                    break
                end
            end   
        end
        sub_band{i}=temp;
        
    else
        break
    end
end
modifed_subband=sub_band;
end

