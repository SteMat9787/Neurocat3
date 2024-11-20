clear all
%% Decoding analyses in ROIs from Serachlight within each category separately
    

%% Set the subjects info and define groups
global sub

sub=pm_data;

CON=[1:15,17];
CAT=[18:26,28:32];
CB1= [33:41,43:46];
CB2=[47:55,57:60];
no_sub= [CON,CAT,CB1,CB2];%,30:57];


%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define data
%config=cosmo_config();
study_path= fileparts(cd);%'/data/NeuroCat3/MULTIVARIATE';
masks_path = fullfile(study_path,'masks/Sub_ROIs_MReyeResults/WithinCATdecoding');
%%set the putput folder path
output_path=fullfile(study_path,'MVPA_ROI/results_ROIs_withinCAT_MReye');

%%set the name of the masks
mask_name={'Mask_WORDS_CON>CB1_TFCE_05FWE-V1mask','Mask_WORDS_CON>CB2_TFCE_05FWE-V1mask'};
%set the name of the categories
CATEGORIES={'body','face','house','tool','word'};

%set te numb of voxels to use in each ROI
nVoxels=100;

%%Load the brain mask 
for nROI=1:length(mask_name); %%remember to re start from 1

mask_fn=strcat(masks_path,'/', mask_name{nROI},'.nii') %%specify the fn for the correct mask
%mask_fn=strcat(masks_path,'/', mask_name{nROI},'.nii') %%specify the fn for the correct mask
ROIs_name= mask_name{nROI}%(1:5) %%to have the correct name on the plot
for nCAT=5%1:length(CATEGORIES) 
    CAT_NAME=CATEGORIES{nCAT};

    %prepare the empty 
    CON_confusion_matrix= zeros(6,6);
    CAT_confusion_matrix= zeros(6,6);
    CB1_confusion_matrix= zeros(6,6);
    CB2_confusion_matrix= zeros(6,6);
    
    CON_percMEAN_DSM= zeros(6,6);
    CAT_percMEAN_DSM= zeros(6,6);
    CB1_percMEAN_DSM= zeros(6,6);
    CB2_percMEAN_DSM= zeros(6,6);


counter_line=0;
for isub = no_sub
    
    study_path_sub = fullfile(study_path,(sub(isub).folder)); %select the data in each folder (EB,LB;SC)
    sub_name=  sub(isub).id;
    
    data_path=fullfile(study_path_sub);%,sub_name);
    %data_fn=fullfile('/data/RSA/SOUNDRSA_splithalf_consistency/',strcat(sub(isub).folder,'/',sub_name,'/',sub_name,'_RSA120_bothDer_4D.nii'));
     data_fn=strcat(data_path,'/spmT_4D_MReye/',sub_name,'_spmT_4D_MVPA_MReye.nii');

     %targets for  categories
    targets=repmat(1:30,1,1)';
    targets= sort(targets);
    targets=repmat(targets,str2num(sub(isub).Nrun),1);
     
%%chuncks
chunks=ceil((1:(30*str2num(sub(isub).Nrun)))/30)'; %chuncks is number of runs, 30== numeber of values per runs

ds = cosmo_fmri_dataset(data_fn, 'mask', mask_fn,...
        'targets',targets,'chunks',chunks);

 % remove constant features (due to liberal masking)
ds=cosmo_remove_useless_data(ds);

%%if the features (==voxels) are less then 100 use that num as numVoxelsTokeep

if max(size(ds.samples(1,:)))<nVoxels
    numVoxelsTokeep= max(size(ds.samples(1,:)));
else
  numVoxelsTokeep=nVoxels;
end
disp('numVoxelsTokeep');
numVoxelsTokeep

nVoxel(isub)=numVoxelsTokeep;



%%select the correct dataset according to the selected category
%%Define which target correspond to wich category
if sub(isub).Nrun=='5'
CAT1=[1:6,31:36,61:66,91:96,121:126]; % body are the first 6 of each run
CAT2=[7:12,37:42, 67:72,97:102,127:132];% faces
CAT3=[13:18,43:48,73:78,103:108,133:138]; %houses
CAT4=[19:24,49:54,79:84,109:114,139:144]; %tools
CAT5=[25:30,55:60,85:90,115:120,145:150]; %words
elseif sub(isub).Nrun=='4'
CAT1=[1:6,31:36,61:66,91:96]; % body are the first 6 of each run
CAT2=[7:12,37:42, 67:72,97:102];% faces
CAT3=[13:18,43:48,73:78,103:108]; %houses
CAT4=[19:24,49:54,79:84,109:114]; %tools
CAT5=[25:30,55:60,85:90,115:120]; %words    
end

