%% Automated PDC Calculation
% This script calculates PDC averaged in frequency bands given EEG_data

%%% inputs:
% EEG_data : channels x samples x trials
% fa: sampling frequency 
% freq: frequency vector
% maxOrderCalc:  maximum VAR model order 
% order: VAR model order

%%% usage: 
%1) Calculating Akaike and Bayesian information criteria and use min order bewteen AIC an BIC 
%[Results] = automatedPDC(EEG_data, fa,freq,maxOrderCalc)
%
%2) Skipping Akaike and Bayesian information criteria and applying a fixed
%order:
%[Results] = automatedPDC(EEG_data, fa,freq,maxOrderCalc,order)


%%% outputs:
% Results.PDC: avg |PDC|^2 (chan x chan x frequency band)
% Results.Oder: VAR model order
% Results.AR: Var model coefficients (chan to x chan from x order);
% Results.SU: residuals covariance (chan to x chan from x order);

function [Results] = automatedPDC(EEG_data, fa, freq,maxOrderCalc,order)
    
    
    if nargin<4
        maxOrderCalc=20;
    end
    Results=struct('Order',[],'Ar',[],'PDC',[],'SU',[]);
   
    if nargin<5
        [~,~,moAIC,moBIC] = tsdata_to_infocrit(EEG_data, maxOrderCalc,'LWR',true);
        fprintf('\nbest model order (AIC) = %d\n',moAIC);
        fprintf('best model order (BIC) = %d\n',moBIC);
        Results.Order=max([moAIC,moBIC]); %max (subestimar a ordem é pior) 
    else
        Results.Order=order;
    end

    [Chans] = size(EEG_data,1);
    
    [Results.Ar,Results.SU] = tsdata_to_var(EEG_data,Results.Order);
    assert(~isbad(Results.Ar),'VAR estimation failed');
    rho=  var_specrad(Results.Ar);
    if rho>1
        warning('Specrad > 1: unstable VAR model!!');
    end

    Results.PDC=zeros(Chans,Chans,numel(freq));    
    [Results.PDC] = abs(getPDC_AGC(Results.Ar, freq, fa,Results.SU)).^2;

end

