clear;


org = imread('Wiosna-winniczka.jpg');
[org_row, org_column, org_colour] = size(org);

% transformacja każdego z pikseli z przestrzeni RGB do YCbCr
img_org_ycbcr = rgb2ycbcr(org);
[row, column, colour] = size(img_org_ycbcr);

%% Dodawanie pustych pikseli, dla uzsykania obrazu podzielnego na bloki 8x8. 
all_rows = ceil(row/8) * 8;
all_columns = ceil(column/8) * 8;
img_org_ycbcr = imresize(img_org_ycbcr, [all_rows all_columns]);

%% pobieranie składowych kolorów do przestrzenie YCbCr
Y  = img_org_ycbcr(:, :, 1);
Cb = zeros(all_rows/2, all_columns/2);
Cr = zeros(all_rows/2, all_columns/2);

%% Pobieranie pikseli
for i = 1 : all_rows/2
    % nieparzyste
    for j = 1 : 2 : (all_columns/2) - 1 
        Cb(i, j) = double(img_org_ycbcr(i*2 - 1, j*2 - 1, 2));
        Cr(i, j) = double(img_org_ycbcr(i*2 - 1, j*2 + 1, 3));
    end
    % parzyste
    for j = 2 : 2 : (all_columns/2) 
        Cb(i, j) = double(img_org_ycbcr(i*2 - 1, j*2 - 2, 2));
        Cr(i, j) = double(img_org_ycbcr(i*2 - 1, j*2,     3));
    end
end

% Transformata Anscombea
%img_ans = Anscombe(img_org_ycbcr);


% tabela kwantyzacji luminancji, czyli Y 
luminance = [ 16,  11,  10,  16,   24,   40, 51,  61;
    12,  12,  14,  19,   26,   58,   60,   55;
    14,  13,  16,  24,   40,   57,   69,   56; 
    14,  17,  22,  29,   51,   87,   80,   62;
    18,  22,  37,  56,   68,  109,  103,   77; 
    24,  35,  55,  64,   81,  104,  113,   92; 
    49,  64,  78,  87,  103,  121,  120,  101; 
    72,  92,  95,  98,  112, 100,  103,    99; ];

% tabela kwantyzacji chrominancji
chroma = [ 17,  18,  24,  47,  99,  99,  99,  99;
    18,  21,  26,  66,  99,  99,  99,  99;
    24,  26,  56,  99,  99,  99,  99,  99;
    47,  66,  99,  99,  99,  99,  99,  99;
    99,  99,  99,  99,  99,  99,  99,  99;
    99,  99,  99,  99,  99,  99,  99,  99;
    99,  99,  99,  99,  99,  99,  99,  99;
    99,  99,  99,  99,  99,  99,  99,  99; ];

% DCT i kwantyzacja dla trzech kanałów oddzielnie

Y_dct_q  = DCT_with_quantization(Y,  luminance);
Cb_dct_q = DCT_with_quantization(Cb, chroma);
Cr_dct_q = DCT_with_quantization(Cr, chroma);

%% Obliczanie poziomu kompresji 
non_zero = nnz(Y_dct_q==128)+ nnz(Cb_dct_q==128) + nnz(Cr_dct_q==128);
all_piksels = all_rows*all_columns *2;

most_common_proc = non_zero / (all_rows*all_columns *2) *100

% generowanie słownika Huffmana i kodu dla każdej składowej
I1 = floor(Y_dct_q(:));
dicty_Y = make_dict(Y_dct_q);
encoY = huffmanenco(I1, dicty_Y);

I2 = floor(Cb_dct_q(:));
dicty_Cb = make_dict(Cb_dct_q);
encoCb = huffmanenco(I2, dicty_Cb);

I3 = floor(Cr_dct_q(:));
dicty_Cr = make_dict(Cr_dct_q);
encoCr = huffmanenco(I3, dicty_Cr);

% zapis kodu huffmana i słownika do pliku
save('skompresowany.JKS', 'dicty_Y', 'encoY', 'dicty_Cb', 'encoCb', 'dicty_Cr', 'encoCr', '-mat');


%% Dekodowanie

% odczyt kodu huffmana i słowników
odczyt = load('skompresowany.JKS', '-mat');

% dekodowanie kodu Huffmana odczytanego z pliku
decoY  = col2im(huffmandeco(odczyt.encoY,  odczyt.dicty_Y),  [all_rows, all_columns],     [all_rows, all_columns],     'distinct');
decoCb = col2im(huffmandeco(odczyt.encoCb, odczyt.dicty_Cb), [all_rows/2, all_columns/2], [all_rows/2, all_columns/2], 'distinct');
decoCr = col2im(huffmandeco(odczyt.encoCr, odczyt.dicty_Cr), [all_rows/2, all_columns/2], [all_rows/2, all_columns/2], 'distinct');

% dekwantyzacja i odwrotna DCT dla każdego z kanałów
inv_Y  = iDCT_with_quantization(decoY,  luminance);
inv_Cb = iDCT_with_quantization(decoCb, chroma);
inv_Cr = iDCT_with_quantization(decoCr, chroma);

%% odzyskiwanie obrazu YCbCr
YCbCr_out_img(:, :, 1) = inv_Y;

for i=1:all_rows/2
    for j=1:all_columns/2
        
        YCbCr_out_img(2*i - 1, 2*j - 1, 2) = inv_Cb(i, j);
        YCbCr_out_img(2*i - 1, 2*j,     2) = inv_Cb(i, j);
        YCbCr_out_img(2*i, 2*j - 1, 2) = inv_Cb(i, j);
        YCbCr_out_img(2*i, 2*j,     2) = inv_Cb(i, j);
        
        YCbCr_out_img(2*i - 1, 2*j - 1, 3) = inv_Cr(i, j);
        YCbCr_out_img(2*i - 1, 2*j,     3) = inv_Cr(i, j);
        YCbCr_out_img(2*i, 2*j - 1, 3) = inv_Cr(i, j);
        YCbCr_out_img(2*i, 2*j,     3) = inv_Cr(i, j);
        
    end
end

% iAns_imgiAnscombe(YCbCr_out_img);

out_img = ycbcr2rgb(YCbCr_out_img);
out_img = imresize(out_img, [org_row org_column]);

%% Prezentacja
imwrite(out_img, 'out.bmp')
A = imread('out.bmp');
diff = immse(A, org);
disp(strcat(['Wartość błędu średniokwadratowego wynosi: ' num2str(diff)]));

figure(1)
imshow(org);
title('Obraz wejściowy');

figure(2)
imshow(out_img);
title('Obraz wyjściowy');

