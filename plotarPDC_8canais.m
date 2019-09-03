

function []=plotarPDC_8canais(name,PDC,vetorfrequencias,Channels,cor)

    if nargin<5
        cor='b';
    end
    
    figure('Color','w','Name',['PDCs ',name]);
    hold on
    for i=1:size(PDC,1) 
        for j=1:size(PDC,1) 
            subplot(8,8,8*(i-1)+j)           
            fill(vetorfrequencias([1,1:numel(vetorfrequencias),numel(vetorfrequencias)]),[0;squeeze(PDC(i,j,:));0],cor)
            ylim([0 1])
            xlim([min(vetorfrequencias) max(vetorfrequencias)])
            if i==8
                xlabel(['From: ',Channels{j}])
            end
            if j==1
                ylabel(['To: ',Channels{i}])
            end
        end        
    end
end




