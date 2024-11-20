%% Intra-brain RSA
%


% #   For CoSMoMVPA's copyright information and license terms,   #
% #   see the COPYING file distributed with CoSMoMVPA.           #

clear all;


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


%%%%%% this sub has to be excluded %%%%%%%%%
sub(16).id      =    'CON_BrCh' ;
sub(16).Nrun    =    '5';
sub(16).folder  =    'spmT_4D_files';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%% this sub has to be excluded %%%%%%%%%
sub(27).id      =    'CAT_NaAs' ;
sub(27).Nrun    =    '5';
sub(27).folder  =    'spmT_4D_files';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%% This sub has to be excluded %%%%%
sub(42).id      =    'C1B_JiFe' ;
sub(42).Nrun    =    '4';
sub(42).folder  =    'spmT_4D_files';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%%%%%%%%% This sub has to be excluded %%%%%
sub(56).id      =    'C2B_JiFe' ;
sub(56).Nrun    =    '4';
sub(56).folder  =    'spmT_4D_files';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

CON=1:17;
CAT=18:32;
C1B=33:46;
C2B=47:60;

no_sub= [CAT,CON,C1B,C2B];
%% Define data
study_path = fileparts(cd);%'/data/NeuroCat3/MULTIVARIATE';

output_path=fullfile(study_path,'Extract_BrainDSM/BrainDSM_dataCent_MReye');

mask_path = fullfile(study_path,'/masks/Sub_ROIs_MReyeResults/RSA');
data_fn_path= fullfile(study_path,'spmT_4D_files/spmT_4D_MReye');

% These masks are to recreate the extract the RDMs visualized in figure 5, panels A-B-C-D
masks={'Mask_CON_HmaxC1regCAT_05FWE','Mask_CAT_HmaxC1regCAT_05FWE','Mask_CB1_HmaxC1regCAT_05FWE','Mask_CB2_HmaxC1regCAT_05FWE',...
    'Mask_CON_CAT5regHmaxC1_05FWE','Mask_CAT_CAT5regHmaxC1_05FWE','Mask_CB1_CAT5regHmaxC1_05FWE','Mask_CB2_CAT5regHmaxC1_05FWE'}

% These masks are to recreate the extract the RDMs visualized in figure 5, panels E-F-G-I-L
%  masks={'Mask_RSAhmaxC1_CON>CAT_TFCE-05FWE',...
%      'Mask_RSAhmaxC1_CON>CB1_TFCE05FWE_MASK-V1','Mask_RSACateg5_CON>CB1_TFCE05FWE_MASK-FGall',...
%      'Mask_RSAhmaxC1_CON>CB2_TFCE05FWE_MASK-V1','Mask_RSACateg5_CON>CB2_TFCE05FWE_MASK-FGall',...
%      'Mask_RSACateg5_CAT>CB1_TFCE05FWE_MASK-FGall',...
%      'Mask_RSACateg5_CAT>CB2_TFCE05FWE_MASK-FGall'};

center_data=1;


output_path=fullfile(study_path,'Extract_BrainDSM/BrainDSM_dataCent_MReye');


for mask_num=1:length(masks)
    pecora=1;%start the counter
for isub =no_sub
    
    sub_name=  sub(isub).id;
    n_run=str2double(sub(isub).Nrun); %%open if the 4D file has 150 values
    %n_run=1; %% this is for 4D file with 30 values


data_fn=fullfile(data_fn_path ,strcat(sub_name,'_spmT_4D_MVPA_MReye.nii'));
%%select the mask for each sub
mask_fn=fullfile(mask_path,strcat(masks{mask_num},'.img'));


targets=repmat(1:30,1,n_run)';

ds = cosmo_fmri_dataset(data_fn, ...
                            'mask',mask_fn,...
                        'targets',targets);


% compute average for each unique target, so that the dataset has 24
% samples - one for each target
ds=cosmo_fx(ds, @(x)mean(x,1), 'targets', 1);


% remove constant features
ds=cosmo_remove_useless_data(ds);

