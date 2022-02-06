RGB = imread('tesla_s_front.jpg');

L = superpixels(RGB,500);
figure(1);
imshow(RGB)
h1 = drawpolygon('Position',[34,141; 7.5,231; 6.5,366; 28.5,517.5;...
        776.5,517.5; 761.5,155; 651.5,19; 194,9]);;
roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));
BW = grabcut(RGB,L,roi);
figure(2);
imshow(BW)
% maskedImage = RGB;
% maskedImage(repmat(~BW,[1 1 3])) = 0;
% figure(3)
% imshow(maskedImage)
%397312

Image  = BW;
[row,col,color] = size(BW);
BW1     = im2bw(Image);
nBlack = sum(BW1(:))
nWhite = numel(BW1) - nBlack
wynik=nBlack/(row*col)%(nWhite + nBlack)
bwarea(BW)

[rows, columns] = find('DDD',1,'last');  % Transpose 'DDD'
xTop = rows(1);
yTop = columns(1);
% Plot it
hold on;
figure(4)
plot(xTop, yTop, 'r+', 'MarkerSize', 10, 'LineWidth', 3);
hold off;