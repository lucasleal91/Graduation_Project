function [thresholdsB, thresholdsA,X]=surrogados_PDC(EEG_data,freq,vfreq,maxorder,nsur,alpha)


h=waitbar(0,'Please wait... generating AAFT...'); drawnow;
X=zeros([size(EEG_data,1),size(EEG_data,1),numel(vfreq),nsur]);
for nb=1:nsur
    Y=zeros(size(EEG_data));
    for c=1:size(EEG_data,1)
        for n=1:size(EEG_data,3)
            Y(c,:,n) = generate_AAFT(squeeze(EEG_data(c,:,n))');
        end
    end
    if nb==1
        [PDCX] = automatedPDC(Y, freq,vfreq,maxorder);
        order=PDCX.Order;
    else
        [PDCX] = automatedPDC(Y, freq,vfreq,maxorder,order);
    end
    for k=1:numel(vfreq)
        X(:,:,k,nb)=PDCX.PDC(:,:,k)-diag(diag(squeeze(PDCX.PDC(:,:,k))));
    end
    waitbar(nb/100,h);drawnow;
end
delete(h)
thresholdsA=zeros(size(X,1),size(X,2),numel(vfreq));
thresholdsB=zeros(size(X,1),size(X,2),numel(vfreq));
for c=1:size(X,1)
    for cc=1:size(X,2)
        for k=1:size(X,3)
            y=sort(squeeze(X(c,cc,k,:)));
            thresholdsB(c,cc,k)=max(y);
            thresholdsA(c,cc,k)=y(round((1-alpha)*numel(y)));
        end
    end
end

function Xs = generate_AAFT(X);

if (nargin<1)
	X = [];
end

[s1 s2] = size(X);


% Standardise time series
T1 = (X-mean(X))./std(X);

% Match signal distribution to Gaussian
[Xsorted IND1] = sort(X);
G = sort(randn(s1,s2));
T1s = T1;
T1s(IND1) = G;

% Phase randomise
T2 = real(ifft(abs(fft(T1s)).*exp(sqrt(-1).*angle(fft(randn(s1,s2))))));

% Restore original signal distribution
[DUM IND2] = sort(T2);
Xs = X;
Xs(IND2) = Xsorted;