if nCAT == 1
ds=cosmo_slice(ds,CAT1);
elseif nCAT==2
ds=cosmo_slice(ds,CAT2);
elseif nCAT==3
ds=cosmo_slice(ds,CAT3);
elseif nCAT==4
ds=cosmo_slice(ds,CAT4);
elseif nCAT==5
ds=cosmo_slice(ds,CAT5);
end

%% Set the measure for the classification analysis
measure= @cosmo_crossvalidation_measure; 

% Make a struct containing the arguments for the measure:
% - classifier: a function handle to cosmo_classify_lda
% - partitions: the output of cosmo_nfold_partitioner applied to the
%               dataset
% Assign the struct to the variable 'args'
args=struct();
args.child_classifier = @cosmo_classify_lda;
%args.child_classifier = @cosmo_classify_svm;
%args.partitions = cosmo_nfold_partitioner(ds);
args.output='predictions';  
args.normalization = 'zscore';%'demean';
args.feature_selector=@cosmo_anova_feature_selector;
args.feature_selection_ratio_to_keep = numVoxelsTokeep;% thats for the feature selection
%args.max_feature_count=6000; %automatycallly Cosmo set the limit at 5000,
%open if your ROI is bigger
partitions = cosmo_nfold_partitioner(ds);
fprintf('Using the following measure:\n');
cosmo_disp(measure,'strlen',Inf); % avoid string truncation

fprintf('\nUsing the following measure arguments:\n');
cosmo_disp(args);

