function liverSSu=improveSSgpu(liverSS, erodeV, dilateV)


liverSSu=uint8(liverSS);
liverSSG=gpuArray(liverSSu);
 
liverSSG=imerode(liverSSG,true(erodeV,erodeV,'gpuArray'));
liverSSu=gather(liverSSG);
CC = bwconncomp(liverSSu);


numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
liverSSonly=zeros(size(liverSSu));
liverSSonly(CC.PixelIdxList{idx}) = 1;

liverSSu=uint8(liverSSonly);
liverSSG=gpuArray(liverSSu);

liverSSG=imdilate(liverSSG,true(dilateV,dilateV,'gpuArray'));

liverSSu=gather(liverSSG);

%figure,volshow(liverSSu);

end