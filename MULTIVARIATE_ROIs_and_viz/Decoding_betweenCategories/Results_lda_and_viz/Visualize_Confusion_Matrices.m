%% This script visualizes the confusion matricees of the 4 groups/conditions (Controls, Cataracct-reversals, ConBlurry1 & ConBlurry2) for each ROI

%% load the file/contrast you want to visualize
% load('CON_MaskSearchlight_05FWE_250bestvx.mat');%to plot matrix in figure SI2 panel A
% load('CAT_MaskSearchlight_05FWE_250bestvx.mat');%to plot matrix in figure SI2 panel B
load('CB1_MaskSearchlight_05FWE_250bestvx'); % to plot matrix in figure SI2 panel C
% load('CB2_MaskSearchlight_05FWE_250bestvx.mat'); %to plot matrix in figure SI2 panel D

% load('CON>CB1_MaskFGall_fromSearchlight_250bestvx.mat');%to plot matrices in figure SI2 panel E
% load('CON>CB2_MaskFGall_fromSearchlight_250bestvx.mat');%to plot matrices in figure SI2 panel F
% load('CAT>CB1_MaskFGall_fromSearchlight_250bestvx.mat'); % to plot matrices in figure SI2 panel G
% load('CAT>CB2_MaskFGall_fromSearchlight_250bestvx.mat'); %to plot matrices in figure SI2 panel H


% Define labels and limits
labels={'B','F','H','T','W'};
% labels={'BODIES','FACES','HOUSES','TOOLS','WORDS'};
clims=[0,80];%limits for the colorbar level
%CON group
figure(1);
set(gcf,'color','w');
imagesc(CON_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(CON_MEAN_confusion_matrix)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(CON_MEAN_confusion_matrix)),'XTickLabel',labels);
%xtickangle(45);
title 'CON: Confusion Matrix';
   ylabel('target');
 xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);
  


%CAT group
figure(2);
set(gcf,'color','w');
imagesc(CAT_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(CAT_MEAN_confusion_matrix)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(CAT_MEAN_confusion_matrix)),'XTickLabel',labels);
%xtickangle(45);
title 'CAT: Confusion Matrix';
   ylabel('target');
        xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);

%CB1 group
figure(3);
set(gcf,'color','w');
imagesc(C1B_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(C1B_MEAN_confusion_matrix)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(C1B_MEAN_confusion_matrix)),'XTickLabel',labels);
% xtickangle(45);
title 'CB1: Confusion Matrix';
   ylabel('target');
        xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);


%CB2 group
figure(4);
set(gcf,'color','w');
imagesc(C2B_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(C2B_MEAN_confusion_matrix)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(C2B_MEAN_confusion_matrix)),'XTickLabel',labels);
%xtickangle(45);
title 'CB2: Confusion Matrix';
   ylabel('target');
        xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);


