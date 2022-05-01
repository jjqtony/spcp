function outimg=gr_cp(im, meanim)

  w = [0.15 0.5 0.7   0.175 0.547];    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    h1 = w(1:3);
    h1 = [h1 h1(end-1:-1:1)];
    h1 = h1' * h1;

    h2 = h1;

    g = w(4:5);
    g = [g g(end-1:-1:1)];
    g = g' * g;
    
    
[rows, cols, chs]=size(im);
ps=1;
for k=1:chs
    I=im(:,:,k);
    
    I = padarray(I, [ps ps]);
    dx_f = imfilter(I ,[1 -1 0]);
    dy_f = imfilter(I ,[1 -1 0]');
    divG = imfilter(dx_f, [0 1 -1]) + imfilter(dy_f, [0 1 -1]'); 
    
     Ir = evalf( -divG, h1, h2, g );
     Ir = Ir-mean(Ir(:))+meanim(k);
     outimg(:,:,k)=Ir;
end

outimg = outimg(ps+1:end-ps,ps+1:end-ps, :);



