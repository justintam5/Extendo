%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Main\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
img = 'pic.png';
x = 197; y = 231;
[locx, locy] = GetDistanceMeasurement(img, x, y);

function [locx, locy] = GetDistanceMeasurement(img, x, y)
    img_grey = rgb2gray(imread(img));
    img_grey = 255 - img_grey; %invert colors

    % figure, imshow(img_grey, [])
    % img_conv = shape_coordinate(img_grey);
    img_conv = img_grey;

    img_rotate = rotate_image(img_conv);
    figure, imshow(img_rotate, []);
    axis on
    hold on;
    plot(y,x, 'r+', 'MarkerSize', 30, 'LineWidth', 2);

    [locx, locy] = get_length(img_rotate, x, y);
end

function img_final = rotate_image(img_conv)
     img_rotate = imrotate(img_conv,1,'bilinear','crop');
     img_final = imcrop(img_rotate);
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
function pix = pixel_wrt_robix(img_grey)
    img_edge = edge(img_grey, 'canny');
    figure, imshowpair(img_grey, img_edge, 'montage')
end
function pixel = shape_coordinate(img_grid)
    shape_filter = ones(20);
    img_conv = conv2(img_grid, shape_filter, 'same');
    sz = size(img_conv);

    %Isolate shapes
    for j = 1:sz(1)
        for i = 1:sz(2)
            if img_conv(j, i) < 45000 
                img_conv(j, i) = 0;
            else
                img_grid(j, i) = 87;
            end
        end
    end 
    pixel = img_grid;
end

