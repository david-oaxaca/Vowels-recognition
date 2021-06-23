function [Y] = FFT(A)
    n = length(A);
    if n==1
        Y = [A(1)];
    else
        w = [];
        for k=0:n-1
            alpha = (-2*pi*k)./n;
            w = [w, (cos(alpha)+sin(alpha)*i)];
        end
        A0 = [];
        A1 = [];
        for k=0:(n/2)-1
            A0 = [A0, A(k*2+1)];
            A1 = [A1, A(k*2+2)];
        end
        Y0 = FFT(A0);
        Y1 = FFT(A1);

        Y = [];
        for k=1:length(Y0)
            Y = [Y, Y0(k)+w(k)*Y1(k)];
        end
        for k=1:length(Y0)
            Y = [Y, Y0(k)-w(k)*Y1(k)];
        end
    end
end

