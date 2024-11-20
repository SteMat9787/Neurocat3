%% fMRI decoding within each category (boddy, face, house, tool, word) betweeen 6 items - searchlight LDA classifier
%
%To run decoding with LDA classifier, crossvalidation method

% NEDEED:
% - using CosmoMVPA
% - 1 spmT 4D files with betas/pattern of activities for each condition and
% run
% - brain mask do define where to run the searchlight 
%
% #   For CoSMoMVPA's copyright information and license terms,   #
% #   see the COPYING file distributed with CoSMoMVPA.           #

clear all;

%% Set the subjects info and define groups
global sub

sub=pm_data; %function at the end of this script

CON=1:17;
CAT=18:32;
C1B=33:46;
C2B=47:60;
no_sub= [CON,CAT,C1B,C2B];



%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Define data
%config=cosmo_config();
study_path= fileparts(cd);%'/data/NeuroCat3/MULTIVARIATE';
masks_path = fullfile(study_path,'masks');

%mask_fn=fullfile(study_path,'rMASK_mni.nii');% whole brain mask
mask_fn=fullfile(masks_path,'rMASK_mni.nii');
%% Set data paths

output_path=fullfile(study_path,'MVPA_searchlight/results');

% reset citation list
cosmo_check_external('-tic');

%set the name of the categories
CATEGORIES={'body','face','house','tool','word'};

%% LDA classifier searchlight analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for nCAT=1:length(CATEGORIES) %the decoding is done for each category separately
    CAT_NAME=CATEGORIES{nCAT};
for isub = no_sub

    
    sub_name=(sub(isub).id);
    
    data_fn=fullfile(study_path,'spmT_4D_files/',strcat(sub_name,'_spmT_MVPA.nii'));
   
    %targets for 30 categories
    targets=repmat(1:30,1,1)';
    targets= sort(targets);
    targets=repmat(targets,str2num(sub(isub).Nrun),1);
     
%%chuncks
chunks=ceil((1:(30*str2num(sub(isub).Nrun)))/30)'; %chuncks is number of runs, 30== number of values per runs

 
ds = cosmo_fmri_dataset(data_fn, 'mask', mask_fn,...
                                'targets',targets,'chunks',chunks);

 % remove constant features (due to liberal masking)
ds=cosmo_remove_useless_data(ds);

% print dataset
fprintf('Dataset input:\n');
cosmo_disp(ds);

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

%Use the function cosmo_slice to only select the data related to the
%category if interests
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


% Use the cosmo_cross_validation_measure and set its parameters
% (classifier and partitions) in a measure_args struct.
measure = @cosmo_crossvalidation_measure;
measure_args = struct();

% Define which classifier to use, using a function handle.
% Alternatives are @cosmo_classify_{svm,matlabsvm,libsvm,nn,naive_bayes}
measure_args.classifier = @cosmo_classify_lda;

% Set partition scheme. odd_even is fast; for publication-quality analysis
% nfold_partitioner is recommended.
% Alternatives are:
% - cosmo_nfold_partitioner    (take-one-chunk-out crossvalidation)
% - cosmo_nchoosek_partitioner (take-K-chunks-out  "             ").
% measure_args.partitions = cosmo_oddeven_partitioner(ds);
measure_args.partitions = cosmo_nfold_partitioner(ds);
measure_args.normalization = 'zscore';
% print measure and arguments
fprintf('Searchlight measure:\n');
cosmo_disp(measure);
fprintf('Searchlight measure arguments:\n');
cosmo_disp(measure_args);

% Define a neighborhood with approximately 100 voxels in each searchlight.
nvoxels_per_searchlight=100;
nbrhood=cosmo_spherical_neighborhood(ds,...
                        'count',nvoxels_per_searchlight);


% Run the searchlight
lda_results = cosmo_searchlight(ds,nbrhood,measure,measure_args);

% print output dataset
fprintf('Dataset output:\n');
cosmo_disp(lda_results);

% Plot the output
cosmo_plot_slices(lda_results);

% Define output location
%output_fn=fullfile(output_path,'lda_searchlight+orig');
output_fn=fullfile(output_path,strcat(sub_name,'_lda_searchlight_MVPA_Neurocat3_WITHIN_',CATEGORIES{nCAT},'_MReye_.nii'));
% Store results to disc
cosmo_map2fmri(lda_results, output_fn);

% Show citation information
cosmo_check_external('-cite');
end %for isub

end %for nCAT

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
