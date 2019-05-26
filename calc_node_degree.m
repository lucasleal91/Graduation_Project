function [total_degree, in_degree, out_degree] = calc_node_degree(Adjacency_Matrix)
    [Ch, ~, totalBands, totalDensities] = size(Adjacency_Matrix);
    
    in_degree = zeros(1, Ch, totalBands, totalDensities);
    out_degree = zeros(1, Ch, totalBands, totalDensities);
    total_degree = zeros(1, Ch, totalBands, totalDensities);
    
    for i=1:totalBands
        for j=1:totalDensities
            in_degree(1,:,i,j) = sum(Adjacency_Matrix(:,:,i,j));
            out_degree(1,:,i,j) = sum(Adjacency_Matrix(:,:,i,j),2)';
            total_degree(1,:,i,j) = in_degree(1,:,i,j) + out_degree(1,:,i,j);
        end
    end
end