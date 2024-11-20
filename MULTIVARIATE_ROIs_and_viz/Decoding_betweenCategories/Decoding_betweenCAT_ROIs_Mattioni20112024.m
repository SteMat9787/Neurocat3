clear all
cosmo_warning('off');
%% Decoding between categories in ROIs
% Cross validation with the cosmo_crossvalidation_measure function, using a classifier with n-fold
% crossvalidation.

% #   For CoSMoMVPA's copyright information and license terms,   #
% #   see the COPYING file distributed with CoSMoMVPA.           #

%% Set the subjects info and define groups
global sub

sub=pm_data;

CON=[1:15,17];
CAT=[18:26,28:32];
C1B=[33:41,43:46];
C2B=[47:55,57:60];
no_sub= [CON,CAT,C1B,C2B]


%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%SET the VARIABLE:
%% Define data
%config=cosmo_config();
study_path= fileparts(cd);%'/data/NeuroCat3/MULTIVARIATE';
masks_path = fullfile(study_path,'masks/Sub_ROIs_MReyeResults/5Way_decoding');

%%Load the brain mask for the RSA searchlight
mask_fn=fullfile(masks_path, 'Mask_5wayDECODING_CON>CB2_TFCE05FWE_Mask-FGall.img');
ROIs_name='CON>CB2_MaskFGall_Searchlight_05FWE_250vx';
% Mask_5wayDECODING_CON>CB1_TFCE05FWE_Mask-bilV1
% Mask_5wayDECODING_CON>CB1_TFCE05FWE_Mask-FGall
% Mask_5wayDECODING_CON>CB2_TFCE05FWE_Mask-V1
% Mask_5wayDECODING_CON>CB2_TFCE05FWE_Masl-FGall
% Mask_5wayDECODING_CAT>CB1_TFCE05FWE_MaskFGall
% Mask_5wayDECODING_CAT>CB2_TFCE05FWE_Mask-FGall
numVoxelsTokeep=250;

classifier=1; %1=lda; 2=svm

CON_MEAN_confusion_matrix= zeros(5,5);
CAT_MEAN_confusion_matrix= zeros(5,5);
C1B_MEAN_confusion_matrix= zeros(5,5);
C2B_MEAN_confusion_matrix= zeros(5,5);

