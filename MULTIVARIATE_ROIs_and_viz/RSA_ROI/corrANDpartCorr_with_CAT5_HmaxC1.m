
%Load the brain sub DSM and correlate with external models: Categorical5
%and HmaxC1


%Define the name of the braian masks foor thhe analyses

Rois_name={ 'Mask_RSAhmaxC1_CON>CAT_TFCE-05FWE_dsm',...
    'Mask_RSAhmaxC1_CON>CB1_TFCE05FWE_MASK-V1_dsm','Mask_RSACateg5_CON>CB1_TFCE05FWE_MASK-FGall_dsm',...
    'Mask_RSAhmaxC1_CON>CB2_TFCE05FWE_MASK-V1_dsm','Mask_RSACateg5_CON>CB2_TFCE05FWE_MASK-FGall_dsm',...
    'Mask_RSACateg5_CAT>CB1_TFCE05FWE_MASK-FGall_dsm',...
    'Mask_RSACateg5_CAT>CB2_TFCE05FWE_MASK-FGall_dsm'};


%%%%define the external models and load them%%%%%%%%
Models={'CATEGORICAL_5_CAT','HmaxC1_DSM'};
study_path = (cd);
models_path=fullfile(study_path,'Models');
for m=1:length(Models)
    load(strcat(models_path,'/',Models{m},'.mat'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DSM_path=fullfile(study_path,'BrainDSM');

output_path= fullfile(study_path,'results_RSA');
%%%%Set correlation type: 0=correlation or 1=partial correlation
correlation_type=1; % 0= correlation; 1= partial correlation

if correlation_type == 0
    disp ' Normal correlation'
elseif correlation_type == 1
    disp 'Partial correlation'
end


for iroi=1:length(Rois_name)
    
    disp (strcat(Rois_name{iroi}));
    %% Group 1: CON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(strcat(DSM_path,'/CON_',Rois_name{iroi},'.mat'));
    tot=size(CON_vec);
    for isub=1:tot(1)
        Sub_matCON= squareform(CON_vec(isub,:));
        
        
        if correlation_type==0 %%%normal correlation
            DATA_mat=Sub_matCON; %%the mat from the current subject
            
            %%%%correlation with CATEGORICAL_5_CAT model
            TARGET_mat=CATEGORICAL_5_CAT;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetCategoricalCON(isub)=correl;
            
            %%%%correlation with low level model
            TARGET_mat=HmaxC1_DSM;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetLowLevelCON(isub)=correl;
            
        elseif correlation_type==1 %%partial correlation
            DATA_mat=Sub_matCON; %%the mat from the current subject
            
            %% partial correlation with Categorical model
            TARGET_mat=CATEGORICAL_5_CAT;
            REGRESS_mat=HmaxC1_DSM;
            %%In the simulated there are the data in both format either vector or dissimilarity matrix
            %%To run this CATript you need to have them in vector shape (1 column)
            %%open this part only if you data are in dissimilarity matrix shape
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetCategoricalCON(isub)=Partial_corr;
            
            %% partial correlation with Low level model
            TARGET_mat=HmaxC1_DSM;
            REGRESS_mat=CATEGORICAL_5_CAT;
            %%In the simulated there are the data in both format either vector or dissimilarity matrix
            %%To run this CATript you need to have them in vector shape (1 column)
            %%open this part only if you data are in dissimilarity matrix shape
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetLowLevelCON(isub)=Partial_corr;
        end %if loop: correlation/partial correlation
    end %isub CON
    
    
    %% Group 2:CAT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(strcat(DSM_path,'/CAT_',Rois_name{iroi},'.mat'));
    tot=size(CAT_vec);
    for isub=1:tot(1)
        Sub_matCAT= squareform(CAT_vec(isub,:));
        
        if correlation_type==0 %%%normal correlation
            DATA_mat=Sub_matCAT; %%the mat from the current subject
            
            %%%%correlation with Categorical model
            TARGET_mat=CATEGORICAL_5_CAT;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetCategoricalCAT(isub)=correl;
            
            %%%%correlation with low level model
            TARGET_mat=HmaxC1_DSM;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetLowLevelCAT(isub)=correl;
            
        elseif correlation_type==1 %%partial correlation
            DATA_mat=Sub_matCAT; %%the mat from the current subject
            %%partial correlation with Categorical model
            TARGET_mat=CATEGORICAL_5_CAT;
            REGRESS_mat=HmaxC1_DSM;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetCategoricalCAT(isub)=Partial_corr;
            
            %%partial correlation with Low level model
            TARGET_mat=HmaxC1_DSM;
            REGRESS_mat=CATEGORICAL_5_CAT;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetLowLevelCAT(isub)=Partial_corr;
        end %if loop: correlation/partial correlation
    end %isub CAT
    
    %% Group 3: C1B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(strcat(DSM_path,'/C1B_',Rois_name{iroi},'.mat'));
    tot=size(C1B_vec);
    for isub=1:tot(1)
        Sub_matC1B= squareform(C1B_vec(isub,:));
        
        
        if correlation_type==0 %%%normal correlation
            DATA_mat=Sub_matC1B; %%the mat from the current subject
            
            %%%%correlation with CATEGORICAL_5_CAT model
            TARGET_mat=CATEGORICAL_5_CAT;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetCategoricalC1B(isub)=correl;
            
            %%%%correlation with low level model
            TARGET_mat=HmaxC1_DSM;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetLowLevelC1B(isub)=correl;
            
        elseif correlation_type==1 %%partial correlation
            DATA_mat=Sub_matC1B; %%the mat from the current subject
            
            %%partial correlation with Categorical model
            TARGET_mat=CATEGORICAL_5_CAT;
            REGRESS_mat=HmaxC1_DSM;
            %% In the simulated there are the data in both format either vector or dissimilarity matrix
            %% To run this CATript you need to have them in vector shape (1 column)
            %% open this part only if you data are in dissimilarity matrix shape
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetCategoricalC1B(isub)=Partial_corr;
            
            %%partial correlation with Low level model
            TARGET_mat=HmaxC1_DSM;
            REGRESS_mat=CATEGORICAL_5_CAT;
            %% In the simulated there are the data in both format either vector or dissimilarity matrix
            %% To run this CATript you need to have them in vector shape (1 column)
            %% open this part only if you data are in dissimilarity matrix shape
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetLowLevelC1B(isub)=Partial_corr;
        end %if loop: correlation/partial correlation
    end %isub C1B
    
    %% Group 4: C2B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(strcat(DSM_path,'/C2B_',Rois_name{iroi},'.mat'));
    tot=size(C2B_vec);
    for isub=1:tot(1)
        Sub_matC2B= squareform(C2B_vec(isub,:));
        
        
        if correlation_type==0 %%%normal correlation
            DATA_mat=Sub_matC2B; %%the mat from the current subject
            
            %%%%correlation with CATEGORICAL_5_CAT model
            TARGET_mat=CATEGORICAL_5_CAT;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetCategoricalC1B(isub)=correl;
            
            %%%%correlation with low level model
            TARGET_mat=HmaxC1_DSM;
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            correl= corr(DATA_vec,TARGET_vec,'type','Spearman');
            R_targetLowLevelC2B(isub)=correl;
            
        elseif correlation_type==1 %%partial correlation
            DATA_mat=Sub_matC2B; %%the mat from the current subject
            
            %%partial correlation with Categorical model
            TARGET_mat=CATEGORICAL_5_CAT;
            REGRESS_mat=HmaxC1_DSM;
            %% In the simulated there are the data in both format either vector or dissimilarity matrix
            %% To run this CATript you need to have them in vector shape (1 column)
            %% open this part only if you data are in dissimilarity matrix shape
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetCategoricalC2B(isub)=Partial_corr;
            
            %%partial correlation with Low level model
            TARGET_mat=HmaxC1_DSM;
            REGRESS_mat=CATEGORICAL_5_CAT;
            %% In the simulated there are the data in both format either vector or dissimilarity matrix
            %% To run this CATript you need to have them in vector shape (1 column)
            %% open this part only if you data are in dissimilarity matrix shape
            DATA_vec= squareform (DATA_mat)'; %%"squareform" is a function from MVPA that makes the dissimilarity matrix in vector (raw) shape
            TARGET_vec=squareform(TARGET_mat)';
            REGRESS_vec=squareform(REGRESS_mat)';
            %%function from Cosmo MVPA inside "cosmo target dsm corr measure"
            nsamples=size(DATA_vec,1);
            regr=[REGRESS_vec ones(nsamples,1)];
            both= [DATA_vec TARGET_vec];
            both_resid=both-regr*(regr\both);
            ds_resid=both_resid(:,1);
            target_resid=both_resid (:,2);
            Partial_corr= corr(DATA_vec,target_resid,'type','Spearman');
            ParR_targetLowLevelC2B(isub)=Partial_corr;
        end %if loop: correlation/partial correlation
    end %isub C2B
    
    
    %%save the results for eCATh ROI
    if correlation_type==0
        R_targetCategoricalCON=R_targetCategoricalCON';
        R_targetCategoricalCAT=R_targetCategoricalCAT';
        R_targetCategoricalC1B=R_targetCategoricalC1B';
        R_targetCategoricalC2B=R_targetCategoricalC2B';
        R_targetLowLevelCON=R_targetLowLevelCON';
        R_targetLowLevelCAT=R_targetLowLevelCAT';
        R_targetLowLevelC1B=R_targetLowLevelC1B';
        R_targetLowLevelC2B=R_targetLowLevelC2B';
        
        save(strcat(output_path,'/',Rois_name{iroi},'_SpearmanCorr_CAT5_HmaxC1_GROUPSlab_iter_'),...
            'R_targetCategoricalCON','R_targetLowLevelCON',...
            'R_targetCategoricalCAT','R_targetLowLevelCAT',...
            'R_targetCategoricalC1B','R_targetLowLevelC1B',...
            'R_targetCategoricalC2B','R_targetLowLevelC2B');
        %plot the results
        disp 'CON_CAT5';
        meanCON(:,1)=mean(R_targetCategoricalCON)
        disp 'CON_HmaxC1';
        meanCON(:,2)=mean(R_targetLowLevelCON)
        disp 'CAT_CAT5';
        meanCAT(:,1)=mean(R_targetCategoricalCAT)
        disp 'CAT_HmaxC1';
        meanCAT(:,2)=mean(R_targetLowLevelCAT)
        disp 'C1B_CAT5';
        meanC1B(:,1)=mean(R_targetCategoricalC1B)
        disp 'C1B_HmaxC1';
        meanC1B(:,2)=mean(R_targetLowLevelC1B)
        disp 'C2B_CAT5';
        meanC2B(:,1)=mean(R_targetCategoricalC2B)
        disp 'C2B_HmaxC1';
        meanC2B(:,2)=mean(R_targetLowLevelC2B)
        
        
    elseif correlation_type==1
        
        ParR_targetCategoricalCON=ParR_targetCategoricalCON';
        ParR_targetCategoricalCAT=ParR_targetCategoricalCAT';
        ParR_targetCategoricalC1B=ParR_targetCategoricalC1B';
        ParR_targetCategoricalC2B=ParR_targetCategoricalC2B';
        ParR_targetLowLevelCON=ParR_targetLowLevelCON';
        ParR_targetLowLevelCAT=ParR_targetLowLevelCAT';
        ParR_targetLowLevelC1B=ParR_targetLowLevelC1B';
        ParR_targetLowLevelC2B=ParR_targetLowLevelC2B';
        
        disp 'CON_CAT5';
        meanCON(:,1)=mean(ParR_targetCategoricalCON)
        disp 'CON_HmaxC1';
        meanCON(:,2)=mean(ParR_targetLowLevelCON)
        disp 'CAT_CAT5';
        meanCAT(:,1)=mean(ParR_targetCategoricalCAT)
        disp 'CAT_HmaxC1';
        meanCAT(:,2)=mean(ParR_targetLowLevelCAT)
        disp 'C1B_CAT5';
        meanC1B(:,1)=mean(ParR_targetCategoricalC1B)
        disp 'C1B_HmaxC1';
        meanC1B(:,2)=mean(ParR_targetLowLevelC1B)
        disp 'C2B_CAT5';
        meanC2B(:,1)=mean(ParR_targetCategoricalC2B)
        disp 'C2B_HmaxC1';
        meanC2B(:,2)=mean(ParR_targetLowLevelC2B)
        
        
        save(strcat(output_path,'/',Rois_name{iroi},'PartialSpearmanCorr_CAT5_HmaxC1_GROUPSlab_iter_'),...
            'ParR_targetCategoricalCON','ParR_targetLowLevelCON',...
            'ParR_targetCategoricalCAT','ParR_targetLowLevelCAT',...
            'ParR_targetCategoricalC1B','ParR_targetLowLevelC1B',...
            'ParR_targetCategoricalC2B','ParR_targetLowLevelC2B');
    end
    
    
    clear R_targetCategoricalCON
    clear  R_targetCategoricalCAT
    clear  R_targetCategoricalC1B
    clear  R_targetCategoricalC2B
    clear R_targetLowLevelCON
    clear R_targetLowLevelCAT
    clear R_targetLowLevelC1B
    clear R_targetLowLevelC2B
    
    clear    ParR_targetCategoricalCON
    clear  ParR_targetCategoricalCAT
    clear  ParR_targetCategoricalC1B
    clear  ParR_targetCategoricalC2B
    clear ParR_targetLowLevelCON
    clear  ParR_targetLowLevelCAT
    clear  ParR_targetLowLevelC1B
    clear  ParR_targetLowLevelC2B
end %iroi

