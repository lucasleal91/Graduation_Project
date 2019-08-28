%% Model Order Selection for identification strictly causal MVAR model

%%% input:
% Y, M*N matrix of time series (each time series is in a row)
% pmax, maximum tested model order

%%% output:
% pottaic: model order optimized with multichannel Akaike Information Criterion (AIC)
% aic: values of AIC index as a function of the model order

function [pottaic,aic] = OrderEstimationMVAR(Y,pmax)

    N=size(Y,2);
    M=size(Y,1); %dimension of serie

    % figures of merit
    aic = NaN*ones(pmax,1);

    for p=1:pmax
        [~,S,~] = estimateMVAR(Y,p);

        %formula for multivariate AIC 
        aic(p)=N*log(det(S(:,:,p)))+2*M*M*p; % S covariance matrix
    end
    
    pottaic=find(aic == min(aic));
end