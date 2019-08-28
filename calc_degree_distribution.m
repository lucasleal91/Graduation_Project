function [in_degree_prob_dist,in_bins,out_degree_prob_dist,out_bins] = calc_degree_distribution (AdjMatrix)
out_degree_prob_dist=0;out_bins=0;
    [Channels,~,Bands,Thresholds] = size(AdjMatrix);

    [~,in_degree, ~] = calc_node_degree(AdjMatrix);
    
%    total_edges = (Channes^2 - Channels)/2;
%    max_in_degree = max(in_degree);
    
%    in_degree_prob_dist = zeros(max_in_degree, Bands, Thresholds);
%    out_degree_prob_dist = zeros(total_edges, Bands, Thresholds);
    in_degree_prob_dist = zeros(1,60,Bands,Thresholds);
    in_bins = zeros(1,60,Bands,Thresholds);
    %in_degree_dist = zeros(Channels);
    for i=1:Bands
        for j=1:Thresholds
            [a,b] = hist(squeeze(in_degree(:,:,i,j)), unique(squeeze(in_degree(:,:,i,j))));
            a_dist = a./Channels;
            %in_degree_dist=zeros(max(b));
            for m=1:size(b,2)
                %in_degree_dist(m) = sum(a_dist(1,m:end));
                in_degree_prob_dist(1,m,i,j) = sum(a_dist(1,m:size(b,2)));
                in_bins(1,m,i,j) = b(m);
            end
            %in_degree_prob_dist(:,:,i,j) = in_degree_dist;

        end
    end
        

end