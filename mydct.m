###### ÌÕDCT ######

function mydct(f)
  N = length(f);
  for x = 1:2*N
    if (x>=0 && x<=N)
      g(x) = f(x);
    else
      if (x>N && x<=2*N)
        g(x)= f(2*N - x + 1);
      endif
    endif
    g(x)
  endfor
  
  Gu_fft = real(fft(g));
  printf("FFT G(u): %f \n", Gu_fft);
  
  Fu = 0;
  Gu = 0;
  for u=1:2*N
    for x=1:N
      if (u-1)==0
        wu = 1/N;
      endif
      if u>1
        wu = sqrt(2/N);
      endif
      
      Fu = real(Fu + wu*f(x)*cos(((2*x+1)*pi*(u-1)/2*N)));
      Gu = real( Gu + (2*exp((j*pi*(u-1))/2*N)/wu) * Fu);

    endfor
        printf("G(u): %f \n", Gu);
  endfor
  
end