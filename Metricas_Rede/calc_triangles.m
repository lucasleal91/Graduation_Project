function [triangles] = calc_triangles(AdjMatrix)
    [M,~] = size(AdjMatrix);
    
    triangles = zeros(1,M);
    
    for i=1:M
        for j=1:M
            if j ~= i
                for h=1:M
                    if h~=i && h~=j
                        triangles(1,i) = triangles(i) + ((AdjMatrix(i,j)+AdjMatrix(j,i))*(AdjMatrix(i,h)+AdjMatrix(h,i))*(AdjMatrix(j,h)+AdjMatrix(h,j)));
                    end
                end
            end
        end
    end
    triangles = triangles./2;
end