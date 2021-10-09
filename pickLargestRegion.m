function liverSSu=pickLargestRegion(liver)

liver=uint8(liver);
CC = bwconncomp(liver);


numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
liver1=zeros(size(liver));
if(~isempty(idx))
    liver1(CC.PixelIdxList{idx}) = 1;
end
liverSSu=uint8(liver1);

end