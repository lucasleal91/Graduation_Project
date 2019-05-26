function [dist] = calc_shortest_path(AdjMatrix)
   
    [Channels,~,Bands,Thresholds] = size(AdjMatrix);
%    AdjMatrix_to_Sparse = zeros(Channels,Channels);
    dist = zeros(Channels,Channels,Bands,Thresholds);
    

    for i=1:Bands
        for j=1:Thresholds
            % Using Matlab function                  
            %AdjMatrix_to_Sparse = sparse(squeeze(AdjMatrix(:,:,i,j)));
            %for m=1:Channels
                %for n=1:Channels
                    %dist(m,n,i,j)=graphshortestpath(AdjMatrix_to_Sparse,m,n);   
                %end
            %end
            g = AdjMatrix(:,:,i,j);
            D = eye(length(squeeze(g)));
            n = 1;
            nPATH = g;          %n-path matrix
            L = (nPATH ~= 0);   %shortest n-path matrix

            while find(L,1);
                D = D + n.*L;
                n = n + 1;
                nPATH = nPATH * g;
                L = (nPATH ~= 0).*(D == 0);
            end
            dist(:,:,i,j) = D;
        end
    end
end