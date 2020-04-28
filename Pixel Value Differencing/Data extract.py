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
    d=abs(block[0]-block[1])
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

def split_n(line, n):
    return [line[i:i+n] for i in range(0, len(line), n)]


def bin2ascii(inputs):
    return ''.join(map(lambda x: chr(int(x, 2)),
                   split_n(inputs, 8)))


def main():
    img = Image.open("stego.png")
    pxs = img.load()     # 2D Array pxs[x,y] ; pxs[0,0] = top left
    col,row = img.size
    R=[8,8,16,32,64,128] #[2,2,4,4,4,8,8,16,16,32,32,64,64]
    if sum(R)!=256:
        print('sorry,sum of R must be 256')  
        exit()

    ranges_list=[]
    low_band=0
    for i in range(len(R)):
        up_band = sum(R[:i+1])
        ranges_list.append(list(range(low_band,up_band))) # create list of ranges
        low_band+=R[i]

    secret_bits=[] 
    for i in range(row):            #loop on rows
        for j in range(1,col,2):    #loop on columns
            if i%2==1: 
                j=col-j   #odd rows are reversed for zigzag manner
            block=[pxs[j-1,i],pxs[j,i]]
            diff,embedded=boundry_check(ranges_list,block)   
            if embedded==True:
                uk,lk=finding_band(ranges_list,diff)
                n_bits=int(math.log2(uk-lk+1))    #len of bits embedded
                secret_bits.append(bin(diff-lk)[2:].zfill(n_bits))
    secret_bits=''.join(secret_bits)
    msg=bin2ascii(secret_bits)
    print(msg)

if __name__=='__main__':
    main()
