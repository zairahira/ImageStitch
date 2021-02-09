function stitch(imgFiles)
    
    assert(length(imgFiles) == 8);
    
    % compute sift feature vectors
    [sifts, siftLoc, images] = getSift(imgFiles);
    
    doStitch(sifts, siftLoc, images);
end