function liverSSf=improveSlicesOfAllDims(liverSS,liver,order,...
            operations,...        
            erodeV,dilateV,windowWidth,isShowEach, isShow)
  

        
        liverSS1=improveSlicesOfDim(liverSS,liver,order(1),operations,...        
            erodeV,dilateV,windowWidth,isShowEach);

 if(length(order)>1)       
        liverSS2=improveSlicesOfDim(liverSS1,liver,order(2),operations,...        
            erodeV,dilateV,windowWidth,isShowEach);  
 else
     liverSS2=liverSS1;
 end
 
  if(length(order)>2)  
        liverSSf=improveSlicesOfDim(liverSS2,liver,order(3),operations,...        
            erodeV,dilateV,windowWidth,isShowEach);
  else
     liverSSf=liverSS2;
  end
 
liverSSf=pickLargestRegion(liverSSf); 
  
[iou,acc]=metricIoU(liver, liverSSf);    
    
if(isShow)
    figure('Name','orig');volshow(liver,'ScaleFactors',[2 2 2]);    
    figure('Name','seg');volshow(liverSS,'ScaleFactors',[2 2 2]);
    figure('Name','imp');volshow(liverSSf,'ScaleFactors',[2 2 2]);
    disp("iou:" + iou + " acc:" + acc);
end  
        
end
        
        