function [result] = DCT_with_quantization(colour, quantization_table)

% dzielenie bloków na 8x8 pikseli
% przeprowadzanie na nich DCT
colour = blkproc(colour, [8 8], 'dct2(x)');

% określanie ile będzie takich bloków i zaokrąglenie tej liczby w górę
colour = blkproc(colour, [8 8], 'round(x./P1)', quantization_table);

colour = colour + 128.0; 

% zwracana jest skwantowana macierz
result = colour;

end