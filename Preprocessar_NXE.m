%data = chs x samples x trials (from nxe file, at 1450Hz).
%samples = times in s
%channels = cell with channels names
%badtrials =  bad trials (vec)
%badchannels = bad channels (vec)
%subnet = [];   otherwise: chs x 2 with numbers of reduced net
                %example: subnet=[2,5;9,8;11,12;28,27;30,31;48,47;50,51;58,60];

function[EEG_data,channels,channelsnum,freq,maxorder]=Preprocessar_NXE(data,channels,badtrials,badchannels,subnet,filtrar_downsampling)


data(:,:,badtrials)=[]; 
selchns=1:1:size(data,1);
selchns(badchannels)=[];
maxorder=15;
if ~isempty(subnet)
    selchns=subnet(:,1);%primeira opcao
    a=intersect(selchns,badchannels); %rejeitado?
    if ~isempty(a)
        for j=1:numel(a)
            jj=find(subnet(:,1)==a(j));
            selchns(jj)=subnet(jj,2);%substitui canal pela segunda opcao              
        end
    end
    a=intersect(selchns,badchannels); 
    if ~isempty(a)
        error('Canais da subnet rejeitados!')
    end
    maxorder=60; %ordem precisa ser bem alta nesse caso
end

data=data(selchns,:,1:10); %select 10 trials
channels=channels(selchns);
channelsnum=selchns; 
freq=1450;
EEG_data=data;

if filtrar_downsampling %zero-phase(filtfilt)
%     [B1,A1]=butter(3,2*0.5/freq,'high');
    [B2,A2]=butter(3,2*45/freq,'low');
    h=waitbar(0,'Filtering...');
    for i=1:size(data,1)
        for j=1:size(data,3)
            EEG_data(i,:,j)=filtfilt(B2,A2,data(i,:,j));
            EEG_data(i,:,j)=EEG_data(i,:,j)-mean(EEG_data(i,:,j));
%             EEG_data(i,:,j)=filtfilt(B1,A1,EEG_data(i,:,j));
        end
        waitbar(i/size(data,1),h);drawnow;
    end
    delete(h);drawnow

    %% downsampling:1 in 10
    EEG_data=EEG_data(:,1:10:size(EEG_data,2),:);%filtered and downsampled
    freq=freq/10;
end
