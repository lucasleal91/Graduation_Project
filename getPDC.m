% 3)    Apply PDC
% DONE

%% Calculate PDC
% REFERENCE: eMVAR toolkit

%%% inputs: 
% A=[A(1)...A(p)]: M*pM matrix of the MVAR model coefficients (strictly causal model)
% p= maximum order of MVAR model
% f= number of points for calculation of the spectral functions (nfft)
% Fs= sampling frequency
% m= number of EEG channels

%%% outputs:
% PDC= Partial Directed Coherence (Eq. 15 but with sigma_i=sigma_j for each i,j)

function [PDC, Af, Af_] = getPDC(A, p, N, Fs, m)

    % Is there a way to do this more matlab-ish? (Removing for)
    %Af = zeros(m);
    Af = [eye(m) -A];
    As = zeros(m,m);
    
    if all(size(N)==1),	 %if N is scalar
        f = (0:N-1)*(Fs/(2*N)); % frequency axis
    else            % if N is a vector, we assume that it is the vector of the frequencies
        f = N; N = length(N);
    end;

    %s = exp(i*2*pi*f/Fs); % vector of complex exponentials
    z = 1i*2*pi/Fs;
    
    %% computation of spectral functions
    for n=1:N, % at each frequency

        % First two for loop build A(f) elements
        %for a=1:m
            %for b=1:m
                % This third for loop calculates summation
                % SUM(A(r)*e^(-i*2*pi*f*r)) for r=1:p
                for r=1:p+1
                    % Af(a,b) = Af(a,b) + (A(:,r)*exp(-1i*2*pi*f/Fs*(r-1)));
                    As = As + Af(:,r*m+(1-m:0))*exp(-z*f(n)*(r-1));
                end

                %   if a == b
                %      Af(a,b) = 1 - Af(a,b);
                % else
                %    Af(a,b) = - Af(a,b);
                %end
            % end
        %end
  
        % This step ensures ?(f)=1-SUM(A(r)*e^(-i*2*pi*f*r)) if i=j or
        % ?(f)=SUM(A(r)*e^(-i*2*pi*f*r)) otherwise
        I = eye(m,m);
        Af_ = I - As;
    
        % How to do this in a more Matlab approach? (Removing for...)
        % PDC = zeros(m,m);
        denom = zeros(m,m);
        for a=1:m
            for b=1:m
        %     PDC(a,b) = Af(a,b)./sqrt((Af(b)')*Af(b));
                denom(a,b) = sqrt(As(:,b)'*As(:,b));
            end
        end
 
        PDC(:,:,n) = As./denom;
    end

end