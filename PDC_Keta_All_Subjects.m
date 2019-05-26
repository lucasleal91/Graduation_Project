%[PDC_Stephanos_keta_Wake_Gamma, AdjMatrix_Stephanos_keta_Wake_Gamma, Thresh_Stephanos_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Stephanos_keta_wake.mat', 14500, [40:50]);
%[PDC_Sophie_keta_Wake_Gamma, AdjMatrix_Sophie_keta_Wake_Gamma, Thresh_Sophie_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Sophie_keta_wake.mat', 14500, [40:50]);
%[PDC_Melanie_keta_Wake_Gamma, AdjMatrix_Melanie_keta_Wake_Gamma, Thresh_Melanie_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Melanie_keta_wake.mat', 14500, [40:50]);
%[PDC_Martino_keta_Wake_Gamma, AdjMatrix_Martino_keta_Wake_Gamma, Thresh_Martino_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Martino_keta_wake.mat', 14500, [40:50]);
%[PDC_Marielle_keta_Wake_Gamma, AdjMatrix_Marielle_keta_Wake_Gamma, Thresh_Marielle_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Marielle_keta_wake.mat', 14500, [40:50]);
%[PDC_Julie_keta_Wake_Gamma, AdjMatrix_Julie_keta_Wake_Gamma, Thresh_Julie_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Julie_keta_wake.mat', 14500, [40:50]);

%a=sum(sum(AdjMatrix_Stephanos_keta_Wake_Gamma))/3600;
%b=sum(sum(AdjMatrix_Sophie_keta_Wake_Gamma))/3600;
%c=sum(sum(AdjMatrix_Melanie_keta_Wake_Gamma))/3600;
%d=sum(sum(AdjMatrix_Martino_keta_Wake_Gamma))/3600;
%e=sum(sum(AdjMatrix_Marielle_keta_Wake_Gamma))/3600;
%f=sum(sum(AdjMatrix_Julie_keta_Wake_Gamma))/3600;

function g = PDC_Keta_All_Subjects
    g=1;
    [PDC_Stephanos_keta_Wake_Gamma, ~, ~] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Stephanos_keta_wake.mat', 14500, [40:50]);
    [PDC_Sophie_keta_Wake_Gamma, ~, ~] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Sophie_keta_wake.mat', 14500, [40:50]);
    [PDC_Melanie_keta_Wake_Gamma, AdjMatrix_Melanie_keta_Wake_Gamma, Thresh_Melanie_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Melanie_keta_wake.mat', 14500, [40:50]);
    [PDC_Martino_keta_Wake_Gamma, AdjMatrix_Martino_keta_Wake_Gamma, Thresh_Martino_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Martino_keta_wake.mat', 14500, [40:50]);
    [PDC_Marielle_keta_Wake_Gamma, AdjMatrix_Marielle_keta_Wake_Gamma, Thresh_Marielle_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Marielle_keta_wake.mat', 14500, [40:50]);
    [PDC_Julie_keta_Wake_Gamma, AdjMatrix_Julie_keta_Wake_Gamma, Thresh_Julie_keta_Wake_Gamma] = automatedPDC('/Users/lucasleal/Documents/TCC_Codigo/SpontaneousEEG/Julie_keta_wake.mat', 14500, [40:50]);
    
    [a2,b2,agv2,std2]=all(PDC_Stephanos_keta_Wake_Gamma);
    [a3,b3,agv3,std3]=all(PDC_Sophie_keta_Wake_Gamma);
    [a4,b4,agv4,std4]=all(PDC_Melanie_keta_Wake_Gamma);
    [a5,b5,agv5,std5]=all(PDC_Martino_keta_Wake_Gamma);
    [a6,b6,agv6,std6]=all(PDC_Marielle_keta_Wake_Gamma);
    [a7,b7,agv7,std7]=all(PDC_Julie_keta_Wake_Gamma);
    
    plot(a2,b2,'b',a3,b3,'r',a4,b4,'y',a5,b5,'v',a6,b6,'c',a7,b7,'g');
    %plot(a2,b2,'b');
end

function [x1,y1,avg1,std1] = all(indata)
    avg1=mean(mean(indata));
    std1=std(std(indata));
    y1=normpdf(sort(indata(1:3600)),avg1,std1);
    x1=sort(indata(1:3600));
end


