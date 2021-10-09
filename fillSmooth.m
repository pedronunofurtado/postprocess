function liver=fillSmooth(liver,windowWidth)


for i=1:size(liver,3)
    
    liveri=liver(:,:,i);
% Binarize the image
binaryImage = imbinarize(uint8(liveri));
% Extract the largest blob only
binaryImage = bwareafilt(liveri, 1);
% Fill holes
binaryImage = imfill(binaryImage, 'holes');    
    
    blurredImage = conv2(double(binaryImage), ones(windowWidth)/windowWidth^2, 'same');

    %figure, imshow(blurredImage);
    
    % Threshold again.
    liveri = blurredImage > 0.5; 
    
    liver(:,:,i)=liveri;
end

end