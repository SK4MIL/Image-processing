function [result] = iDCT_with_quantization(colour, quantization_matrix)

colour = colour - 128.0;

% odwróenie kwantyzacji i DCT
colour = blkproc(colour, [8 8], 'x.*P1', quantization_matrix);

colour = blkproc(colour, [8 8], 'idct2(x)');  

% zdekodowana macierz
result = colour/255;      

end