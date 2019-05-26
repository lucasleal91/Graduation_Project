%% IDENTIFICATION OF STRICTLY CAUSAL MVAR MODEL: Y(n)=A(1)Y(n-1)+...+A(p)Y(n-p)+U(n)
% makes use of autocovariance method (vector least squares)

%%% input:
% Y, M*N matrix of time series (each time series is in a row)
% p, model order

%%% output:
% Am=[A(1)...A(p)], M*pM matrix of the estimated MVAR model coefficients
% S, estimated M*M input covariance matrix
% Yp, estimated time series
% Up, estimated residuals

function [Am, S, Yp, Up] = estimateMVAR(Y, p)

    [M,N]=size(Y);

    %% IDENTIFICATION
    Z = NaN*ones(p*M,N-p); % observation matrix
    for j=1:p
        for i=1:M
            Z((j-1)*M+i,1:N-p)=Y(i, p+1-j:N-j);
        end
    end

    Yb = NaN*ones(M,N-p); % Ybar
    for i=1:M
        Yb(i,1:N-p)=Y(i,p+1:N);
    end
    Am = Yb/Z; % least squares!

    Yp = Am*Z;
    Yp = [NaN*ones(M,p) Yp]; % Vector of predicted data

    Up = Y-Yp; Up = Up(:,p+1:N); % residuals of strictly causal model
    S = cov(Up');
