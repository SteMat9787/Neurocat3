
%load here the .mat file
load 'ALL_Mask_RSACateg5_CON>CB1_TFCE05FWE_MASK-FGall_dsm.mat';

%define the groups
CON=[1:15,17];
CAT=[18:26,28:32];
CB1=[33:41,43:46];
CB2=[47:55,57:60];

%normalize the vectors between 0 and 1 (all group together)
% all_VEC_norm=mat2gray(all_VEC);


%separate each group
CON_VEC=all_VEC(CON,:);
CAT_VEC=all_VEC(CAT,:);
CB1_VEC=all_VEC(CB1,:);
CB2_VEC=all_VEC(CB2,:);

%create the average vector for each group
CON_VEC_mean=mean(CON_VEC);
CAT_VEC_mean=mean(CAT_VEC);
CB1_VEC_mean=mean(CB1_VEC);
CB2_VEC_mean=mean(CB2_VEC);

%normalize the 4 vectors together
all_VECmean=[CON_VEC_mean;CAT_VEC_mean;CB1_VEC_mean;CB2_VEC_mean];
all_VECmean_norm=mat2gray(all_VECmean);
CON_VEC_norm_mean=all_VECmean_norm(1,:);
CAT_VEC_norm_mean=all_VECmean_norm(2,:);
CB1_VEC_norm_mean=all_VECmean_norm(3,:);
CB2_VEC_norm_mean=all_VECmean_norm(4,:);

%plot the mean group DSMs
   labels={'B','F','H','T','W'};
   %labels={'BODY','FACE','HOUSE','TOOL','WORD'};
    labels_all = {'BODY_1','BODY_2','BODY_3','BODY_4','BODY_5','BODY_6',...
    'FACE_1','FACE_2','FACE_3','FACE_4','FACE_5','FACE_6',...
    'HOUSE_1','HOUSE_2','HOUSE_3','HOUSE_4','HOUSE_5','HOUSE_6',...
    'TOOL_1','TOOL_2','TOOL_3','TOOL_4','TOOL_5','TOOL_6',...
    'WORD_1','WORD_2','WORD_3','WORD_4','WORD_5','WORD_6'}';

%% To visualize the matrices
 clims=[0 1];
 %clims=[min(min(all_VEC_norm)) max(max(all_VEC_norm)) ]
 
figure();
set(gcf,'color','w');

%CON
subplot(2,2,1); imagesc((squareform(CON_VEC_norm_mean)),clims);colorbar;
set(gca, 'YTick',(3.5:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3.5:6:30),'XTickLabel',labels);
set(gca,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
       'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
 %   xtickangle(45);
  colorbar;

set(colorbar,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
       'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0]);
title 'CON'

%CAT
subplot(2,2,2); imagesc((squareform(CAT_VEC_norm_mean)),clims); colorbar;
set(gca, 'YTick',(3.5:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3.5:6:30),'XTickLabel',labels);
set(gca,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
    'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
% xtickangle(45);

% ax=colorbar;
set(colorbar,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
    'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0]);
%xtickangle(45);
title 'CAT'

%CB1
subplot(2,2,3); imagesc((squareform(CB1_VEC_norm_mean)),clims); colorbar;
set(gca, 'YTick',(3.5:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3.5:6:30),'XTickLabel',labels);
set(gca,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
    'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
%xtickangle(45);

% ax=colorbar;
set(colorbar,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
    'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0]);
%xtickangle(45);
title 'CB1'

%CB2
subplot(2,2,4); imagesc((squareform(CB2_VEC_norm_mean)),clims); colorbar;
set(gca, 'YTick',(3.5:6:30),'YTickLabel',labels);
set(gca, 'XTick',(3.5:6:30),'XTickLabel',labels);
set(gca,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
    'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
%xtickangle(45);
DataAspectRatio=[1,1,1];

% ax=colorbar;
set(colorbar,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
    'LineWidth',3.5,'TickDir','out', 'TickLength', [0,0]);
%xtickangle(45);
title 'CB2'
