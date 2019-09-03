function [local_efficiency, global_efficiency] = calc_efficiency(AdjMatrix)
    [Channels,~,Bands,Thresholds] = size(AdjMatrix);
    
    local_efficiency = zeros(1,Channels,Bands,Thresholds);
    global_efficiency = zeros(Bands,Thresholds);

    for i = 1:Bands
        for j = 1:Thresholds
            AdjMatrix_sqz = squeeze(AdjMatrix(:,:,i,j));
            local_efficiency(1,:,i,j) = efficiency(AdjMatrix_sqz,1)';
            global_efficiency(i,j) = efficiency(AdjMatrix_sqz);
        end
    end
end