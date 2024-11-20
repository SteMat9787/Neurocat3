%% fMRI searchlights with representational similarity analysis

% NEDEED:
% - using CosmoMVPA
% - 1 spmT 4D files with betas/pattern of activities for each condition
% - brain mask do define where to run the searchlight

clear all;
global sub

sub=pm_data;


CON=1:17;
CAT=18:32;
C1B=33:46;
C2B=47:60;
no_sub= [CON,CAT,C1B,C2B];



%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Define data
study_path= fileparts(cd);;

%%Load the brain mask for the RSA searchlight
mask_fn=fullfile(study_path,'masks/rMASK_mni.nii');% whole brain mask

%Load the models you want to use as targets: HmaxC1 aand Categorical
models_path= fullfile(study_path,'RSA_searchlight/matrici_30');


%%Models to use as targets in the RSA searchlight:
%load(fullfile(models_path,'HmaxC1_DSM.mat'));
DSM_models= {'CATEGORICAL_5_CAT','HmaxC1_DSM'};
load(fullfile(models_path,'CATEGORICAL_5_CAT.mat'));
load(fullfile(models_path,'HmaxC1_DSM.mat'));

%define the correlation measure you want to use (%Pearson, Spearman,
%Kendal...)
corr_measure='Spearman';
disp(strcat('YOU ARE USING THIS MEASURE:',corr_measure));



for DSM=1:length(DSM_models) %create a loop for the 2 models
    disp(strcat('target DSM is:',DSM_models{DSM}))
    for isub = no_sub
        
        
        sub_name=(sub(isub).id);
        n_run=str2double(sub(isub).Nrun); % open if the 4D file has 150 pattern (30 stimuli per 5 runs) values
        %n_run=1;%%this is if the 4D file is already with 30 patterns values (run already averaged)
        
        
        data_fn=fullfile(study_path,'spmT_4D_files/spmT_4D_MReye',strcat(sub_name,'_spmT_4D_MVPA_MReye.nii'));
        targets=repmat(1:30,1,n_run)';
        ds = cosmo_fmri_dataset(data_fn, ...
            'mask',mask_fn,...
            'targets',targets);
        
        %OPEN ONLY IF THE 4D FILE has 150 BETA VALUES
        % compute average for each unique target, so that the dataset has 30
        % samples - one for each target
        ds=cosmo_fx(ds, @(x)mean(x,1), 'targets', 1);
        
        ds= cosmo_remove_useless_data(ds);
        
        %% Set items and categories
        ds.sa.labels = {'BODY_1','BODY_2','BODY_3','BODY_4','BODY_5','BODY_6',...
            'FACE_1','FACE_2','FACE_3','FACE_4','FACE_5','FACE_6',...
            'HOUSE_1','HOUSE_2','HOUSE_3','HOUSE_4','HOUSE_5','HOUSE_6',...
            'TOOL_1','TOOL_2','TOOL_3','TOOL_4','TOOL_5','TOOL_6',...
            'WORD_1','WORD_2','WORD_3','WORD_4','WORD_5','WORD_6'}';
        
        % simple sanity check to ensure all attributes are set properly
        cosmo_check_dataset(ds);
        
        % print dataset
        fprintf('Dataset input:\n');
        cosmo_disp(ds);
        
        %% Define feature neighorhoods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % For the searchlight, define neighborhood for each feature (voxel).
        nvoxels_per_searchlight=100;
        
        % The neighborhood defined here is used three times (one for each target
        % similarity matrix), so it is not recomputed for every searchlight call.
        fprintf('Defining neighborhood for each feature\n');
        nbrhood=cosmo_spherical_neighborhood(ds,'count',nvoxels_per_searchlight);
        
        % print neighborhood
        fprintf('Searchlight neighborhood definition:\n');
        cosmo_disp(nbrhood);
        
        %% Simple RSM searchlight
        nsamples = size(ds.samples,1);
        target_dsm = zeros(nsamples);
        regress_dsm = zeros(nsamples);
        
        %% set the target and the model to regress out
        
        if DSM==1
            disp(strcat('TARGET DSM:',DSM_models{DSM},'- REGRESS DSM:',DSM_models{2}))
            target_dsm=CATEGORICAL_5_CAT;
            regress_dsm=HmaxC1_DSM;
            
        elseif DSM==2
            disp(strcat('TARGET DSM:',DSM_models{DSM},'- REGRESS DSM:',DSM_models{1}))
            target_dsm = HmaxC1_DSM;
            regress_dsm=CATEGORICAL_5_CAT;
        end
        
        % set measure
        measure=@cosmo_target_dsm_corr_measure;
        measure_args=struct();
        measure_args.target_dsm=target_dsm;
        measure_args.regress_dsm=regress_dsm
        measure_args.metric='correlation';
        measure_args.type = corr_measure;
        
        % Enable centering the data
        measure_args.center_data=true;
        
        % print measure and arguments
        fprintf('Searchlight measure:\n');
        cosmo_disp(measure);
        fprintf('Searchlight measure arguments:\n');
        cosmo_disp(measure_args);
        
        % run searchlight
        ds_sa=cosmo_searchlight(ds,nbrhood,measure,measure_args);
        
        % to do Fisher transform (good for group analysis), do
        ds_sa.samples=atanh(ds_sa.samples);
        
        
        % store results
        ds_map=cosmo_slice(ds_sa,1);
        output_path = fullfile(study_path,'/RSA_searchlight/results');
        if DSM==1 %target_DSM==Categorical
            output_fn=fullfile([output_path],strcat(sub_name,'_RSA_NeuroCat3_CATregHmaxC1_001.nii'));
        elseif DSM==2
            output_fn=fullfile([output_path],strcat(sub_name,'_RSA_NeuroCat3_HmaxC1regCAT_002.nii'));
        end
        cosmo_map2fmri(ds_map,output_fn);
        
    end
    
end


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