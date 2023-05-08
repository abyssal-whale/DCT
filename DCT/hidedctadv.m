function [count,msg,result]=hidedctadv(image,imagegoal,msg,key,alpha) 
frr=fopen(msg,'r');
[msg,count]=fread(frr,'ubit1');		% 按位读取秘密信息
fclose(frr);
data0=imread(image);
data0=double(data0)/255;		% 将图像矩阵转为double型
data=data0(:,:,1);		% 取图像的一层做隐藏
T=dctmtx(8);					% 做图像分块
DCTrgb=blkproc(data,[8 8],'P1*x*P2',T,T');		% 对分块图像做DCT变换

% 产生随机的块选择，确定图像块的首地址
[row,col]=size(DCTrgb);
row=floor(row/8);
col=floor(col/8);
a=zeros([row col]);
[k1,k2]=randinterval(a,count,key);
for i=1:count
    k1(1,i)=(k1(1,i)-1)*8+1;           
    k2(1,i)=(k2(1,i)-1)*8+1;
end

% 信息嵌入
temp=0;
p=0;
for i=1:count
    if msg(i,1)==0
        if DCTrgb(k1(i)+4,k2(i)+1)>DCTrgb(k1(i)+3,k2(i)+2)
            temp=DCTrgb(k1(i)+4,k2(i)+1);        
            DCTrgb(k1(i)+4,k2(i)+1)=DCTrgb(k1(i)+3,k2(i)+2);         
            DCTrgb(k1(i)+3,k2(i)+2)=temp;
        end
    else
        if DCTrgb(k1(i)+4,k2(i)+1)<DCTrgb(k1(i)+3,k2(i)+2)
            temp=DCTrgb(k1(i)+4,k2(i)+1);      
            DCTrgb(k1(i)+4,k2(i)+1)=DCTrgb(k1(i)+3,k2(i)+2);
            DCTrgb(k1(i)+3,k2(i)+2)=temp;
        end
    end
    if DCTrgb(k1(i)+4,k2(i)+1)>DCTrgb(k1(i)+3,k2(i)+2)
        DCTrgb(k1(i)+3,k2(i)+2)=DCTrgb(k1(i)+3,k2(i)+2)-alpha;
    else
        DCTrgb(k1(i)+4,k2(i)+1)=DCTrgb(k1(i)+4,k2(i)+1)-alpha;
    end
end
DCTrgb1=DCTrgb;
data=blkproc(DCTrgb,[8 8],'P1*x*P2',T',T); 
result=data0; 
result(:,:,1)=data;
imwrite(result,imagegoal);