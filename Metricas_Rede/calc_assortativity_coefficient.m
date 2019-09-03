function [Assortativity_coeff, temp1, temp2, temp3, temp4] = calc_assortativity_coefficient(AdjMatrix)
    [M,~] = size(AdjMatrix);
    
    l = 1/AdjMatrix(AdjMatrix~=0);
    [~, in_degree, out_degree] = calc_node_degree(AdjMatrix);
    temp1 = 0;
    temp2 = 0;
    temp3 = 0;
    temp4 = 0;
    
    for i=1:M
        for j=1:M
            if j~=i
                if AdjMatrix(i,j)
                    temp1 = temp3 + (out_degree(i)*in_degree(j));
                    temp2 = temp4 + ((1/2) * (out_degree(i)+in_degree(j)));
                    temp3 = temp1 + ((1/2) * (out_degree(i)^2 + in_degree(j)^2));
                    temp4 = temp2 + ((1/2) * (out_degree(i) + in_degree(j)));                end
            end
        end
    end
    num = (l*temp1) - (l*temp2).^2;
    den = (l*temp3) - (l*temp4).^2;
    
    Assortativity_coeff = num/den;
end