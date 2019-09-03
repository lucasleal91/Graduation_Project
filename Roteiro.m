
clear all

%% Parametros:
bandas={[0.5,3], [4,7], [8,12], [13,20],[21,30],[31,45]};%EEG Bands

%% Load data:
filename=fullfile('/home/casali/Documentos/Scripts/Lucas/RawData/raw_data_Ado_Propofol','odille wake_1_TRIALSDATA.mat');
filename=fullfile('/home/casali/Documentos/Scripts/Lucas/RawData/raw_data_Ado_Propofol','odille propofol_17_TRIALSDATA.mat');

[~,name]=fileparts(filename);
load(filename)

%% Preprocessar - formato NXE
filtrar_downsampling=1; %filtrar e reamostrar (1) ou usar dados raw
subnet8=[2,5;9,8;11,12;28,27;30,31;48,47;50,51;58,60]; %usa um subconjunto de canais
% subnet8=[]; %usa todos os canais
[EEG_data,Channels,Channelsnum,freq,maxorder]=Preprocessar_NXE(DataTrials,Channels,BadTrials,BadChannels,subnet8,filtrar_downsampling);
clear BadChannels BadTrials DataTrials Times

%% PDC
vetorfrequencias=min(bandas{1}):0.5:max(bandas{end});
[Results] = automatedPDC(EEG_data(:,:,:), freq,vetorfrequencias,maxorder);

if ~isempty(subnet8)%plot da net reduzida
    plotarPDC_8canais(name,Results.PDC,vetorfrequencias,Channels,'b')
end

%% Surrogados: 
[thresholds]=surrogados_PDC(EEG_data,freq,vetorfrequencias,Results.Order,100,0.01);
PDCsig=Results.PDC;
PDCsig(Results.PDC<=thresholds)=0;
if ~isempty(subnet8)
    plotarPDC_8canais(name,PDCsig,vetorfrequencias,Channels,'r')
end

[thresholds2]=surrogados_PDC_trialshift(EEG_data,freq,vetorfrequencias,Results.Order,100,0.01);
PDCsig2=Results.PDC;
PDCsig2(Results.PDC<=thresholds2)=0;
if ~isempty(subnet8)
    plotarPDC_8canais(name,PDCsig2,vetorfrequencias,Channels,'m')
end

[thresholds3]=surrogados_PDC_zeraAr(Results.Ar,Results.SU,size(EEG_data,2),size(EEG_data,3),freq,vetorfrequencias,Results.Order,10,0.01);
PDCsig3=Results.PDC;
PDCsig3(Results.PDC<=thresholds3)=0;
if ~isempty(subnet8)
    plotarPDC_8canais(name,PDCsig3,vetorfrequencias,Channels,'g')
end






%% Mediar Bandas:
PDCbandas=zeros(size(EEG_data,1),size(EEG_data,1),numel(bandas));
for k=1:numel(bandas)
    a=find(vetorfrequencias>=bandas{k}(1) & vetorfrequencias<=bandas{k}(2));
    PDCbandas(:,:,k)=mean(PDCsig3(:,:,a),3);
end


%% Grafico Conectividade em bandas (sem diagonal):
figure('Color','w','Name',['SIG ',name]);
for k=1:numel(bandas)
    subplot(3,2,k)
    imagesc(PDCbandas(:,:,k)-diag(diag(squeeze(PDCbandas(:,:,k)))));
    set(gca,'YDir','normal')
    title([num2str(min(bandas{k})),' - ',num2str(max(bandas{k})),'Hz'])
    caxis([0 0.3])
end
clear k X

%% Salvar resultados
save([filename(1:end-4),'_PDC.mat'],'name','EEG_data','Channels','Channelsnum','bandas','freq','Results','thresholds', 'thresholds2','thresholds3')





