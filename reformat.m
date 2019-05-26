%% Automated PDC Calculation
% This script reformats input data to Channels X Frequency X Trials

%%% inputs:
% file_name: EEG data file name
% freq: frequency used to sample EEG

%%% outputs:
% out_data: input data reformatted to Channels X Frequency X Trials
% final_name: final name for reformatted data
% trials: number of trials of input data

% function out_data = reformat(in_data, freq)
 function [out_data, final_name, trials] = reformat(file_name, freq)
    
    % Number of points in each trial 
    points_in_trial = 10;
    
    in_file = load(file_name);
    in_data = in_file.dataref;
    
    pos = strfind(file_name, '.mat');
    ref_file_name =  strcat(file_name(1:pos-1), '_ref_');
    
    % C represets total number of EEG channels, F is frequency, 
    % and Tr is number of trails
    [C,dT,Tr] = size(in_data);
    
    % Evaluates if data is presented in one single trail
    if Tr == 1 && freq < dT/points_in_trial
        % Reshapes data to (channels x time x trials) and permute it to be
        % (time x channels x trials)
        calc_trials = dT/(freq * points_in_trial);
        time_points = freq * points_in_trial;
        reshapped_data = permute(reshape(in_data, C, time_points, calc_trials), [2 1 3]);
        
%        for i=1:F/freq
%            out_data = reshapped_data(1:4:end, [4 6 15 17 19 21 23 25 27 29 31 33 47 49 51 57 59], i);
%            final_name = strcat(ref_file_name, 'sample_trial', int2str(i), '.mat');
%            save(final_name, 'out_data');
%        end

%        out_data = reshapped_data(1:4:end, [4 6 15 17 19 21 23 25 27 29 31 33 47 49 51 57 59], :);
%        final_name = strcat(ref_file_name, 'sample_all_trials.mat');
%        save(final_name, 'out_data');
        
        out_data = reshapped_data;
        trials = calc_trials;
        final_name = strcat(ref_file_name, 'sample_all_trials.mat');
        save(final_name, 'out_data');
    else
    
%    out_data = reshapped_data(1:4:end, [4 6 15 17 19 21 23 25 27 29 31 33 47 49 51 57 59], :);
%    final_name = strcat(ref_file_name, 'sample_all_trials.mat');
%    save(final_name, 'out_data');

        reshapped_data = permute(in_data, [2 1 3]);

        out_data = reshapped_data;
        trials = Tr;
        final_name = strcat(ref_file_name, 'sample_all_trials.mat');
        save(final_name, 'out_data');
    end;
end