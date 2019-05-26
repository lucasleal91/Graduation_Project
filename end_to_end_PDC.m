function pdc_final = end_to_end_PDC (file_name, freq)
    
    % First step: reformat data to BSMART input
    [out_data, ~] = reformat(file_name, freq);
    
    
    % Second step: estimate order parameter by applying AIC - BSMART
    
    % Compiling opssaic before calling aic_test
    
%    while isempty(winlen)
%        winlen = input('Please, enter window length to run AIC: ', 's');
%    end
    
%    while isempty(maxorder)
%        maxorder = input('Please, enter maximum order to evaluate AIC: ', 's');
%    end
    
%    AIC = aic_test(out_data, winlen, maxorder);
    
%    chosen_AIC = [];
%    while isempty(chosen_AIC)
%        chosen_AIC = input('Please, enter model order selected from running AIC model: ', 's');
%    end
    
    chosen_AIC = 10;

    [F,C,~] = size(out_data);

    % Defining window length, starting and ending position now. User
    % interaction will be needed for this...
    startp = 1;
    endp = F - F/25; 
    window = F/25;
    
    % Calculate MVAR coeficients using BSMART multivariate moving window
    [A,~] = mov_mul_model(out_data, chosen_AIC, startp, endp, window);
    AIC_file_name = strcat(file_name, '_AIC.mat');
    save(AIC_file_name, 'A');
    
    pdc_final = getPDC(A, chosen_AIC, F, C);
    PDC_file_name = strcat(file_name, '_PDC.mat');
    save(PDC_file_name, 'pdc_final');
    
    PDC_real = real(pdc_final);
    imagesc(PDC_real);
    colorbar;
end