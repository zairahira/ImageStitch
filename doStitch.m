function doStitch(sifts, siftLoc, images)

    assert(length(sifts) == 8);
    assert(length(siftLoc) == 8);
    assert(length(images) == 8);
    
    [H12, corres12_1, corres12_2, inlinersIdx12] = ...
        getHomography(sifts{1}, siftLoc{1}, sifts{2}, siftLoc{2});
    [H32, corres32_1, corres32_2, inlinersIdx32] = ...
        getHomography(sifts{3}, siftLoc{3}, sifts{2}, siftLoc{2});
    [H43, corres43_1, corres43_2, inlinersIdx43] = ...
        getHomography(sifts{4}, siftLoc{4}, sifts{3}, siftLoc{3});
    
    [H54, corres54_1, corres54_2, inlinersIdx54] = ...
        getHomography(sifts{5}, siftLoc{5}, sifts{4}, siftLoc{4});
    [H65, corres65_1, corres65_2, inlinersIdx65] = ...
        getHomography(sifts{6}, siftLoc{6}, sifts{5}, siftLoc{5});
    [H76, corres76_1, corres76_2, inlinersIdx76] = ...
        getHomography(sifts{7}, siftLoc{7}, sifts{6}, siftLoc{6});
    [H87, corres87_1, corres87_2, inlinersIdx87] = ...
        getHomography(sifts{8}, siftLoc{8}, sifts{7}, siftLoc{7});
   % [H98, corres98_1, corres98_2, inlinersIdx98] = ...
%        getHomography(sifts{9}, siftLoc{9}, sifts{8}, siftLoc{8});
    
 
    
    
    visualize(images{1}, corres12_1', corres12_2', inlinersIdx12, 'Image 1 - 2');
    visualize(images{2}, corres32_1', corres32_2', inlinersIdx32, 'Image 2 - 3');
     visualize(images{3}, corres43_1', corres43_2', inlinersIdx43, 'Image 3 - 4');
      visualize(images{5}, corres54_1', corres54_2', inlinersIdx54, 'Image 4 - 5');
      
       visualize(images{6}, corres65_1', corres65_2', inlinersIdx65, 'Image 5- 6');
        visualize(images{7}, corres76_1', corres76_2', inlinersIdx76, 'Image 6 - 7');
         visualize(images{8}, corres87_1', corres87_2', inlinersIdx87, 'Image 7 - 8');
        %  visualize(images{9}, corres98_1', corres98_2', inlinersIdx98, 'Image 8 - 9');
    
    % image space for mosaic
    % TODO: not hard-code...
    %bbox = [0 0 0 0];
    bbox = getBoundingBox([0 0 0 0], images, {H12,H32,eye(3),H43,H54, H65,H76,H87});
    l = abs(bbox(1));    t = abs(bbox(3));
    bbox = bbox + [-l/4 l -t/2 -t/2];
    
    % warp image 1 to mosaic image
    Im1w = vgg_warp_H(double(images{1}), H12, 'linear', bbox);
    Im2w = vgg_warp_H(double(images{2}), H32, 'linear', bbox);
    Im3w = vgg_warp_H(double(images{3}), H43, 'linear', bbox);
    Im4w = vgg_warp_H(double(images{4}), eye(3), 'linear', bbox);
   
    
    Im5w = vgg_warp_H(double(images{5}), H54, 'linear', bbox);
    Im6w = vgg_warp_H(double(images{6}), H65, 'linear', bbox);
    Im7w = vgg_warp_H(double(images{7}), H76, 'linear', bbox);
  %Im8w = vgg_warp_H(double(images{8}), 87, 'linear', bbox);
    
   a= double(max(Im1w,Im2w));
      b=double(max(Im3w,Im4w));
      c=double(max(Im5w,Im6w));
    
      e=max(a,b);
  anss= max(e,c);
  fans= max(anss,Im7w);
   
   
    figure();
     
    imagesc(double(fans)/255);

end

function newBox = getBoundingBox(bbox, images, H)
    assert(length(images) == 8);
    n = length(images);
    newBox = bbox;
    for i=1:n
        [w, h, ~] = size(images{i});
        imgBox = H{i}*[1 w 1 w; 1 1 h h; 1 1 1 1];
        imgBox = [imgBox(1, :) ./ imgBox(3, :); ...
                  imgBox(2, :) ./ imgBox(3, :)];
        newBox = [  ceil(min(newBox(1), min(imgBox(1, :)))) ...
                    ceil(max(newBox(2), max(imgBox(1, :)))) ...
                    ceil(min(newBox(3), min(imgBox(2, :)))) ...
                    ceil(max(newBox(4), max(imgBox(2, :))))];
    end
end