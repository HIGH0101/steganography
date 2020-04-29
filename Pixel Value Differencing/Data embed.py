from PIL import Image
import os
import math

def finding_band(ranges_list,diff):

    for k in ranges_list:
        if k[-1]>=diff:
            lowband=k[0]
            upband=k[-1]
            break
    return upband,lowband

def boundry_check(ranges_list,block):
    d=block[1]-block[0]
    uk,lk=finding_band(ranges_list,d)

    if d%2==0:          #inverse calculation
        pxs=block[0]-math.floor((uk-d)/2)
        pxs_1=block[1]+math.ceil((uk-d)/2)
        if 0<=pxs<=255 and 0<=pxs_1<=255:
            return d, True
        else:
            return d, False
    else:
        pxs=block[0]-math.ceil((uk-d)/2)
        pxs_1=block[1]+math.floor((uk-d)/2)
        if 0<=pxs<=255 and 0<=pxs_1<=255:
            return d, True
        else:
            return d, False

def embedding(m,block,d):
    if d%2==0:          #inverse calculation
        pxs_1=block[0]-math.floor(m/2)
        pxs=block[1]+math.ceil(m/2)
    else:
        pxs_1=block[0]-math.ceil(m/2)
        pxs=block[1]+math.floor(m/2)
    return [pxs_1,pxs]
    
def ascii2bin(str):
    bit_lists=[bin(ord(i))[2:].zfill(8) for i in str]
    return ''.join(bit_lists)    

def main():
    secret='A efficient steganographic method by pixel-value differencing (PVD)for embedding secret messages\
 into a gray-valued cover image is proposed by Wu and Tsai...'
    secret_bits=ascii2bin(secret)
    
    img = Image.open("cover.png")
    pxs = img.load()     # 2D Array pxs[x,y] ; pxs[0,0] = top left
    col,row = img.size
    R=[8,8,16,32,64,128] #[2,2,4,4,4,8,8,16,16,32,32,64,64]
    ranges_list=[]
    low_band=0
    for i in range(len(R)):
        up_band = sum(R[:i+1])
        ranges_list.append(list(range(low_band,up_band))) # create list of ranges
        low_band+=R[i]

    k=0
    for i in range(row):    #loop on rows               
        for j in range(1,col,2):    #loop on columns
            if k>=len(secret_bits):
                break 
            if i%2==1: 
                j=col-j   #odd rows are reversed for zigzag manner
            block=[pxs[j-1,i],pxs[j,i]]
            diff,embedded=boundry_check(ranges_list,block)

            if embedded==True:
                uk,lk=finding_band(ranges_list,diff)
                n_bits=int(math.log2(uk-lk+1))    #len of bits embedded
                condidate_bits=secret_bits[k:k+n_bits]
                if diff>=0:
                    new_diff=lk+int(condidate_bits,2)
                else:
                    new_diff=-1*(lk+int(condidate_bits,2))
                m=new_diff-diff
                new_pxs=embedding(m,block,diff)
                pxs[j-1,i],pxs[j,i]=new_pxs[0],new_pxs[1]
                k+=n_bits
    img.show()
    img.save("stego.png")
    img.close()
if __name__=='__main__':
    main()
