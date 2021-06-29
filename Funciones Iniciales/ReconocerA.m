function [vocal, genero] = ReconocerA(Y)
    %Reconocimiento de Vocales
    seg = 2;
    frec = 10000;
    tam = frec*seg;
    
    %reducimos la amplitud de ruidos ajenos al principal con la ventana hamming
    %aplicada a cada punto de la señal (proximamente sólo de silencio a silencio)
    reduced = Y.*hamming(tam);
    
    %hacemos transf fourier
    ft_f=fftshift(fft(reduced));
    nfft = tam; %tamaño de la señal en dominio del tiempo
    
    
    nfft2 = 2^nextpow2(nfft); % tamaño de la señal en potencia de 2
    ff = fft(reduced,nfft2);%para limitar a valores positivos la respuesta en frecuencia
    fff=ff(1:nfft2/2);
    xfft=frec*(0:nfft2/2-1)/nfft2; %se necesita que las muestras en x sean igual a muestras en y
    
    %lpc (predicción lineal) para la respuesta en frecuencias
    preemph = [1 0.63]; x1 = filter(1,preemph,reduced);
    A = lpc(x1,12); rts = roots(A);
    rts = rts(imag(rts)>=0); 
    angz = atan2(imag(rts),real(rts));
    [frqs,indices] = sort(angz.*(frec/(2*pi))); 
    bw = -1/2*(frec/(2*pi))*log(abs(rts(indices)));
    nn = 1; 
    for kk = 1:length(frqs)
        if (frqs(kk) > 90 && bw(kk) <400)
            formants(nn) = frqs(kk);
            nn = nn+1;
        end
    end
    
    %predicción
    %va =[1000,1400];
    %ve =[500,2300];
    %vi =[320,2700];
    %vo =[404,743];
    %vu =[277,544];
    
    vaf = [874.867, 1497.8];
    vef = [615.867, 2209.8];
    vif = [536.533, 2165.7];
    vof = [ 495.13,  823.4];
    vuf = [ 447.8,  1330.2];
    
    vah = [746.6, 1265];
    veh = [523.9, 1816];
    vih = [415.5, 1769];
    voh = [444.9, 769.2];
    vuh = [313.8, 665.6];
    
    
    vocal = [formants(1),formants(2)]
    
    distaf = norm(vaf-vocal);
    distef = norm(vef-vocal);
    distif = norm(vif-vocal);
    distof = norm(vof-vocal);
    distuf = norm(vuf-vocal);
    
    distah = norm(vah-vocal);
    disteh = norm(veh-vocal);
    distih = norm(vih-vocal);
    distoh = norm(voh-vocal);
    distuh = norm(vuh-vocal);
    
    aux = [distaf,distef,distif,distof,distuf,distah,disteh,distih,distoh,distuh];
    
    pred = min(aux)
    
    switch pred
        case distaf
            vocal = 'a';
            genero = 'Femenino';
        %case distef
            %vocal = 'e';
            %genero = 'Femenino';
        %case distif
            %vocal = 'i';
            %genero = 'Femenino';
        %case distof
            %vocal = 'o';
            %genero = 'Femenino';
        %case distuf
            %vocal = 'u';
            %genero = 'Femenino';
        case distah
            vocal = 'a';
            genero = 'Masculino';
        %case disteh
            %vocal = 'e';
            %genero = 'Masculino';
        %case distih
            %vocal = 'i';
            %genero = 'Masculino';
        %case distoh
            %vocal = 'o';
            %genero = 'Masculino';
        %case distuh
            %vocal = 'u';
            %genero = 'Masculino';
        otherwise
            vocal = false;
            genero = false;
    end
end
