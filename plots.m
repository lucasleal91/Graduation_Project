[total_degree, in_degree, out_degree] = calc_node_degree(MartinoAne_AdjMatrix);

[dist] = calc_shortest_path(MartinoAne_AdjMatrix);

[in_degree_prob_dist,in_bins,out_degree_prob_dist,out_bins] = calc_degree_distribution (MartinoAne_AdjMatrix);

figure;
for i=1:9
    subplot(3,3,i);histogram(squeeze(in_degree(1,:,1,i)));
end

figure;
for i=1:9
    subplot(3,3,i);histogram(squeeze(out_degree(1,:,1,i)));
end

figure;
for i=1:9
    subplot(3,3,i);histogram(squeeze(total_degree(1,:,1,i)));
end

figure;
for i=1:9
    subplot(3,3,i);histogram(squeeze(dist(1,:,1,i)));
end

figure;
for i=1:9
    indexed_in_degree_prob_dist = squeeze(in_degree_prob_dist(1,:,1,i));
    %bins = unique(squeeze(in_bins(1,:,1,i)));
    %subplot(3,3,i);histogram(indexed_in_degree_prob_dist(indexed_in_degree_prob_dist~=0),bins);
    subplot(3,3,i);plot(indexed_in_degree_prob_dist(indexed_in_degree_prob_dist~=0));
end