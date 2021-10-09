function liveri=smoothEdgesFill(liveri,windowWidth)

% Binarize the image
    binaryImage = imbinarize(uint8(liveri));
% Extract the largest blob only
    binaryImage = bwareafilt(logical(liveri), 1);
% Fill holes
    binaryImage = imfill(binaryImage, 'holes');    
    
    blurredImage = conv2(double(binaryImage), ones(windowWidth)/windowWidth^2, 'same');

    %figure, imshow(blurredImage);
    
    % Threshold again.
    liveri = blurredImage > 0.5; 

end

