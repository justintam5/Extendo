clear;
close all;
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Main\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%Read image:
img_grey_ubit8 = rgb2gray(imread('Lab3_test_img3.PNG'));
img_grey = double(img_grey_ubit8); 
img_grey = 255 - img_grey; %invert colors
img_grey_ubit8 = 255 - img_grey_ubit8; 

img_rotate = imrotate(img_grey_ubit8,1,'bilinear','crop');
figure, img_final = imcrop(img_rotate);
img_fin_doub = double(img_final);
figure, imshow(img_fin_doub, [])
%{
figure, imshow(img_rotate, []);
axis on
hold on;
plot(y,x, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
%}

pixel = shape_coordinate(img_fin_doub);
object_num = size(pixel);
shape = cell(object_num(1), 1);

for i = 1:object_num(1)
    shape_temp = identify(pixel(i, :), img_fin_doub);
    locxy = shape_temp{1}; locxx = locxy(1); locyy  = locxy(2);
    [locy, locx] = get_length(img_final, locyy, locxx);
    shape_temp{1} = [locx locy];
    shape{i} = shape_temp;
end


%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Functions\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%
%Outlining Structure:
%
%Returns the pixel coordinates, orientation and shape 
% for each object within the grid.
%The orientation for each shape is defined by the angle wrt to the robix
%that the gripper must be in to grasp the object.
%



function bound_arr = bounds(box_ori_bin)
    sz = size(box_ori_bin);
    x_sum = sum(box_ori_bin, 1); %collapse to a column vector
    for i = 1:sz(2)
        if x_sum(i) > 0
            xL = i-1;
            break
        end
    end
    for i = sz(2):-1:1
        if x_sum(i) > 0
            xU = i+1;
            break
        end
    end
    y_sum = sum(box_ori_bin, 2); %collapse to a row vector
    for i = 1:sz(1)
        if y_sum(i) > 0
            yL = i-1;
            break
        end
    end
    for i = sz(1):-1:1
        if y_sum(i) > 0
            yU = i+1;
            break
        end
    end
    
    %Output Values
    bound_arr = [yL yU; xL xU];
end


function pixel = shape_coordinate(img_grey)
    shape_filter = ones(20);
    img_conv = conv2(img_grey, shape_filter, 'same');
    figure, imshow(img_conv, [])
    sz = size(img_conv);
 
    %Isolate shapes
    for j = 1:sz(1)
        for i = 1:sz(2)
            if img_conv(j, i) < 54000 
                img_conv(j, i) = 0;
            end
        end
    end 
    figure, imshow(img_conv, [])
    %figure, imshow(img_conv, [])
    
    %Reduce shapes to single coordinates:
    window_sz = 30; %n x n window size
    shape = 0;
    img_conv_pad = img_conv; %Add padding
    img_conv_pad(sz(1)+window_sz-1, sz(2)+window_sz-1) = 0; 
    for j = 1:sz(1)
        for i = 1:sz(2)
            l = j+round(window_sz/2); %Define middle
            m = i+round(window_sz/2); 
            window_arr = img_conv_pad(j:j+window_sz-1, i:i+window_sz-1);
            maximum = max(max(window_arr));
            [y, x] = find(window_arr == maximum); aa = [y, x];
            if (aa(1, 1) == l-j) && (aa(1, 2) == m-i) &&(maximum > 1000)
                shape = shape + 1;
                pixel(shape, :) = [l m];
            end
        end
    end 
end 


function idy = identify(pixel_cor, img_grey)
    idy = cell(3, 1); %pos, orientation, shape, and confidence
    %cut out a box arund the coordinate
    x = pixel_cor(2); y = pixel_cor(1);
    b_sz = 16;
    box = img_grey(y-b_sz:y+b_sz, x-b_sz:x+b_sz);
    box_org = box;

    %Isolate shape/Apply threshold
    shape_filter = ones(2);
    box_conv = conv2(box, shape_filter, 'same');
    figure, imshow(box_conv, [])
    sz = size(box_conv);
    for j = 1:sz(1)
        for i = 1:sz(2)
            if box_conv(j, i) < 880 
                box(j, i) = 0;
            else
                box(j, i) = 1;
            end
        end
    end 
    
    %Find center of mass
    total_mass  = sum(box, 'all');
    yaxis_sum = sum(box, 1);
    xaxis_sum = sum(box, 2);
    for i = 1:sz(2)
        x_weighted_sum(i) = i*yaxis_sum(i);
    end
    for j = 1:sz(1)
        y_weighted_sum(j) = j*xaxis_sum(j);
    end
    y_cm = sum(y_weighted_sum)/total_mass; %Center of mass wrt to box:
    x_cm = sum(x_weighted_sum)/total_mass; 
    y_cm_img = y_cm - b_sz + y; %Center of mass wrt to img:
    x_cm_img = x_cm - b_sz + x;

    %Detect orientation
    box_edge = edge(box,'sobel'); %Convert to edge detect img
    n = 11; horz_line = zeros(n); %nxn horizontal line
    horz_line(round(n/2), :) = ones(1, n);
    figure, imshow(horz_line, [])
    rot_sum  = zeros(360, 1);
    rot_conv_max = zeros(360, 1);
    
    for deg = 0:360 %Rotate image through [-180, 180), dtheta = 1
        idx = deg + 1;
        box_edge_rot = imrotate(box_edge, deg, 'bilinear','crop');
        rot_sum(idx) = sum(box_edge_rot, 'all');
        box_edge_rot = box_edge_rot/rot_sum(idx);
        box_edge_conv = conv2(box_edge_rot, horz_line, 'same');
        rot_conv_max(idx) = max(box_edge_conv, [], 'all');
        %norm_rot_conv_sum(idx) = rot_conv_sum(idx)/rot_sum(idx);
    end
    [Max, I_deg] = max(rot_conv_max);
    rot_deg = I_deg(1);
    S = std(rot_conv_max);
    box_filt_rot = imrotate(box, rot_deg);
    figure, imshow(box_edge_conv, [])
    figure, plot(rot_conv_max)
    %Detect Shape and Confidence
    bound_arr = bounds(box_filt_rot);
    length = bound_arr(1, 2) - bound_arr(1, 1)-1;
    width = bound_arr(2, 2) - bound_arr(2, 1)-1;
    area = sum(box_filt_rot, 'all'); 
    %area = area - area*0.08;%final term is 4noise 
    possible_shape = {'circle', 'triangle', 'square', 'rectangle'};
    shape_conf = [0 0 0 0]; %indexed off of possible shape cell
    err = [0 0 0 0];
    alpha = 3;
    err(1) = (max(abs(area-(pi*(width/2)^2)), ...
        abs(area-(pi*(length/2)^2))))/area;
    err(2) = abs(area-(width*length/2))/area;
    err(3) = min(abs(area-(width^2)), abs(area-(length^2)))/area+...
        abs(width-length)*0;
    err(4) = abs(area-(width*length))-abs((width-length)*alpha);
    for i = 1:4
        shape_conf(i) = exp(-err(i));
    end
    
    [confidence, shape_idx] = max(shape_conf);
    shape = possible_shape(shape_idx);
    
    
    %Set final values to output
    idy{1} = [x_cm_img y_cm_img]; 
    idy{2} = rot_deg;
    idy{3} = shape;
    idy{4} = confidence;
    
    %Plot:
    triangle = imread('Lab3_triangle.PNG');
    circle = imread('Lab3_circle.PNG');
    square = imread('Lab3_square.png');
    rectangle = imread('Lab3_rectangle.jpg');
    shape_img_idx = {circle triangle square rectangle};
    shape_img = cell2mat(shape_img_idx(shape_idx));
    figure,
    subplot(2,3,1)
    imshow(box_org, []);
    title('Orignal Box Cut Out')
    subplot(2,3,2)
    imshow(box, []);
    title('Conv+Thereshold Filtered Shape')
    subplot(2,3,3)
    imshow(imrotate(box_edge, 0), []);
    title('Edge Filtered Shape')
    subplot(2,3,4)
    imshow(box_filt_rot, []);
    title('Orientated Shape')
    subplot(2,3,5)
    imshow(box_filt_rot)
    hold on
    xline(bound_arr(2), 'g', 'LineWidth', 4);
    xline(bound_arr(4), 'g', 'LineWidth', 4);
    yline(bound_arr(3), 'g', 'LineWidth', 4);
    yline(bound_arr(1), 'g', 'LineWidth', 4);
    title('Bounded, and Orientated Shape')
    subplot(2,3,6)
    imshow(shape_img, []);
    title(char(shape))
end

%Lucas's stuff

function [locx, locy] = GetDistance(img_grey, x, y)
    % figure, imshow(img_grey, [])
    % img_conv = shape_coordinate(img_grey);



    figure, imshow(img_rotate, []);
    axis on
    hold on;
    plot(y,x, 'r+', 'MarkerSize', 30, 'LineWidth', 2);

    [locx, locy] = get_length(img_grey, x, y);
end


function img_final = rotate_image(img_conv)
     img_rotate = imrotate(img_conv,1,'bilinear','crop');
     figure, img_final = imcrop(img_rotate);
end


function scale = get_scale(index)

    scale = zeros(8,2);

    for ix = 1:6  
        scale(ix,2) = index(ix+1,2) - index(ix,2);
        scale(ix,2) = 2/scale(ix,2);
    end

    for iy = 1:8  
        scale(iy,1) = index(iy+1,1) - index(iy,1);
        scale(iy,1) = 2/scale(iy,1);
    end


end


function [locx, locy] = get_length(img, x, y)
    [numRows,numCols] = size(img);
    ycounter = 0;
    xcounter = 0;
    i = 10;
    index = zeros(9,2);

    while i <= numCols
        if img(10,i) > 115
            ycounter = ycounter + 1;
            index(ycounter, 1) = i;
            i = i + 3;
        end
        i = i + 1;
    end
    i = 10;
    while i <= numRows
        if img(i,15) > 115
            xcounter = xcounter + 1;
            index(xcounter, 2) = i;
            i = i + 3;
        end
        i = i + 1;
    end

    ycounter = 0;
    xcounter = 0;
    scale = get_scale(index);
    i=7;

    while x < index(i, 2)
        i = i - 1;
        xcounter = xcounter + 2;
    end
    i=1;
    while y > index(i, 1)
        ycounter = ycounter + 2;
        i = i + 1;
    end

    ycounter = ycounter - 10;

    locx = 2 + xcounter + scale(7-xcounter/2,2)*(index(7-xcounter/2, 2)- x);
    locy = ycounter + scale(5+ycounter/2, 1)*(y-index(5+ycounter/2, 1));

end


