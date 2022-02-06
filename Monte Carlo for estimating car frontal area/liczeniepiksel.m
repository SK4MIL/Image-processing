%% zliczanie pikseli
clear
tic
BW=imread('BWsalt09.jpg');
Image  = BW;
[row,col,color] = size(BW);
BW1     = im2bw(Image);
nBlack = sum(BW1(:));
nWhite = numel(BW1) - nBlack;
wynik_piksel=nBlack/(row*col)

toc
