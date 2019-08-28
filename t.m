freq = 1450; % Sampling Frequency

in_file_name1 = 'Martino_keta_wake.mat';
in_file_name2 = 'Martino_keta_ane.mat';

[MartinoWake_PDC, MartinoWake_AdjMatrix, ~, MartinoWake_Dist, MartinoWake_TotalDegree, MartinoWake_InDegree, MartinoWake_OutDegree, MartinoWake_InDegreeProbDist, MartinoWake_InBins, MartinoWake_OutDegreeProbDist, MartinoWake_OutBins, MartinoWake_LoEff, MartinoWake_GlEff, MartinoWake_Triang, MartinoWake_ClustCoeff, MartinoWake_NetClustCoeff, MartinoWake_AssortCoeff, MartinoWake_AvgNeighDeg] = automatedPDC(in_file_name1,freq);
[MartinoAne_PDC, MartinoAne_AdjMatrix, ~, MartinoAne_Dist, MartinoAne_TotalDegree, MartinoAne_InDegree, MartinoAne_OutDegree, MartinoAne_InDegreeProbDist, MartinoAne_InBins, MartinoAne_OutDegreeProbDist, MartinoAne_OutBins, MartinoAne_LoEff, MartinoAne_GlEff, MartinoAne_Triang, MartinoAne_ClustCoeff, MartinoAne_NetClustCoeff, MartinoAne_AssortCoeff, MartinoAne_AvgNeighDeg] = automatedPDC(in_file_name2,freq);

m = 3;
n = 3;

band_names = {'Delta (0.5-3 Hz)','Alpha (8-12 Hz)','Beta 1 (12-20 Hz)','Beta 2 (21-30 Hz)','Gamma (30-45 Hz)'};
thresh_val = {'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9'};
bands=5;

for i=1:bands
    fig_name = [in_file_name1, ' - ', band_names{i}];
    figure('Name',fig_name,'NumberTitle','off');
    for j=1:m*n
        subplot(m,n,j);
%        histogram(squeeze(dist_total(:,:,1,(i*(j-1))+i)));
        histogram(squeeze(MartinoWake_Dist(:,:,i,j)));
        title(thresh_val{j});
    end
    save_figname = [fig_name, '-shortest_path.png'];
    saveas(gcf, save_figname);
end

for i=1:bands
    fig_name = [in_file_name2, ' - ', band_names{i}];
    figure('Name',fig_name,'NumberTitle','off');
    for j=1:m*n
        subplot(m,n,j);
%        histogram(squeeze(dist_total(:,:,1,(i*(j-1))+i)));
        histogram(squeeze(MartinoAne_Dist(:,:,i,j)));
        title(['Threshold ',thresh_val{j}]);
    end
    save_figname = [fig_name, '-shortest_path.png'];
    saveas(gcf, save_figname);
end

%% PDC
% for i=1:bands
%     fig_name = [in_file_name2, ' - ', band_names{i}];
%     figure('Name',fig_name,'NumberTitle','off');
%     imagesc(MartinoAne_PDC(:,:,i)); colorbar
%     title(['PDC ', band_names{i}]);
%     save_figname = [fig_name, '-PDC.png'];
%     saveas(gcf, save_figname);
% end
% 
% for i=1:bands
%     fig_name = [in_file_name1, ' - ', band_names{i}];
%     figure('Name',fig_name,'NumberTitle','off');
%     imagesc(MartinoWake_PDC(:,:,i)); colorbar
%     title(['PDC ', band_names{i}]);
%     save_figname = [fig_name, '-PDC.png'];
%     saveas(gcf, save_figname);
% end

%% Global Efficiency
% title('Global Efficiency');
% fig_name = 'Martino Ane and Wake Global Efficiency';
% figure('Name',fig_name,'NumberTitle','off');
% for i=1:bands
%     hold on;
%     plot(MartinoAne_GlEff(i,:));
%     plot(MartinoWake_GlEff(i,:));
%     save_figname = [fig_name, '.png'];
%     saveas(gcf, save_figname);
%     legend('Ane Delta', 'Wake Delta', 'Ane Alpha', 'Wake Alpha', 'Ane Beta 1', 'Wake Beta 1', 'Ane Beta 2', 'Wake Beta 2', 'Ane Gamma', 'Wake Gamma', 'Location', 'Southeast');
% end
