function [Y_pred_reg_kf_affy, Y_pred_reg_kf_geno, Y_pred_reg_tt_geno, Y_pred_reg_tt_affy] = RegModelPOC(X_affy, Y_affy, X_geno, Y_geno);

%%%Regression Model for Proof of Concept (POC)
%Input
%X_affy =>gene expression changes for 978 L1000 landmark genes for Affymetrix
%X_geno =>gene expression changes for 978 L1000 landmark genes for Genometry
%Y_affy =>gene expression changes for remaining genes for Affymetrix
%Y_geno =>gene expression changes for remaining genes for Genometry
%Output
%Y_pred_reg_kf_affy => Prediction of Affymetrix changes using cross validation
%Y_pred_reg_kf_geno => Prediction of Genometry changes using cross validation
%Y_pred_reg_tt_geno => Prediction of Affymetrix changes using train-test
%Y_pred_reg_tt_affy => Prediction of Genometry changes using train-test

    parfor i=1: size(Y_affy,2)  %%Affy
            mdl1=fitrlinear(X_affy,Y_affy(:,NN1(i)), 'kfold', 5);
            Y_pred_reg_kf_affy(:,i)=kfoldPredict(mdl1); 
    end


    parfor i=1:size(Y_geno,2)  %%Geno
            mdl2=fitrlinear(X_geno,Y_geno(:,NN2(i)), 'kFold', 5);
            Y_pred_reg_kf_geno(:,i)=kfoldPredict(mdl2);       
    end

 %Train Test
    
    parfor i=1: size(Y_affy,2)  %%Affy
            mdl1=fitrlinear(X_affy,Y_affy(:,NN1(i)));
            Y_pred_reg_tt_geno(:,i)=predict(mdl1, X_Test2); 
    end
    

    parfor i=1:size(Y_geno,2)  %%Geno
            mdl2=fitrlinear(X_geno,Y_geno(:,NN2(i)));
            Y_pred_reg_tt_affy(:,i)=predict(mdl2, X_Test1);       
    end
