function test()
key=2002;
count=4;
alpha=0.5;
[count,msg,data]=hidedctadv('lenna.bmp','lennahide.bmp','plain.txt',key,alpha);
tt=extractdctadv('lennahide.bmp','recovered.txt',key,count);