counter_line=0;
for isub = no_sub
    
    disp(strcat('processing SUB',num2str(isub),':',sub(isub).id));
    study_path_sub = fullfile(study_path,(sub(isub).folder)); %select the data in each folder (EB,LB;SC)
    sub_name=  (sub(isub).id);
    
    data_path=fullfile(study_path_sub);%,sub_name);
    data_fn=strcat(data_path,'/',sub_name,'_spmT_4D_MVPA_MReye.nii');
    
    targets=repmat(1:5,1,6)';
    targets= sort(targets);
    targets=repmat(targets,str2num(sub(isub).Nrun),1);
    
    
    chunks=ceil((1:(30*str2num(sub(isub).Nrun)))/30)'; %chuncks is number of runs, 30== numeber of values per runs
    ds = cosmo_fmri_dataset(data_fn, 'mask', mask_fn,...
        'targets',targets,'chunks',chunks);
    
    
    
    %remove constant features (due to liberal masking)
    ds=cosmo_remove_useless_data(ds);
    % Part 1: Use single classifier
    
    
    
    measure= @cosmo_crossvalidation_measure;
    
    %Assign the struct to the variable 'args'
    args=struct();
    if classifier==1
        args.child_classifier = @cosmo_classify_lda;
    elseif classifier==2
        args.child_classifier = @cosmo_classify_svm;
    end
    args.output='predictions';
    args.normalization = 'zscore';%'demean';
    args.feature_selector=@cosmo_anova_feature_selector;
    
    n=size(ds.samples);
    n_features=n(2);
    if  n_features<numVoxelsTokeep
        args.feature_selection_ratio_to_keep =  n_features;
    else
        args.feature_selection_ratio_to_keep = numVoxelsTokeep;% thats for the feature selection
    end
    disp (strcat('n features selected:',num2str(args.feature_selection_ratio_to_keep),'on total features:',num2str(n_features)));
    
    partitions = cosmo_nfold_partitioner(ds);
    
    
    %
    % Apply the measure to ds, with args as second argument. Assign the result
    % to the variable 'ds_accuracy'.
    
    ds_accuracy = cosmo_crossvalidate(ds,@cosmo_meta_feature_selection_classifier,partitions,args);
    ds_accuracy = reshape(ds_accuracy', 1, []);
    ds_accuracy = ds_accuracy(~isnan(ds_accuracy))';
    confusion_matrix=cosmo_confusion_matrix(targets,ds_accuracy);
    
    
    %%confusion_matrix=cosmo_confusion_matrix(ds_accuracy.sa.targets,ds_accuracy.samples);
    sum_diag=sum(diag(confusion_matrix));
    sum_total=sum(confusion_matrix(:));
    accuracy=sum_diag/sum_total;
    
    
    %Create an average confusioon matrix per each group and store the accuracy
    %value for each subject
    if sum(isub==CON)==1
        CON_MEAN_confusion_matrix=CON_MEAN_confusion_matrix + confusion_matrix;
        CON_all_accuracy(counter_line+1,1)= accuracy;
    end
    if sum(isub==CAT)==1
        CAT_MEAN_confusion_matrix=CAT_MEAN_confusion_matrix + confusion_matrix;
        CAT_all_accuracy(counter_line+1,1)= accuracy;
    end
    if sum(isub==C1B)==1
        C1B_MEAN_confusion_matrix=C1B_MEAN_confusion_matrix + confusion_matrix;
        C1B_all_accuracy(counter_line+1,1)= accuracy;
    end
    if sum(isub==C2B)==1
        C2B_MEAN_confusion_matrix=C2B_MEAN_confusion_matrix + confusion_matrix;
        C2B_all_accuracy(counter_line+1,1)= accuracy;
    end
    counter_line=counter_line+1;
end

%%rename the accuracy correctly
CON_all_accuracy=CON_all_accuracy(1:16);
CAT_all_accuracy=CAT_all_accuracy(17:30);
C1B_all_accuracy=C1B_all_accuracy(31:43);
C2B_all_accuracy=C2B_all_accuracy(44:56);
% % %%rename the accuracy correctly


%compute the mean accuracy for each group
CON_accuracy_real = mean(CON_all_accuracy);
CAT_accuracy_real = mean(CAT_all_accuracy);
C1B_accuracy_real = mean(C1B_all_accuracy);
C2B_accuracy_real = mean(C2B_all_accuracy);

%%%visualize the mean confusion mat for the 2 groups
%%To create the group mean matrices
CON_MEAN_confusion_matrix=CON_MEAN_confusion_matrix/length(CON) %divided it by num of CON
CAT_MEAN_confusion_matrix=CAT_MEAN_confusion_matrix/length(CAT);%divided it by num of CAT
C1B_MEAN_confusion_matrix=C1B_MEAN_confusion_matrix/length(C1B);%divided it by num of CAT
C2B_MEAN_confusion_matrix=C2B_MEAN_confusion_matrix/length(C2B);%divided it by num of CAT

%%visualize the 4 mean matrices

%%%%%%%%% CON %%%%%%%%%%%%%%%%%
CON_sum_diag=sum(diag(CON_MEAN_confusion_matrix));
CON_sum_total=sum(CON_MEAN_confusion_matrix(:));
CON_accuracy=CON_sum_diag/CON_sum_total;

CON_percMEAN_DSM= (CON_MEAN_confusion_matrix).*100./30 %%30 is the total number of repetiiton for each category item (e.g. 30 houses)
figure();
subplot(1,4,1);
imagesc(CON_percMEAN_DSM); colorbar;
if classifier==1
    classifier_name='lda'; % no underscores
elseif classifier==2
    classifier_name='svm'; % no underscores
end

desc=sprintf('CON  %s: accuracy %.1f%%', classifier_name, CON_accuracy*100);
title(desc)


classes={'BODY','FACE','HOUSE','TOOL','WORD'};


nclasses=numel(classes);
set(gca,'XTick',1:nclasses,'XTickLabel',classes);
set(gca,'YTick',1:nclasses,'YTickLabel',classes);
ylabel('target');
xlabel('predicted');
colorbar

%%%%%%%%% CAT %%%%%%%%%%%%%%%%%
CAT_sum_diag=sum(diag(CAT_MEAN_confusion_matrix));
CAT_sum_total=sum(CAT_MEAN_confusion_matrix(:));
CAT_accuracy=CAT_sum_diag/CAT_sum_total;
CAT_percMEAN_DSM=(CAT_MEAN_confusion_matrix).*100./30 %%30 is the total number of repetiiton for each category item (e.g. 30 houses)


subplot(1,4,2);
imagesc(CAT_percMEAN_DSM); colorbar;
if classifier==1
    classifier_name='lda'; % no underscores
elseif  classifier==2
    classifier_name='svm'; % no underscores
end
desc=sprintf('CAT  %s: accuracy %.1f%%', classifier_name, CAT_accuracy*100);
title(desc)


classes={'BODY','FACE','HOUSE','TOOL','WORD'};


nclasses=numel(classes);
set(gca,'XTick',1:nclasses,'XTickLabel',classes);
set(gca,'YTick',1:nclasses,'YTickLabel',classes);
ylabel('target');
xlabel('predicted');
colorbar

%%%%%%%%% C1B %%%%%%%%%%%%%%%%%
C1B_sum_diag=sum(diag(C1B_MEAN_confusion_matrix));
C1B_sum_total=sum(C1B_MEAN_confusion_matrix(:));
C1B_accuracy=C1B_sum_diag/C1B_sum_total;
C1B_percMEAN_DSM=(C1B_MEAN_confusion_matrix).*100./30 %%30 is the total number of repetiiton for each category item (e.g. 30 houses)


subplot(1,4,3);
imagesc(C1B_percMEAN_DSM); colorbar;
if classifier==1
    classifier_name='lda'; % no underscores
elseif classifier==2
    classifier_name='svm'; % no underscores
end
desc=sprintf('C1B  %s: accuracy %.1f%%', classifier_name, C1B_accuracy*100);
title(desc)


classes={'BODY','FACE','HOUSE','TOOL','WORD'};


nclasses=numel(classes);
set(gca,'XTick',1:nclasses,'XTickLabel',classes);
set(gca,'YTick',1:nclasses,'YTickLabel',classes);
ylabel('target');
xlabel('predicted');
colorbar
%%%%%%%%% C2B %%%%%%%%%%%%%%%%%
C2B_sum_diag=sum(diag(C2B_MEAN_confusion_matrix));
C2B_sum_total=sum(C2B_MEAN_confusion_matrix(:));
C2B_accuracy=C2B_sum_diag/C2B_sum_total;
C2B_percMEAN_DSM=(C2B_MEAN_confusion_matrix).*100./30 %%30 is the total number of repetiiton for each category item (e.g. 30 houses)

subplot(1,4,4);
imagesc(C2B_percMEAN_DSM); colorbar;
if classifier==1
    classifier_name='lda'; % no underscores
elseif classifier==2
    classifier_name='svm'; % no underscores
end
desc=sprintf('C2B  %s: accuracy %.1f%%', classifier_name, C2B_accuracy*100);
title(desc)


classes={'BODY','FACE','HOUSE','TOOL','WORD'};


nclasses=numel(classes);
set(gca,'XTick',1:nclasses,'XTickLabel',classes);
set(gca,'YTick',1:nclasses,'YTickLabel',classes);
ylabel('target');
xlabel('predicted');
colorbar


%% save the data
all_accuracy =[CON_all_accuracy;CAT_all_accuracy;C1B_all_accuracy;C2B_all_accuracy];
save(strcat(study_path,'/MVPA_ROI/5cat_classification_',classifier_name,'/',ROIs_name,'_',num2str(numVoxelsTokeep),'bestvx_',num2str(n_iter),'_perm_MASKonlyFG'));

function [sub] = pm_data
% %
% % %PILOT
% %
% % sub(1).id      =    'CON_OliC';
% % sub(1).Nrun    =    '2';
% % sub(1).folder  =    '4D_files';


%CONTROL_original exp
sub(1).id      =    'CON_EsEn';
sub(1).Nrun    =    '4';
sub(1).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(2).id      =    'CON_MoJa' ;
sub(2).Nrun    =    '5';
sub(2).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(3).id      =    'CON_CoLi' ;
sub(3).Nrun    =    '5';
sub(3).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(4).id      =    'CON_LuNg' ;
sub(4).Nrun    =    '5';
sub(4).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(5).id      =    'CON_HeTr';
sub(5).Nrun    =    '5';
sub(5).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(6).id      =    'CON_OlCo' ;
sub(6).Nrun    =    '5';
sub(6).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(7).id      =    'CON_ThBa' ;
sub(7).Nrun    =    '5';
sub(7).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(8).id      =    'CON_JoAb' ;
sub(8).Nrun    =    '5';
sub(8).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(9).id      =    'CON_ShZh';
sub(9).Nrun    =    '5';
sub(9).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(10).id      =    'CON_StMa' ;
sub(10).Nrun    =    '5';
sub(10).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(11).id      =    'CON_MoKa' ;
sub(11).Nrun    =    '5';
sub(11).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(12).id      =    'CON_AlSo' ;
sub(12).Nrun    =    '5';
sub(12).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(13).id      =    'CON_MaTv';
sub(13).Nrun    =    '5';
sub(13).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(14).id      =    'CON_FlFe' ;
sub(14).Nrun    =    '5';
sub(14).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(15).id      =    'CON_XiGa' ;
sub(15).Nrun    =    '5';
sub(15).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(16).id      =    'CON_BrCh' ;
sub(16).Nrun    =    '5';
sub(16).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(17).id      =    'CON_MoRe';
sub(17).Nrun    =    '5';
sub(17).folder  =    'spmT_4D_files/spmT_4D_MReye';

%CATARACT subJECTS


sub(18).id      =    'CAT_MiDo' ;
sub(18).Nrun    =    '5';
sub(18).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(19).id      =    'CAT_JeSu' ;
sub(19).Nrun    =    '5';
sub(19).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(20).id      =    'CAT_JeBr' ;
sub(20).Nrun    =    '5';
sub(20).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(21).id      =    'CAT_WiSn';
sub(21).Nrun    =    '5';
sub(21).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(22).id      =    'CAT_ZaCr' ;
sub(22).Nrun    =    '5';
sub(22).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(23).id      =    'CAT_JoSn' ;
sub(23).Nrun    =    '5';
sub(23).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(24).id      =    'CAT_AlBo' ;
sub(24).Nrun    =    '5';
sub(24).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(25).id      =    'CAT_CaBa' ;
sub(25).Nrun    =    '5';
sub(25).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(26).id      =    'CAT_CaPi' ;
sub(26).Nrun    =    '5';
sub(26).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(27).id      =    'CAT_NaAs' ;
sub(27).Nrun    =    '5';
sub(27).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(28).id      =    'CAT_AdCa' ;
sub(28).Nrun    =    '5';
sub(28).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(29).id      =    'CAT_JeOn' ;
sub(29).Nrun    =    '5';
sub(29).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(30).id      =    'CAT_MiMo' ;
sub(30).Nrun    =    '5';
sub(30).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(31).id      =    'CAT_SaAt' ;
sub(31).Nrun    =    '5';
sub(31).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(32).id      =    'CAT_ViOn' ;
sub(32).Nrun    =    '5';
sub(32).folder  =    'spmT_4D_files/spmT_4D_MReye';

%CONTROL BLURRY 1 (C1B) : 20on60
sub(33).id      =    'C1B_AiSu' ;
sub(33).Nrun    =    '5';
sub(33).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(34).id      =    'C1B_AkNa';
sub(34).Nrun    =    '4';
sub(34).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(35).id      =    'C1B_AlLe' ;
sub(35).Nrun    =    '5';
sub(35).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(36).id      =    'C1B_AlWa' ;
sub(36).Nrun    =    '5';
sub(36).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(37).id      =    'C1B_AmPa' ;
sub(37).Nrun    =    '5';
sub(37).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(38).id      =    'C1B_ArGr' ;
sub(38).Nrun    =    '5';
sub(38).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(39).id      =    'C1B_DaDa' ;
sub(39).Nrun    =    '5';
sub(39).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(40).id      =    'C1B_EvLe' ;
sub(40).Nrun    =    '5';
sub(40).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(41).id      =    'C1B_JeJo' ;
sub(41).Nrun    =    '4';
sub(41).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(42).id      =    'C1B_JiFe' ;
sub(42).Nrun    =    '4';
sub(42).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(43).id      =    'C1B_JiHa' ;
sub(43).Nrun    =    '5';
sub(43).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(44).id      =    'C1B_KeBe';
sub(44).Nrun    =    '5';
sub(44).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(45).id      =    'C1B_MaGa' ;
sub(45).Nrun    =    '5';
sub(45).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(46).id      =    'C1B_ViLe' ;
sub(46).Nrun    =    '4';
sub(46).folder  =    'spmT_4D_files/spmT_4D_MReye';

%CONTROL BLURRY 2 (C2B) : 20on120
sub(47).id      =    'C2B_AiSu' ;
sub(47).Nrun    =    '5';
sub(47).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(48).id      =    'C2B_AkNa';
sub(48).Nrun    =    '4';
sub(48).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(49).id      =    'C2B_AlLe' ;
sub(49).Nrun    =    '4';
sub(49).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(50).id      =    'C2B_AlWa' ;
sub(50).Nrun    =    '4';
sub(50).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(51).id      =    'C2B_AmPa' ;
sub(51).Nrun    =    '4';
sub(51).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(52).id      =    'C2B_ArGr' ;
sub(52).Nrun    =    '5';
sub(52).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(53).id      =    'C2B_DaDa' ;
sub(53).Nrun    =    '4';
sub(53).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(54).id      =    'C2B_EvLe' ;
sub(54).Nrun    =    '4';
sub(54).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(55).id      =    'C2B_JeJo' ;
sub(55).Nrun    =    '4';
sub(55).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(56).id      =    'C2B_JiFe' ;
sub(56).Nrun    =    '4';
sub(56).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(57).id      =    'C2B_JiHa' ;
sub(57).Nrun    =    '4';
sub(57).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(58).id      =    'C2B_KeBe';
sub(58).Nrun    =    '4';
sub(58).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(59).id      =    'C2B_MaGa' ;
sub(59).Nrun    =    '4';
sub(59).folder  =    'spmT_4D_files/spmT_4D_MReye';

sub(60).id      =    'C2B_ViLe' ;
sub(60).Nrun    =    '4';
sub(60).folder  =    'spmT_4D_files/spmT_4D_MReye';
end