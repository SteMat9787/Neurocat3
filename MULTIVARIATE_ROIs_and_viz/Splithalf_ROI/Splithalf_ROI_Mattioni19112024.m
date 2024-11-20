
% Roi-based MVPA for single subject (run_split_half_correlations_single_sub)
%
% Load t-stat data from one subject, apply brain mask (from searchlight), compute difference
% of (fisher-transformed) between on- and off diagonal split-half
% correlation values.
%
% #   For CoSMoMVPA's copyright information and license terms,   #
% #   see the COPYING file distributed with CoSMoMVPA.           #


clear all;
%% Set analysis parameters
global sub

sub=pm_data;


CON=1:17;
CAT=18:32;
C1B=33:46;
C2B=47:60;
no_sub= [CON,CAT,C1B,C2B];


% define data filenames & load data from even and odd runs
%config=cosmo_config();
study_path=fileparts(cd);

%%Load the brain mask for the RSA searchlight

masks_path = fullfile(study_path,'masks/Masks_fromSearchlight_Analyses/Splithalf');

%change this based on the mask that you want to select--> obtained from the
%serachllight analyses
mask_name='Mask_SplitHalf_CAT>C2B_TFCE05FWE_Mask-FGall.img';

name_output='bilFG_CAT>C2B';

mask_fn=fullfile(masks_path,mask_name);

%%set the putput folder path
output_path=fullfile(study_path,'Splithalf_ROI/results_splithalfROI');

%CATEGORIES={'body','face','house','tool','word'};
pecora=1; %set a counter
for isub = no_sub
    if isub==1||isub==18||isub==33||isub==47
        pecora=1;%set a counter for the first subject of each group
    end
    disp(strcat('processing SUB',num2str(isub),':',sub(isub).id));
    study_path_sub = fullfile(study_path,(sub(isub).folder)); %select the data in each folder (EB,LB;SC)
    sub_name=  (sub(isub).id);
    
    
    n_run=str2double(sub(isub).Nrun); % open if the 4D file has 150 beta
    
    if n_run==4
        targets_odd=repmat(1:30,1,2)';
    elseif n_run==5
        targets_odd=repmat(1:30,1,3)';
    end
    
    targets_even=repmat(1:30,1,2)';
    
    data_path=fullfile(study_path_sub);%,sub_name);
    half1_fn=strcat(data_path,'/',sub_name,'_spmT_4D_MVPA_oddRUNS_MReye.nii');
    half2_fn=strcat(data_path,'/',sub_name,'_spmT_4D_MVPA_evenRUNS_MReye.nii');
    
    
    %% Computations
    
    % load two halves as CoSMoMVPA dataset structs.
    half1_ds=cosmo_fmri_dataset(half1_fn,'mask',mask_fn,...
        'targets',targets_odd,...
        'chunks',1);
    half1_ds=cosmo_fx(half1_ds, @(x)mean(x,1), 'targets', 1);
    
    half2_ds=cosmo_fmri_dataset(half2_fn,'mask',mask_fn,...
        'targets',targets_even,...
        'chunks',2);
    half2_ds=cosmo_fx(half2_ds, @(x)mean(x,1), 'targets', 1);
    
    
    cosmo_check_dataset(half1_ds);
    cosmo_check_dataset(half2_ds);
    
    % Some sanity checks to ensure that the data has matching features (voxels)
    % and matching targets (conditions)
    assert(isequal(half1_ds.fa,half2_ds.fa));
    assert(isequal(half1_ds.sa.targets,half2_ds.sa.targets));
    
    nClasses=30; %number of item in my exp.
    
    % get the sample data
    % each half has six samples:
    % monkey, lemur, mallard, warbler, ladybug, lunamoth.
    half1_samples=half1_ds.samples;
    half2_samples=half2_ds.samples;
    
    % compute all correlation values between the two halves, resulting
    % in a 30X30 matrix. Store this matrix in a variable 'rho'.
    
    rho=cosmo_corr(half1_samples',half2_samples');
    
    % Correlations are limited between -1 and +1, thus they cannot be normally
    % distributed. To make these correlations more 'normal', apply a Fisher
    % transformation and store this in a variable 'z'
    z=atanh(rho);
    diagonal=diag(z);
    avg_diag=mean(diagonal);
    
    % sanity check: ensure the matrix has a sum of zero
    if abs(sum(contrast_matrix(:)))>1e-14
        error('illegal contrast matrix: it must have a sum of zero');
    end
    
    % Weigh the values in the matrix 'z' by those in the contrast_matrix
    % (hint: use the '.*' operator for element-wise multiplication).
    % Store the result in a variable 'weighted_z'.
    weighted_z=z .* contrast_matrix;
    
    % Compute the sum of all values in 'weighted_z', and store the result in
    % 'sum_weighted_z'.
    if strcmp (sub_name(1:3),'CON')
        sum_weighted_z_CON(pecora)=sum(weighted_z(:));%Expected value under H0 is 0
        avg_diag_CON(1,pecora)=avg_diag;
    elseif strcmp (sub_name(1:3),'CAT')
        sum_weighted_z_CAT(pecora)=sum(weighted_z(:));%Expected value under H0 is 0
        avg_diag_CAT(1,pecora)=avg_diag;
    elseif strcmp (sub_name(1:3),'C1B')
        sum_weighted_z_C1B(pecora)=sum(weighted_z(:)); %Expected value under H0 is 0
        avg_diag_C1B(1,pecora)=avg_diag;
    elseif strcmp (sub_name(1:3),'C2B')
        sum_weighted_z_C2B(pecora)=sum(weighted_z(:)); %Expected value under H0 is 0
        avg_diag_C2B(1,pecora)=avg_diag;
    end
    
    pecora=pecora+1; %increase the counter
    
    
end
sum_weighted_z_CON=sum_weighted_z_CON';
sum_weighted_z_CAT=sum_weighted_z_CAT';
sum_weighted_z_C1B=sum_weighted_z_C1B';
sum_weighted_z_C2B=sum_weighted_z_C2B';

save(strcat(output_path,'/SplithalfROI_',name_output),'sum_weighted_z_CON','sum_weighted_z_CAT','sum_weighted_z_C1B','sum_weighted_z_C2B',...
    'avg_diag_CON','avg_diag_CAT','avg_diag_C1B','avg_diag_C2B');

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