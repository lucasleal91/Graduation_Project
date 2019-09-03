function [Clustering_coeff, Net_Clustering_Coeff] = calc_clustering_coefficient(AdjMatrix)
    [M,~] = size(AdjMatrix);
    Clustering_coeff = zeros(1,M);
    
    [~, in_degree, out_degree] = calc_node_degree(AdjMatrix);
    [triangles] = calc_triangles(AdjMatrix);
    
    for i=1:M
        tmp1 = in_degree(i) + out_degree(i);
        tmp2 = out_degree(i) + in_degree(i) - 1;
        tmp3 = 0;
        for j=1:M
            tmp3 = tmp3 + (AdjMatrix(i,j)*AdjMatrix(j,i));
        end
        denom = (tmp1 * tmp2) - (2 * tmp3);
        Clustering_coeff(i) = (triangles(i)/denom);
    end
    Net_Clustering_Coeff = (1/M)*sum(Clustering_coeff);
end