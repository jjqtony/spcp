function demo
epsl=1e-8;
%addpath('../Sec4_Greens');
addpath('./image1');  
%addpath('./image2');


Simg=double(imread('bg.jpg'));
Fimg=double(imread('fg.jpg'));
mask=imread('mask.jpg');

posx=123; posy=103;   %for image1
%posx=90; posy=100;   %for image2

mask=mask(:,:,1);
mask=mask>127;
sm=size(mask);
res=Simg;
for i=1:3
    srect=res(posy:posy+sm(1)-1, posx:posx+sm(2)-1,i);
    tmp=Fimg(:,:,i);
    srect(mask)=tmp(mask);
    res(posy:posy+sm(1)-1, posx:posx+sm(2)-1,i)=srect;
end

figure, imshow(uint8(res)); title('naive paste');

channels=3;
Ss=Simg;  src=Fimg;
res=0*Simg;
for i=1:channels
    S=Ss(:,:,i);
    S=padarray(S,[1,1]);
    tmp_sc=src(:,:,i);
   
    
    dxsrc=imfilter(tmp_sc, [0,-1,1]);
    dysrc=imfilter(tmp_sc, [0,-1,1]');
    dxS=imfilter(S, [0,-1,1]);
    dyS=imfilter(S, [0,-1,1]');
    
    recs=S(posy:posy+sm(1)-1, posx:posx+sm(2)-1);
    recs(mask)=tmp_sc(mask);
    S(posy:posy+sm(1)-1, posx:posx+sm(2)-1)=recs;
    
    recs=dxS(posy:posy+sm(1)-1, posx:posx+sm(2)-1);
    recs(mask)=dxsrc(mask);
    tmpmat=cat(3,recs, dxS(posy:posy+sm(1)-1, posx:posx+sm(2)-1));
    [~,maxindx]=max(abs(tmpmat),[],3);
    maxindx=(maxindx==2);
    dxS(posy:posy+sm(1)-1, posx:posx+sm(2)-1)=recs.*(1-maxindx) + ...
        dxS(posy:posy+sm(1)-1, posx:posx+sm(2)-1).*maxindx;
    
    recs=dyS(posy:posy+sm(1)-1, posx:posx+sm(2)-1);
    recs(mask)=dysrc(mask);
    tmpmat=cat(3,recs, dyS(posy:posy+sm(1)-1, posx:posx+sm(2)-1));
    [~,maxindx]=max(abs(tmpmat),[],3);
    maxindx=(maxindx==2);
    dyS(posy:posy+sm(1)-1, posx:posx+sm(2)-1)=recs.*(1-maxindx) + ...
        dyS(posy:posy+sm(1)-1, posx:posx+sm(2)-1).*maxindx;
    
    
    U=spcp(S, dxS, dyS, epsl);
    res(:,:,i)=U(2:end-1,2:end-1);
    
end
figure, imshow(uint8(res)); 
