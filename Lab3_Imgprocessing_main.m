clear;
close all;
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Main\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


img_grey = double(rgb2gray(imread('Lab3_test_img.PNG'))); 
img_grey = 255 - img_grey; %invert colors
figure, imshow(img_grey, [])

img_conv = shape_coordinate(img_grey);
figure, imshow(img_conv, [])

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Functions\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%
%Outlining Structure:
%
%returns the rotated, and cropped grid 
%
function pix = pixel_wrt_robix(img_grey)
    img_edge = edge(img_grey, 'canny');
    figure, imshowpair(img_grey, img_edge, 'montage')
end


%Returns the pixel coordinates, orientation and shape 
% for each object within the grid.
%The orientation for each shape is defined by the angle wrt to the robix
%that the gripper must be in to grasp the object.
%
function pixel = shape_coordinate(img_grid)
    shape_filter = ones(20);
    img_conv = conv2(img_grid, shape_filter, 'same');
    sz = size(img_conv);
 
    %Isolate shapes
    for j = 1:sz(1)
        for i = 1:sz(2)
            if img_conv(j, i) < 54000 
                img_conv(j, i) = 0;
            end
        end
    end 
    
    %Reduce shapes to single coordinates:
    window_sz = 3; %3x3 window
    img_conv_pad = img_conv; %Add padding
    img_conv_pad(sz(1)+window_sz-1, sz(2)+window_sz-1) = 0; 
    for j = 1:sz(1)
        for i = 1:sz(2)
            window_arr = img_conv_pad(j:j+window_sz-1, i:i+window_sz-1);
            [M, I] = max(window_arr);
        end
    end 
    pixel = img_conv;
end 

