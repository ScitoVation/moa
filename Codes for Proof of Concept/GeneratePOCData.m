function [X_affy, X_geno, Y_affy, Y_geno] = GeneratePOCData();


%%%%Input = None
%%%%Output = Data used in proof of concept for the paper.
%X_affy=gene expression changes for 978 L1000 landmark genes for Affymetrix
%X_geno=gene expression changes for 978 L1000 landmark genes for Genometry
%Y_affy=gene expression changes for remaining genes for Affymetrix
%Y_geno=gene expression changes for remaining genes for Genometry

load('L1000_Landmark_Probes');
load('Probes_Affy');
load('Probes_Geno');

CellLine={'HepaRG','MCF7', 'A673'};
Chemical={'FENB', 'IMAZ', 'Two4D'};


X_Test1=[];
Y_Test1=[];
X_Test2=[];
Y_Test2=[];

i=1;   %% i=1 forHepaRG
       %% i=2 for MCF7
       %% i=3 for A673
       
for j=1:3
       
        XX1=[];
        XX2=[];
        A=strcat('Data/Affy/', Chemical{j}, '_', CellLine{i}, '_Genometry');
        B=strcat('Data/Affy/', Chemical{j}, '_', CellLine{i}, '_Affy');
        load(A);
        load(B);
        
        Data_Geno=cell2mat(Genometry(2:end, 2:end));
        Probes_Geno=Genometry(2:end,1);
        
        Data_Affy=cell2mat(Affy(:, 2:end));
        Probes_Affy=Affy(:,1);
        Probes_Affy=strrep(Probes_Affy, '_PM','');
        
        [~, ia, ib]=intersect(Probes_Affy, Probes_Geno,'stable');
        Probes_Geno=Probes_Geno(ib);
        Data_Geno=Data_Geno(ib,:);
        Data_Affy=Data_Affy(ia,:);
        
        X1=Data_Affy';
        X2=Data_Geno';
        
        Dose=cell2mat(Genometry(1,2:end));
        UniqueDose=unique(Dose);
        DoseIndex={};
        for kk=1:length(UniqueDose)
            DoseIndex{kk}=find(Dose==UniqueDose(kk));
        end

        for k=1:length(UniqueDose)
            XX1(k,:)=mean(X1([3*k-2 3*k-1 3*k], :));
            XX2(k,:)=mean(X2(DoseIndex{k},:)); 
        end
        
        XX1=XX1(2:10,:)-repmat(XX1(1,:), [9 1]);
        XX2=XX2(2:10,:)-repmat(XX2(1,:), [9 1]);
        
        [~, ~, i1]=intersect(Landmark_Probes, intersect(Probes_Affy, Probes_Geno, 'stable'), 'stable');
        X_Test1=[X_Test1; XX1(:,i1)];
        Y_Test1=[Y_Test1; XX1(:,setdiff(1:size(XX1,2), i1))];

        [~, ~, i2]=intersect(Landmark_Probes, Probes_Geno, 'stable');
        X_Test2=[X_Test2; XX2(:,i2)];
        Y_Test2=[Y_Test2; XX2(:, setdiff(1:size(XX2,2), i2))];
        
end

[~, ~, i1]=intersect(Landmark_Probes, Probes_Affy, 'stable');
Probes_Affy_Other=Probes_Affy(setdiff(1:size(Probes_Affy,1), i1));

[~, ~, i2]=intersect(Landmark_Probes, Probes_Geno, 'stable');
Probes_Geno_Other=Probes_Geno(setdiff(1:size(Probes_Geno,1), i2));

X_affy=X_Test1(:, find(sum(X_Test1)~=0));
X_geno=X_Test2(:, find(sum(X_Test2)~=0));

Y_affy=Y_Test1(:, find(sum(Y_Test1)~=0));
Y_geno=Y_Test2(:, find(sum(Y_Test2)~=0));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Classification Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%KFold
    parfor i=1: length(NN1)  %%Affy
            mdl1=fitcecoc(X_Test1_C,Y_Test1_C(:,NN1(i)), 'kFold', 10);
            Y_pred_class_kf_affy(:,i)=kfoldPredict(mdl1); 
    end

    parfor i=1:length(NN2)  %%Geno
            mdl2=fitcecoc(X_Test2_C,Y_Test2_C(:,NN2(i)), 'kFold', 10);
            Y_pred_class_kf_geno(:,i)=kfoldPredict(mdl2);       
    end

  %Train Test
    
    parfor i=1: length(NN1)  %%Affy
            mdl1=fitcecoc(X_Test1_C,Y_Test1_C(:,NN1(i)));
            Y_pred_class_tt_geno(:,i)=predict(mdl1, X_Test2_C); 
    end

    parfor i=1:length(NN2)  %%Geno
            mdl2=fitcecoc(X_Test2_C,Y_Test2_C(:,NN2(i)));
            Y_pred_class_tt_affy(:,i)=predict(mdl2, X_Test1_C);       
    end

