function [TrainData, ValidationData, Surrogate_Probes] = FindSurrogate(Method)

%%%Input:
%Method = 'SVM' ; uses SVM as the model for GA
%Method = 'RF' ; uses RF as the model for GA
%Method = 'ANN' uses CP-ANN as the model for GA; 
          %Please add "kohonen_cpann_toolbox_3.8" folder as MATLAB path. 
          
%%Output
%Traindata      => Training data used to train the model when the Surrogate_Probes
                   %found is used as predictors;
%ValidationData => Validation data used to validate the performance of
                   %Surorgate probes


%%%%%%%%%%Load TG-GATEs Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data_TG=[];
for i=1:19
    Name=strcat('TGGATESDATA/Data_TGGates_Human', num2str(i));
    load(Name);
    Data_TG=[Data_TG eval(strcat('Data_TG', num2str(i)))];
    Name = strcat('Data_TG', num2str(i));
    clear(Name);
end
clear 'Name' 'i'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Probes_TG');
load('SampleNames_TG');
load('CompoundClass');

%%% 1: Drug  (134 compounds) 124
%%% 2: Environmental (4 compounds) 2 
%%% 3: Industrial (17 compounds) 14
%%% 4: Research 6 compounds) 4
%%% 5: Natural (11 Compounds) 9
%%% 6: Agrichemical (3 compounds) 2

%%%%%%%%%%%%%%%%%%%%%%%%

Var=var(Data_TG');
In1=find(Var>=median(Var));
Data1=Data_TG(In1,:)';
Probes1=Probes_TG(In1)';

Th1=0.1;
Th2=0.1;

Data1_C = Data1;

Data1_C(find(Data1_C<(-1*Th1)))=-1;
Data1_C(find(Data1_C>Th1))=1;
Data1_C(find(Data1_C<=Th1 & Data1_C>=(-1*Th1)))=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[coeff,score,~,~,explained] = pca(Data1);
In2=find(explained>0.1);
C=coeff(:,In2);
K=10000; %% K = 10000 was found using best_kmeans() function.
[IDX,C1,SUMD, D]=kmeans(C,K);

for i=1:K
    IND1=find(IDX==i);
    IND2=find(D(IND1,i)==min(D(IND1,i)));
    SELECT(i) = IND1(IND2(1));
end
Data2=Data1(:,SELECT);
Data2_C=Data1_C(:,SELECT);
Probes2=Probes1(SELECT);

%%%%%%%%Creating Train, Test, Holdout%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Group=cell2mat(SampleNames(:,4));
AllIndex=1:length(Group);
CVP1=cvpartition(Group, 'Holdout', 0.35);
ValidationIndex = AllIndex(find((CVP1.training)==0));
GAIndex=AllIndex(find((CVP1.training)==1));
CVP2=cvpartition(Group(GAIndex), 'Holdout', 0.35);
TrainIndex=GAIndex(find((CVP2.training)==0));

GAData=Data2_C(GAIndex,:);
TrainData = Data1_C(TrainIndex, :);
ValidationData=Data1_C(ValidationIndex,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Surrogate=[];
Round=0;
N=size(GAData,2);
BalAcc=[];
Round=0;
while length(Surrogate)<2000
    Round=Round+1
    OtherThanSurrogate=setdiff([1:N], Surrogate);
    GACVP1=cvpartition(Group(GAIndex), 'Holdout', 0.35);
    GATrainIndex=find(GACVP1.training==0);
    TempIndex=find(GACVP1.training==1);
    GACVP2=cvpartition(Group(GAIndex(TempIndex)), 'Holdout', 0.25);
    GATestIndex=TempIndex(find(GACVP2.training==0));
    YIndex=randsample(OtherThanSurrogate, 10);
    YTrain=GAData(GATrainIndex, YIndex);
    YTest=GAData(GATestIndex, YIndex);
    NN=length(OtherThanSurrogate);
    OtherThanSurrogate=reshape(OtherThanSurrogate(randperm(NN)), 20, NN/20);

    Y_pred=[];

    for i=1:size(OtherThanSurrogate,2)
        TempSurrogate=[Surrogate OtherThanSurrogate(:,i)'];
        XTrain=GAData(GATrainIndex,TempSurrogate);
        XTest=GAData(GATestIndex,TempSurrogate);
        if Method == 'SVM'
            parfor j=1:size(YTrain,2)            
                mdl=fitcecoc(XTrain,YTrain(:,j));
                Y_pred(:,j)=predict(mdl,XTest);
            end
        elseif Method =='RF'
             parfor j=1:size(YTrain,2)            
                mdl=fitensemble(XTrain,YTrain(:,j), 'AdaBoostM2', 100, 'Tree');
                Y_pred(:,j)=predict(mdl,XTest);
             end
        elseif Method =='ANN'
            parfor j=1:size(YTrain,2)            
                settings=som_settings('cpann');
                mdl=model_cpann(XTrain,YTrain(:,j)+2, settings);
                pred=pred_cpann(mdl,XTest);
                Y_pred(:,j)=pred.class_pred-2;
            end
        end
        BalAcc(Round, i)= (1/3)*(sum(sum(YTest+Y_pred==2))/sum(sum(YTest==1)) + sum(sum(YTest+Y_pred==-2))/sum(sum(YTest==-1))+ sum(sum(YTest == 0 & Y_pred == 0))/sum(sum(YTest==0)));
    end

    k=find(BalAcc(Round,:)==max(BalAcc(Round,:)));
    Surrogate=[Surrogate OtherThanSurrogate(:,k(1))'];
end

Surrogate_Probes = Probes2(Surrogate);

%%%%%%%%%%%%%%%%%%%%%%%









