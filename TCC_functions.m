% Etapas do processo:
% 1)    Ingestão dos dados
% 1.1)  Reformatar dados (se necessário), para o formato CxFxTr (Canais,
% Frequêcia e Trechos, respectivamente)
% 1.2)  Se utlizar funções do BSMART para obtenção do MVAR, fazer
% permutação de CxFxTr para FxCxTr
% DONE

% function out_data = reformat(in_data, freq)
 function [out_data, final_name] = reformat(file_name, freq)
 % reformat Reformatter for EEG data processing with BSMART
%
% Usage:
%   reformat(file_name, freq);
% 
%   file_name: input file in matlab format;
%   freq: frequency of acquired data (number of time points)
% 
% Output:  
%   out_data is the data in the format used by BSMAT tools
%   final_name is the data path on system

    in_file = load(file_name);
    in_data = in_file.dataref;
    
    pos = strfind(file_name, '.mat');
    ref_file_name =  strcat(file_name(1:pos-1), '_ref_');
    
    out_data = in_data;

    % C represets total number of EEG channels, F is frequency, 
    % and Tr is number of trails
    [C,F,Tr] = size(in_data);
    
    % Evaluates if data is presented in one single trail
    if Tr == 1 && freq ~= F
        % Reshapes data to (channels x time x trials) and permute it to be
        % (time x channels x trials)
        reshapped_data = permute(reshape(in_data, C, freq, F/freq), [2 1 3]);
        
%        for i=1:F/freq
%            out_data = reshapped_data(1:4:end, [4 6 15 17 19 21 23 25 27 29 31 33 47 49 51 57 59], i);
%            final_name = strcat(ref_file_name, 'sample_trial', int2str(i), '.mat');
%            save(final_name, 'out_data');
%        end

        out_data = reshapped_data(1:4:end, [4 6 15 17 19 21 23 25 27 29 31 33 47 49 51 57 59], :);
        final_name = strcat(ref_file_name, 'sample_all_trials.mat');
        save(final_name, 'out_data');
    end
end


% 2)    Aplicar AIC para definir ordem máxima do modelo MVAR (Multivariate 
% Auto Regressive)
% TODO - use BSMART aic_test() function (C code may need to be recompiled)



% 2.1)  Gerar MVAR usando Moving Time Window
% TODO - use BSMART mov_mul_model() function



% 3)    Aplicar PDC
% DONE

function PDC = getPDC(A, p, f, m)
    
    % Is there a way to do this more matlab-ish? (Removing for)
    A_f = zeros(m);
    for a=1:m
        for b=1:m
            for r=1:p
                A_f(a,b) = A_f(a,b) + (A(r)*exp(-i*2*pi*f*r));
            end
        end
    end

    %I = eye(size(A));
    I = eye(m,m);
    Ab = I - A_f;
    
    % How to do this in a more Matlab approach? (Removing for...)
    PDC = zeros(m,m);
    for a=1:m
        for b=1:m
            PDC(a,b) = Ab(a,b) / sqrt(ctranspose(Ab(b))*Ab(b));
        end
    end
end

% 4)    Aplicar threshold
% TODO



% 5)    Extrair métricas em grafos
%TODO