%% Set animal species & class
    ds.sa.labels = {'BODY_1','BODY_2','BODY_3','BODY_4','BODY_5','BODY_6',...
    'FACE_1','FACE_2','FACE_3','FACE_4','FACE_5','FACE_6',...
    'HOUSE_1','HOUSE_2','HOUSE_3','HOUSE_4','HOUSE_5','HOUSE_6',...
    'TOOL_1','TOOL_2','TOOL_3','TOOL_4','TOOL_5','TOOL_6',...
    'WORD_1','WORD_2','WORD_3','WORD_4','WORD_5','WORD_6'}';
% simple sanity check to ensure all attributes are set properly
cosmo_check_dataset(ds);

 % %   if center_data==1, then subtract the mean first
    samples=ds.samples;
    if center_data==1
        samples=bsxfun(@minus,samples,mean(samples,1));
    end

% Use pdist (or cosmo_pdist) with 'correlation' distance to get DSMs
% in vector form. Assign the result to 'Heschl_dsm' 

dsm=pdist(samples,'correlation');


%store the data of each subject in his/her own group
if sum(isub==CON)==1
    line= find(isub==CON);
    CON_vec(line,:) = dsm;
end
if sum(isub==CAT)==1
    line= find(isub==CAT);
    CAT_vec(line,:) = dsm;
end
if sum(isub==C1B)==1
    line= find(isub==C1B);
    C1B_vec(line,:) = dsm;
end

if sum(isub==C2B)==1
    line= find(isub==C2B);
    C2B_vec(line,:) = dsm;
end

all_VEC(pecora,:)=dsm;
pecora=pecora+1; %add a nuber to the counter
end

cd (output_path)
% %%Save the mat fil with all the CON's brain DSMs
meanCON_dsm = mean(CON_vec);
meanVEC= meanCON_dsm;%create a mean vector of all the sub values
meanCON_dsm = squareform (meanCON_dsm); %give the matrix form to the mean vector
save ((strcat('CON_',masks{mask_num},'_dsm.mat')),'CON_vec','meanCON_dsm','meanVEC');
%%Save the mat fil with all the CAT's brain DSMs
meanCAT_dsm = mean(CAT_vec); %create a mean vector of all the sub values
meanVEC= meanCAT_dsm;
meanCAT_dsm = squareform (meanCAT_dsm); %give the matrix form to the mean vector
save ((strcat('CAT_',masks{mask_num},'_dsm.mat')),'CAT_vec','meanCAT_dsm','meanVEC');

%%Save the mat fil with all the C1B's brain DSMs
meanC1B_dsm = mean(C1B_vec); %create a mean vector of all the sub values
meanVEC= meanC1B_dsm;
meanC1B_dsm = squareform (meanC1B_dsm); %give the matrix form to the mean vector
save ((strcat('C1B_',masks{mask_num},'._dsm.mat')),'C1B_vec','meanC1B_dsm','meanVEC');

%%Save the mat fil with all the C2B's brain DSMs
meanC2B_dsm = mean(C2B_vec); %create a mean vector of all the sub values
meanVEC= meanC2B_dsm;
meanC2B_dsm = squareform (meanC2B_dsm); %give the matrix form to the mean vector
save ((strcat('C2B_',masks{mask_num},'._dsm.mat')),'C2B_vec','meanC2B_dsm','meanVEC');


%%Save the mat fil with all the Groups brain DSMs
save ((strcat('ALL_',masks{mask_num},'_dsm.mat')),'all_VEC');
cd (study_path)

%%Plot the mean RDMs
labels={'BODY','FACE','HOUSE','TOOL','WORD'};
figure(); subplot(2,2,1); imagesc(mat2gray(meanCON_dsm)); colorbar;title('CON');
set(gca, 'YTick',(3:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3:6:30),'XTickLabel',labels);
subplot(2,2,2); imagesc(mat2gray(meanCAT_dsm)); colorbar;title('CAT');
set(gca, 'YTick',(3:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3:6:30),'XTickLabel',labels);
subplot(2,2,3); imagesc(mat2gray(meanC1B_dsm)); colorbar;title('C1B');
set(gca, 'YTick',(3:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3:6:30),'XTickLabel',labels);
subplot(2,2,4); imagesc(mat2gray(meanC2B_dsm)); colorbar;title('C2B');
set(gca, 'YTick',(3:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3:6:30),'XTickLabel',labels);
suptitle(masks(mask_num));
end


