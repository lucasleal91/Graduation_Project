%calculate generalized PDC measure
%Ar = chan x chan x order (VAR model coefficients)
%f = frequency vector (Hz)
%Fs = sampling rate
%SIG = residuals covariance
function [PDC] = getPDC_AGC(Ar, f, Fs,SIG)

p=size(Ar,3);
m=size(Ar,1);
PDC=zeros(m,m,numel(f));
for n=1:numel(f); 
    As = zeros(m,m);
    for r=1:p        
        As = As + squeeze(Ar(:,:,r)).*exp(-1i*2*pi*f(n)*r/Fs);
    end
    As=eye(m)-As;
    for k=1:size(As,2)
       V=(As(:,k)./sqrt(diag(SIG)));
       PDC(:,k,n) = V./sqrt(V'*V);%generalized PDC (better)
%        PDC(:,k,n) = As(:,k)/sqrt(As(:,k)'*As(:,k)); %original PDC
    end
end