% Apply the measure to ds, with args as second argument. Assign the result
% to the variable 'ds_accuracy'.
ds_accuracy = cosmo_crossvalidate(ds,@cosmo_meta_feature_selection_classifier,partitions,args);

        ds_accuracy = reshape(ds_accuracy', 1, []);
    ds_accuracy = ds_accuracy(~isnan(ds_accuracy))';
% if sub(isub).Nrun=='5' 
% ds_accuracy =[ds_accuracy(1:6,1);ds_accuracy(7:12,2);ds_accuracy(13:18,3);ds_accuracy(19:24,4);ds_accuracy(25:30,5)];
% elseif sub(isub).Nrun=='4' 
% ds_accuracy =[ds_accuracy(1:6,1);ds_accuracy(7:12,2);ds_accuracy(13:18,3);ds_accuracy(19:24,4)];
% end

confusion_matrix=cosmo_confusion_matrix(ds.sa.targets,ds_accuracy);
%%compute the accuracy value
sum_diag=sum(diag(confusion_matrix));
    sum_total=sum(confusion_matrix(:));
    accuracy=sum_diag/sum_total;
    

% Show the result
fprintf('\nOutput dataset (with classification accuracy)\n');
% Show the contents of 'ds_accuracy' using 'cosmo_disp'
cosmo_disp(ds_accuracy);
if sum(isub==CON)==1
    CON_confusion_matrix=CON_confusion_matrix + confusion_matrix;
    CON_percMEAN_DSM=CON_percMEAN_DSM+((confusion_matrix).*100./str2num(sub(isub).Nrun));
    CON_all_accuracy(counter_line+1,1)= accuracy;
end
if sum(isub==CAT)==1
    CAT_confusion_matrix=CAT_confusion_matrix + confusion_matrix;
    CAT_percMEAN_DSM=CAT_percMEAN_DSM+((confusion_matrix).*100./str2num(sub(isub).Nrun));
    CAT_all_accuracy(counter_line+1,1)= accuracy;
end
if sum(isub==CB1)==1
    CB1_confusion_matrix=CB1_confusion_matrix + confusion_matrix;
    CB1_percMEAN_DSM=CB1_percMEAN_DSM+((confusion_matrix).*100./str2num(sub(isub).Nrun));
    CB1_all_accuracy(counter_line+1,1)= accuracy;
end
if sum(isub==CB2)==1
    CB2_confusion_matrix=CB2_confusion_matrix + confusion_matrix;
    CB2_percMEAN_DSM=CB2_percMEAN_DSM+((confusion_matrix).*100./str2num(sub(isub).Nrun));
    CB2_all_accuracy(counter_line+1,1)= accuracy;
end
counter_line=counter_line+1;

end %isub

%%To create the group mean matrices divide by the numb of participants
CON_confusion_matrix=CON_confusion_matrix/length(CON);
CAT_confusion_matrix=CAT_confusion_matrix/length(CAT); 
CB1_confusion_matrix=CB1_confusion_matrix/length(CB1);
CB2_confusion_matrix=CB2_confusion_matrix/length(CB2);

% limits=[0 40];

%%visualize the mean matrices
figure();

    classes={'1','2','3','4','5','6'};
%%CON matrix
CON_sum_diag=sum(diag(CON_confusion_matrix));
CON_sum_total=sum(CON_confusion_matrix(:));
CON_accuracy=CON_sum_diag/CON_sum_total;

CON_percMEAN_DSM= CON_percMEAN_DSM/length(CON);

subplot(2,2,1);
    imagesc(CON_percMEAN_DSM)
    classifier_name='lda'; % no underscores
    desc=sprintf('CON  %s: accuracy %.1f%%', classifier_name, CON_accuracy*100);
    title(desc)    
    nclasses=numel(classes);
    set(gca,'XTick',1:nclasses,'XTickLabel',classes);
    set(gca,'YTick',1:nclasses,'YTickLabel',classes);
    ylabel('target');
    xlabel('predicted');
    colorbar
%     caxis(limits);    
%%SCEB matrix        
CAT_sum_diag=sum(diag(CAT_confusion_matrix));
CAT_sum_total=sum(CAT_confusion_matrix(:));
CAT_accuracy=CAT_sum_diag/CAT_sum_total;

CAT_percMEAN_DSM= CAT_percMEAN_DSM/length(CAT);
subplot(2,2,2);
    imagesc(CAT_percMEAN_DSM)
    classifier_name='lda'; % no underscores
    desc=sprintf('CAT  %s: accuracy %.1f%%', classifier_name, CAT_accuracy*100);
    title(desc)

    nclasses=numel(classes);
    set(gca,'XTick',1:nclasses,'XTickLabel',classes);
    set(gca,'YTick',1:nclasses,'YTickLabel',classes);
    ylabel('target');
    xlabel('predicted');
    colorbar
% caxis(limits);
%%CB1 matrix  

CB1_sum_diag=sum(diag(CB1_confusion_matrix));
CB1_sum_total=sum(CB1_confusion_matrix(:));
CB1_accuracy=CB1_sum_diag/CB1_sum_total;

CB1_percMEAN_DSM= CB1_percMEAN_DSM/length(CB1);
subplot(2,2,3);
    imagesc(CB1_percMEAN_DSM)
    classifier_name='lda'; % no underscores
    desc=sprintf('CB1  %s: accuracy %.1f%%', classifier_name, CB1_accuracy*100);
    title(desc);
   
    nclasses=numel(classes);
    set(gca,'XTick',1:nclasses,'XTickLabel',classes);
    set(gca,'YTick',1:nclasses,'YTickLabel',classes);
    ylabel('target');
    xlabel('predicted');
    colorbar
%     caxis(limits);
%%SCEB matrix        
CB2_sum_diag=sum(diag(CB2_confusion_matrix));
CB2_sum_total=sum(CB2_confusion_matrix(:));
CB2_accuracy=CB2_sum_diag/CB2_sum_total;

CB2_percMEAN_DSM= CB2_percMEAN_DSM/length(CB2);
subplot(2,2,4);
    imagesc(CB2_percMEAN_DSM)
    classifier_name='lda'; % no underscores
    desc=sprintf('CB2  %s: accuracy %.1f%%', classifier_name, CB2_accuracy*100);
    title(desc)

    nclasses=numel(classes);
    set(gca,'XTick',1:nclasses,'XTickLabel',classes);
    set(gca,'YTick',1:nclasses,'YTickLabel',classes);
    ylabel('target');
    xlabel('predicted');
    colorbar
    %caxis(limits);
% %     all_accuracy =[VC_all_accuracy(1:16);SC_all_accuracy(17:33);LB_all_accuracy(34:49)];

%%save 
save(strcat(output_path,'/',ROIs_name,'_',CAT_NAME,'_lda80vx'));
end %nCAT
end %nROI

function [sub] = pm_data

%CONTROL_original exp
sub(1).id      =    'CON_EsEn';
sub(1).Nrun    =    '4';
sub(1).folder  =    'spmT_4D_files';

sub(2).id      =    'CON_MoJa' ;
sub(2).Nrun    =    '5';
sub(2).folder  =    'spmT_4D_files';

sub(3).id      =    'CON_CoLi' ;
sub(3).Nrun    =    '5';
sub(3).folder  =    'spmT_4D_files';

sub(4).id      =    'CON_LuNg' ;
sub(4).Nrun    =    '5';
sub(4).folder  =    'spmT_4D_files';

sub(5).id      =    'CON_HeTr';
sub(5).Nrun    =    '5';
sub(5).folder  =    'spmT_4D_files';

sub(6).id      =    'CON_OlCo' ;
sub(6).Nrun    =    '5';
sub(6).folder  =    'spmT_4D_files';

sub(7).id      =    'CON_ThBa' ;
sub(7).Nrun    =    '5';
sub(7).folder  =    'spmT_4D_files';

sub(8).id      =    'CON_JoAb' ;
sub(8).Nrun    =    '5';
sub(8).folder  =    'spmT_4D_files';

sub(9).id      =    'CON_ShZh';
sub(9).Nrun    =    '5';
sub(9).folder  =    'spmT_4D_files';

sub(10).id      =    'CON_StMa' ;
sub(10).Nrun    =    '5';
sub(10).folder  =    'spmT_4D_files';

sub(11).id      =    'CON_MoKa' ;
sub(11).Nrun    =    '5';
sub(11).folder  =    'spmT_4D_files';

sub(12).id      =    'CON_AlSo' ;
sub(12).Nrun    =    '5';
sub(12).folder  =    'spmT_4D_files';

sub(13).id      =    'CON_MaTv';
sub(13).Nrun    =    '5';
sub(13).folder  =    'spmT_4D_files';

sub(14).id      =    'CON_FlFe' ;
sub(14).Nrun    =    '5';
sub(14).folder  =    'spmT_4D_files';

sub(15).id      =    'CON_XiGa' ;
sub(15).Nrun    =    '5';
sub(15).folder  =    'spmT_4D_files';

sub(16).id      =    'CON_BrCh' ;
sub(16).Nrun    =    '5';
sub(16).folder  =    'spmT_4D_files';

sub(17).id      =    'CON_MoRe';
sub(17).Nrun    =    '5';
sub(17).folder  =    'spmT_4D_files';

%CATARACT subJECTS


sub(18).id      =    'CAT_MiDo' ;
sub(18).Nrun    =    '5';
sub(18).folder  =    'spmT_4D_files';

sub(19).id      =    'CAT_JeSu' ;
sub(19).Nrun    =    '5';
sub(19).folder  =    'spmT_4D_files';

sub(20).id      =    'CAT_JeBr' ;
sub(20).Nrun    =    '5';
sub(20).folder  =    'spmT_4D_files';

sub(21).id      =    'CAT_WiSn';
sub(21).Nrun    =    '5';
sub(21).folder  =    'spmT_4D_files';

sub(22).id      =    'CAT_ZaCr' ;
sub(22).Nrun    =    '5';
sub(22).folder  =    'spmT_4D_files';

sub(23).id      =    'CAT_JoSn' ;
sub(23).Nrun    =    '5';
sub(23).folder  =    'spmT_4D_files';

sub(24).id      =    'CAT_AlBo' ;
sub(24).Nrun    =    '5';
sub(24).folder  =    'spmT_4D_files';

sub(25).id      =    'CAT_CaBa' ;
sub(25).Nrun    =    '5';
sub(25).folder  =    'spmT_4D_files';

sub(26).id      =    'CAT_CaPi' ;
sub(26).Nrun    =    '5';
sub(26).folder  =    'spmT_4D_files';

sub(27).id      =    'CAT_NaAs' ;
sub(27).Nrun    =    '5';
sub(27).folder  =    'spmT_4D_files';

sub(28).id      =    'CAT_AdCa' ;
sub(28).Nrun    =    '5';
sub(28).folder  =    'spmT_4D_files';

sub(29).id      =    'CAT_JeOn' ;
sub(29).Nrun    =    '5';
sub(29).folder  =    'spmT_4D_files';

sub(30).id      =    'CAT_MiMo' ;
sub(30).Nrun    =    '5';
sub(30).folder  =    'spmT_4D_files';

sub(31).id      =    'CAT_SaAt' ;
sub(31).Nrun    =    '5';
sub(31).folder  =    'spmT_4D_files';

sub(32).id      =    'CAT_ViOn' ;
sub(32).Nrun    =    '5';
sub(32).folder  =    'spmT_4D_files';

%CONTROL BLURRY 1 (C1B) : 20on60
sub(33).id      =    'C1B_AiSu' ;
sub(33).Nrun    =    '5';
sub(33).folder  =    'spmT_4D_files';

sub(34).id      =    'C1B_AkNa';
sub(34).Nrun    =    '4';
sub(34).folder  =    'spmT_4D_files';

sub(35).id      =    'C1B_AlLe' ;
sub(35).Nrun    =    '5';
sub(35).folder  =    'spmT_4D_files';

sub(36).id      =    'C1B_AlWa' ;
sub(36).Nrun    =    '5';
sub(36).folder  =    'spmT_4D_files';

sub(37).id      =    'C1B_AmPa' ;
sub(37).Nrun    =    '5';
sub(37).folder  =    'spmT_4D_files';

sub(38).id      =    'C1B_ArGr' ;
sub(38).Nrun    =    '5';
sub(38).folder  =    'spmT_4D_files';

sub(39).id      =    'C1B_DaDa' ;
sub(39).Nrun    =    '5';
sub(39).folder  =    'spmT_4D_files';

sub(40).id      =    'C1B_EvLe' ;
sub(40).Nrun    =    '5';
sub(40).folder  =    'spmT_4D_files';

sub(41).id      =    'C1B_JeJo' ;
sub(41).Nrun    =    '4';
sub(41).folder  =    'spmT_4D_files';

sub(42).id      =    'C1B_JiFe' ;
sub(42).Nrun    =    '4';
sub(42).folder  =    'spmT_4D_files';

sub(43).id      =    'C1B_JiHa' ;
sub(43).Nrun    =    '5';
sub(43).folder  =    'spmT_4D_files';

sub(44).id      =    'C1B_KeBe';
sub(44).Nrun    =    '5';
sub(44).folder  =    'spmT_4D_files';

sub(45).id      =    'C1B_MaGa' ;
sub(45).Nrun    =    '5';
sub(45).folder  =    'spmT_4D_files';

sub(46).id      =    'C1B_ViLe' ;
sub(46).Nrun    =    '4';
sub(46).folder  =    'spmT_4D_files';

%CONTROL BLURRY 2 (C2B) : 20on120
sub(47).id      =    'C2B_AiSu' ;
sub(47).Nrun    =    '5';
sub(47).folder  =    'spmT_4D_files';

sub(48).id      =    'C2B_AkNa';
sub(48).Nrun    =    '4';
sub(48).folder  =    'spmT_4D_files';

sub(49).id      =    'C2B_AlLe' ;
sub(49).Nrun    =    '4';
sub(49).folder  =    'spmT_4D_files';

sub(50).id      =    'C2B_AlWa' ;
sub(50).Nrun    =    '4';
sub(50).folder  =    'spmT_4D_files';

sub(51).id      =    'C2B_AmPa' ;
sub(51).Nrun    =    '4';
sub(51).folder  =    'spmT_4D_files';

sub(52).id      =    'C2B_ArGr' ;
sub(52).Nrun    =    '5';
sub(52).folder  =    'spmT_4D_files';

sub(53).id      =    'C2B_DaDa' ;
sub(53).Nrun    =    '4';
sub(53).folder  =    'spmT_4D_files';

sub(54).id      =    'C2B_EvLe' ;
sub(54).Nrun    =    '4';
sub(54).folder  =    'spmT_4D_files';

sub(55).id      =    'C2B_JeJo' ;
sub(55).Nrun    =    '4';
sub(55).folder  =    'spmT_4D_files';

sub(56).id      =    'C2B_JiFe' ;
sub(56).Nrun    =    '4';
sub(56).folder  =    'spmT_4D_files';

sub(57).id      =    'C2B_JiHa' ;
sub(57).Nrun    =    '4';
sub(57).folder  =    'spmT_4D_files';

sub(58).id      =    'C2B_KeBe';
sub(58).Nrun    =    '4';
sub(58).folder  =    'spmT_4D_files';

sub(59).id      =    'C2B_MaGa' ;
sub(59).Nrun    =    '4';
sub(59).folder  =    'spmT_4D_files';

sub(60).id      =    'C2B_ViLe' ;
sub(60).Nrun    =    '4';
sub(60).folder  =    'spmT_4D_files';
end