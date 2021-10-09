function [liverSSu,CC]=pickRegionsLargerThan(liver,sz)

liver=uint8(liver);
CC = bwconncomp(liver);


numPixels = cellfun(@numel,CC.PixelIdxList);
idx=find(numPixels>=sz);

liver1=zeros(size(liver));
if(~isempty(idx))
    for i=1:length(idx)
        liver1(CC.PixelIdxList{idx(i)}) = 1;
    end
end
liverSSu=uint8(liver1);
CC.PixelIdxList=CC.PixelIdxList(idx);

end