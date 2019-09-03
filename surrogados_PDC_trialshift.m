function [thresholdsB,thresholdsA,X]=surrogados_PDC_trialshift(EEG_data,freq,vetorfrequencias,order,nsur,alpha)


    h=waitbar(0,'Shifting trials...');
    thresholdsA=zeros(size(EEG_data,1),size(EEG_data,1),numel(vetorfrequencias));
    thresholdsB=zeros(size(thresholdsA));
    X=zeros([size(thresholdsA),nsur]);
    Y=zeros(size(EEG_data));
    for nb=1:nsur
        trials=randperm(size(EEG_data,3))';
        for c=1:size(Y,1)
            Y(c,:,:)=EEG_data(c,:,circshift(trials,c));
        end
        [SURR] = automatedPDC(Y, freq,vetorfrequencias,30,order);
        for k=1:size(SURR.PDC,3)
            X(:,:,k,nb)=SURR.PDC(:,:,k)-diag(diag(squeeze(SURR.PDC(:,:,k))));
        end
        waitbar(nb/nsur,h);drawnow;
    end
    delete(h);
    clear SURR Y trials nboot
    for c=1:size(X,1)
        for cc=1:size(X,2)
            for k=1:size(X,3)
                y=sort(squeeze(X(c,cc,k,:)));
                thresholdsB(c,cc,k)=max(y);
                thresholdsA(c,cc,k)=y(round((1-alpha)*numel(y)));
            end
        end
    end
    
    
    