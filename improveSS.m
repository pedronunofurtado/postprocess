function [liverSSf, iou,acc]=improveSS(liverSS, liver, isErodeDilate, erodeV, dilateV, isShow)


liverSSu=uint8(liverSS);
 
if(isErodeDilate)
    liverSSu=imerode(liverSSu,true(erodeV,erodeV));

    liverSSu=pickLargestRegion(liverSSu);

    liverSSu=imdilate(liverSSu,true(dilateV,dilateV));

end

liverSSf=liverSSu & liverSS;

liverSSf=pickLargestRegion(liverSSf);

[iou,acc]=metricIoUone(liver, liverSSf);

if(isShow)
    figure('Name','orig');volshow(liver,'ScaleFactors',[2 2 2]);    
    figure('Name','seg');volshow(liverSS,'ScaleFactors',[2 2 2]);
    figure('Name','imp');volshow(liverSSf,'ScaleFactors',[2 2 2]);
    disp("iou:" + iou + " acc:" + acc);
end

end