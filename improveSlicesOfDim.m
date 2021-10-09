function [liverSSf,iou,acc]=improveSlicesOfDim(liverSS,...
            liver,dimFIXED,operations,...        
            erodeV,dilateV,windowWidth, isShow)

liverSSf=liverSS;
sz=size(liver,dimFIXED);

for i=1:sz
    if(dimFIXED==1)
        l=liverSSf(i,:,:);
        l=reshape(l,size(liverSSf,2),size(liverSSf,3));
        l=improve(l,operations,erodeV,dilateV,windowWidth);
        l=reshape(l,1,size(liverSSf,2),size(liverSSf,3));
        liverSSf(i,:,:)=l;
    elseif(dimFIXED==2)
        l=liverSSf(:,i,:);
        l=reshape(l,size(liverSSf,1),size(liverSSf,3));
        l=improve(l,operations,erodeV,dilateV,windowWidth);
        l=reshape(l,size(liverSSf,1),1,size(liverSSf,3));
        liverSSf(:,i,:)=l;        
    elseif(dimFIXED==3)
        l=liverSSf(:,:,i);
        l=reshape(l,size(liverSSf,1),size(liverSSf,2));
        l=improve(l,operations,erodeV,dilateV,windowWidth);
        l=reshape(l,size(liverSSf,1),size(liverSSf,1),1);
        liverSSf(:,:,i)=l;        
    end 
    
end    
    
liverSSf=liverSSf & liverSS;

[iou,acc]=metricIoU(liver, liverSSf);    
    
if(isShow)
    figure('Name','orig');volshow(liver,'ScaleFactors',[2 2 2]);    
    figure('Name','seg');volshow(liverSS,'ScaleFactors',[2 2 2]);
    figure('Name','imp');volshow(liverSSf,'ScaleFactors',[2 2 2]);
    disp("iou:" + iou + " acc:" + acc);
end  

end



function liverSSu=improve(liverSS,operations,erodeV,dilateV,windowWidth)
%operations="all","erodedilate","smoothfill"
    % erodedilate implica picklargest
    %smoothedgesfill nao porque faz no fim o picllargest no volume
liverSSu=liverSS;
if(strcmp(operations,'all') || strcmp(operations,'erodedilate'))
    liverSSu=erodeDilate(liverSSu,erodeV,dilateV);
    liverSSu=pickLargestRegion(liverSSu);
end


if(strcmp(operations,'all') || strcmp(operations,'smoothfill'))
    liverSSu=smoothEdgesFill(liverSSu,windowWidth);
end



end


%-------------------
function liverSSu=improve_OLD(liverSS,operations,erodeV,dilateV,windowWidth)

liverSS=smoothEdgesFill(liverSS,windowWidth);
liverSSu=uint8(liverSS);
 
%----
% Binarize the image
binaryImage = imbinarize(uint8(liverSSu));

% Extract the largest blob only
binaryImage = bwareafilt(binaryImage, 1);
% Fill holes
binaryImage = imfill(binaryImage, 'holes');    
    
blurredImage = conv2(double(binaryImage), ones(windowWidth)/windowWidth^2, 'same');

liverSSu = blurredImage > 0.5; 
    
%----


liverSSu=imerode(liverSSu,true(erodeV,erodeV));
CC = bwconncomp(liverSSu);
%CC=bwlabel(liverSSG);

numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
liverSSonly=zeros(size(liverSSu));
if(~isempty(idx))
    liverSSonly(CC.PixelIdxList{idx}) = 1;
end

liverSSu=uint8(liverSSonly);

liverSSu=imdilate(liverSSu,true(dilateV,dilateV));

end

function l=improveGPU_OLD(liverSS,operations,erodeV,dilateV)

liverSSu=uint8(liverSS);
liverSSG=gpuArray(liverSSu);
 
liverSSG=imerode(liverSSG,true(erodeV,erodeV,'gpuArray'));
liverSSu=gather(liverSSG);
CC = bwconncomp(liverSSu);
%CC=bwlabel(liverSSG);

numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
liverSSonly=zeros(size(liverSSu));
liverSSonly(CC.PixelIdxList{idx}) = 1;

liverSSu=uint8(liverSSonly);
liverSSG=gpuArray(liverSSu);

liverSSG=imdilate(liverSSG,true(dilateV,dilateV,'gpuArray'));

liverSSu=gather(liverSSG);

end
