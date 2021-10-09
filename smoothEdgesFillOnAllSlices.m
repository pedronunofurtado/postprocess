function liveri=smoothEdgesFillOnAllSlices(liveri,windowWidth)

for i=1:size(liveri,3)
    slice=liveri(:,:,i);
    if(sum(sum(slice))==0)
        continue;
    end
    slice=smoothEdgesFill(slice,windowWidth);
    liveri(:,:,i)=slice;
end

end