
function [thresholdsB,thresholdsA,X]=surrogados_PDC_zeraAr(Ar,Su,N,T,freq,vetorfrequencias,order,nsur,alpha)
% Ar=Results.Ar;
% Su=Results.SU;
% N=145;%numero de amostras
% T=10;%numero de trials

M=size(Ar,1);
p=size(Ar,3);
thresholdsA=zeros(M,M,numel(vetorfrequencias));
thresholdsB=zeros(size(thresholdsA));
X=zeros([size(thresholdsA),nsur]);
h=waitbar(0,'Constructing PDC surrogates...');
for nb=1:nsur
    fprintf('SUR %i \n',nb)    
    U=zeros(M,N,T);
    for t=1:T
        % generate gaussian innovations with covariance Su:
        [L,Sw]=choldiag(Su);
        W = randn(M,N); % W independent and gaussian
        for m=1:M % This normalizes W to have the appropriate variance (and zero mean)
            W(m,:)=sqrt(Sw(m,m))*(W(m,:)-mean(W(m,:)))/std(W(m,:));
        end
        U(:,:,t)=L*W;
    end
    for ii=1:M
        for jj=1:M
            if ii~=jj
                fprintf('%i x %i ...',ii,jj)
                As=Ar;
                As(ii,jj,:)=0;
                r = var_specrad(As);
                if r>1
                    As = var_decay(As,0.999/r);
                end
                Y=zeros(M,N,T);
                %generate Signal:
                for t=1:T
                for n=1:N
                    for k=1:p
                        if n-k<=0, break; end; % if n<=p, stop when k>=n
                        Y(:,n,t)=Y(:,n,t) + ( squeeze(As(:,:,k)) * Y(:,n-k,t) );            
                    end
                    Y(:,n,t)=Y(:,n,t)+U(:,n,t);
                end
                end
                [SURR] = automatedPDC(Y, freq,vetorfrequencias,30,order);
                for k=1:size(SURR.PDC,3)
                    X(ii,jj,k,nb)=SURR.PDC(ii,jj,k);
                end
            end
        end
        fprintf('\n')
    end
   waitbar(nb/nsur,h);drawnow;
end
delete(h);
            
for ii=1:M
    for jj=1:M
        if ii~=jj
            for k=1:size(X,3)
                y=sort(squeeze(X(ii,jj,k,:)));
                thresholdsB(ii,jj,k)=max(y);
                thresholdsA(ii,jj,k)=y(round((1-alpha)*numel(y)));
            end
        end
    end
end
    

