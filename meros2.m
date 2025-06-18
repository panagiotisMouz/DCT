###### MEROS 2 ######

# 1. Read the image
cameraman_image = imread('cameraman.tif');
figure('name','Before');
imagesc(cameraman_image);
colormap(gray);

# 2. Entropy of image
e = entropy(cameraman_image);
printf("Entropy=%f\n", e)

# 3. Reshape image into 8x8 block matrix
matrix_8x8 = double(reshape(cameraman_image,8,8,[]));

# 4. DCT for every 8x8 block using dct2 function
matrix_dct = [];
for i=1:1024
  matrix_dct(:,:,i) = round(dct2(matrix_8x8(:,:,i)));
endfor

# 5. Quantize the coefficients of each 8x8 block
Q1 = [16 11 10 16 24 40 51 61; 
      12 12 14 19 26 58 60 55;
      14 13 16 24 40 57 69 56; 
      14 17 22 29 51 87 80 62;
      18 22 37 56 68 109 103 77;
      24 35 55 64 81 104 113 92;
      49 64 78 87 103 121 120 101;
      72 92 95 98 112 100 103 99];

Q3 = 3*Q1;
Q5 = 5*Q1;

quantization_matrix = [];
for i=1:1024
  quantization_matrix(:,:,i) = round(matrix_dct(:,:,i) ./ Q1);
endfor

# 6. Entropy of quantized coefficients of image
abs_entropy = entropy(abs(quantization_matrix));
printf("|F(u,v)| Entropy=%f\n", e)

# 7. Number of image coefficients set to zero after quantizations
zeros = numel (find (quantization_matrix==0));
printf("\nZeros:%d \n", zeros);

# 8. Inverse quantization
I_quantization_matrix = [];
for i=1:1024
  I_quantization_matrix(:,:,i) = round(quantization_matrix(:,:,i) .* Q1);
endfor

# 9. Inverse DCT
inverse_dct_matrix = [];
for i=1:1024
  inverse_dct_matrix(:,:,i) = round(idct2(I_quantization_matrix(:,:,i)));
endfor

# 10. Convert image to uint8
inverse_dct_matrix = reshape(inverse_dct_matrix, 256, 256, []);
cameraman_image_uint8 = uint8(inverse_dct_matrix);

# 11. Calculate image PSNR
PSNR = psnr(cameraman_image_uint8, cameraman_image);
printf("PSNR=%f\n", PSNR);

# Display image
figure('name','After');
imagesc(cameraman_image_uint8);
colormap(gray);