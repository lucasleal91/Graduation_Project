%% Automated PDC Calculation
% This script calculates PDC given an EEG file and it frequency

%%% inputs:
% file_name: EEG data
% freq: frequency used to sample EEG

%%% outputs:
% PDC_real: adjacency matrix for calculated PDC
% ConnectivityMap: image that shows how channels are connected according to
% AdjacencyMatrix: adjacency matrix calculated using PDC connectivity
% matrix

%function [finalPDC, finalPDC2] = automatedPDC(file_name, freq, freqBand)
%function [finalPDC, AdjacencyMatrix, FinalThreshold] = automatedPDC(file_name, freq, freqBand)
function [finalPDC, AdjacencyMatrix, FinalThreshold] = automatedPDC(file_name, freq)
    
    % First step: reformat data to BSMART input
    [out_data, ~, trials] = reformat(file_name, freq);
    
    delta_band = 0.5:0.1:3;
    alpha_band = 8:1:12;
    beta1_band = 12:1:20;
    beta2_band = 21:1:30;
    gamma_band = 30:1:45;
    Bands = 5;
    EEG_Channels = 60;
    trial_size = 10;
    
    finalTrialPDC=zeros(EEG_Channels,EEG_Channels,trials,Bands);
%    finalPDC=zeros(60,60);
    
%    orderData=permute(reshape(out_data, [EEG_Channels, freq*trials*trial_size]), [2 1]); 
    orderData = permute(out_data, [2 1 3]);
    
    % Second step: estimate order parameter by applying AIC - eMVAR
    maxOrderCalc = 20;
%    [potaic, aic] = OrderEstimationMVAR(orderData, maxOrderCalc);
%    modelOrder = potaic(1);
%    modelOrder = 2;
    [aic_mvgc,~,moaic_mvgc,~] = tsdata_to_infocrit(orderData, maxOrderCalc);
    modelOrder = moaic_mvgc;
    
    %% calculating PDC for each data trial
    for n=1:trials
        inData = permute(out_data(:,:,n), [2 1]);
        
%        [potaic, aic] = OrderEstimationMVAR(inData, maxOrderCalc);
%        modelOrder = potaic(1);
        
        % Trhid step: estimate MVAR coeficients
        [Am, Su, ~, ~] = estimateMVAR(inData, modelOrder);

        % Fourth step: calculate PDC for a given frequency band
%        fBand = freqBand; %[40:59] -- example
        [Chans, ~] = size(inData);

        [deltaPDC, ~, ~] = getPDC(Am, modelOrder, delta_band, freq, Chans);
        [alphaPDC, ~, ~] = getPDC(Am, modelOrder, alpha_band, freq, Chans);
        [beta1PDC, ~, ~] = getPDC(Am, modelOrder, beta1_band, freq, Chans);
        [beta2PDC, ~, ~] = getPDC(Am, modelOrder, beta2_band, freq, Chans);
        [gammaPDC, ~, ~] = getPDC(Am, modelOrder, gamma_band, freq, Chans);
%       [~,~,PDC_2,~,~,~,~,~,~,~,~] = fdMVAR(Am,Su,fBand,sFreq);
%       realPDC_2 = abs(PDC_2).^2;
%       avgPDC_2 = mean(realPDC_2, 3);
%       finalPDC2 = avgPDC_2;

        % Taking absolute value, applying power of 2 and then taking mean of
        % frequency band values
        realDeltaPDC = abs(deltaPDC).^2;
        realAlphaPDC = abs(alphaPDC).^2;
        realBeta1PDC = abs(beta1PDC).^2;
        realBeta2PDC = abs(beta2PDC).^2;
        realGammaPDC = abs(gammaPDC).^2;
 
        avgDeltaPDC = mean(realDeltaPDC, 3);
        avgAlphaPDC = mean(realAlphaPDC, 3);
        avgBeta1PDC = mean(realBeta1PDC, 3);
        avgBeta2PDC = mean(realBeta2PDC, 3);
        avgGammaPDC = mean(realGammaPDC, 3);
        
        finalTrialPDC(:,:,n,1) = avgDeltaPDC;
        finalTrialPDC(:,:,n,2) = avgAlphaPDC;
        finalTrialPDC(:,:,n,3) = avgBeta1PDC;
        finalTrialPDC(:,:,n,4) = avgBeta2PDC;
        finalTrialPDC(:,:,n,5) = avgGammaPDC;
    end;
    
    % Fifth step: calculate mean of all trials. Threshold will first be
    % determined based on trials averaging, then it can be expanded to
    % different subjects (person) averaging
    finalDeltaPDC = mean(squeeze(finalTrialPDC(:,:,:,1)), 3);
    finalAlphaPDC = mean(squeeze(finalTrialPDC(:,:,:,1)), 3);
    finalBeta1PDC = mean(squeeze(finalTrialPDC(:,:,:,1)), 3);
    finalBeta2PDC = mean(squeeze(finalTrialPDC(:,:,:,1)), 3);
    finalGammaPDC = mean(squeeze(finalTrialPDC(:,:,:,1)), 3);
    
    finalPDC(:,:,1) = finalDeltaPDC;
    finalPDC(:,:,2) = finalAlphaPDC;
    finalPDC(:,:,3) = finalBeta1PDC;
    finalPDC(:,:,4) = finalBeta2PDC;
    finalPDC(:,:,5) = finalGammaPDC;

    % Sixth step: take mean of all values as threshold for minimum strength
    % correlation value and create adjacency matrix -> PDC(i,j) >=
    % calculated mean
%    correlationMean = mean(mean(meanFinalPDC));
%    finalPDC = meanFinalPDC;
    density = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 1];
    [~,densities_size]=size(density);
    AdjacencyMatrix=zeros(EEG_Channels,EEG_Channels,Bands,densities_size);
    sortedPDC = zeros(Bands,3600);
    for i=1:Bands
%        sortedPDC = sort(finalDeltaPDC(:), 'descend');
%        DeltaAdjMatrix = finalDeltaPDC >= sortedPDC(3600*density(1));
        temp_PDC = squeeze(finalPDC(:,:,i));
        sortedPDC(i,:) = sort(temp_PDC(:), 'descend');
        for j=1:densities_size
            AdjacencyMatrix(:,:,i,j) = temp_PDC >= sortedPDC(i,3600*density(j));
        end
    
%        AdjacencyMatrix = meanFinalPDC >= correlationMean;
%        AdjacencyMatrix = DeltaAdjMatrix;

%        FinalThreshold = correlationMean;
        FinalThreshold = sortedPDC(3600*density(1));
    end

%       figure; imagesc(meanFinalPDC);
%       colorbar;
    pos = strfind(file_name, '.mat');
    ref_file_name =  file_name(1:pos-1);
    
    % PDC file
    final_name_pdc = strcat(ref_file_name, '_PDC', '.mat');
    save(final_name_pdc, 'finalPDC');
    
    % Adjcency Matrix file
    final_name_adj_mat = strcat(ref_file_name, '_Adjancecy_Matrix', '.mat');
    save(final_name_adj_mat, 'AdjacencyMatrix');
    
    % Threshold value
    final_name_thresh = strcat(ref_file_name, '_Threshold', '.mat');
    save(final_name_thresh, 'FinalThreshold');
    

end

%pResultados - teste de estabilidade:
% ruido branco
% ruido colorido
% pink noise