function [average_neighbor_degree] = calc_ave_neighbor_degree(AdjMatrix)
    [M,~] = size(AdjMatrix);
    
    average_neighbor_degree = zeros(1,M);
    
    [~, in_degree, out_degree] = calc_node_degree(AdjMatrix);
    temp1 = 0;
    temp2 = 0;
    temp3 = 0;
    
    for i=1:M
        temp1 = sum(AdjMatrix(i,:)) + sum(AdjMatrix(:,i));
        temp2 = in_degree(i) + out_degree(i);
        temp3 = 2*temp2;
        average_neighbor_degree(1,i) = (temp1 * temp2) / temp3;
    end
end