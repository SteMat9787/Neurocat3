%visualize confusion matrix plotted in figure 6

%load the data
load 'Mask_WORDS_CON>CB1_TFCE_05FWE_V1mask_word.mat';

% Define labels and limits
labels={'1','2','3','4','5','6'};
% labels={'BODIES','FACES','HOUSES','TOOLS','WORDS'};
clims=[0,80];%limits for the colorbar level
%CON group
figure(1);
set(gcf,'color','w');
imagesc(CON_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(CON_percMEAN_DSM)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(CON_percMEAN_DSM)),'XTickLabel',labels);
%xtickangle(45);
title 'CON: Confusion Matrix';
   ylabel('target');
 xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);
  


%CAT group
figure(2);
set(gcf,'color','w');
imagesc(CAT_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(CAT_percMEAN_DSM)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(CAT_percMEAN_DSM)),'XTickLabel',labels);
%xtickangle(45);
title 'CAT: Confusion Matrix';
   ylabel('target');
        xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);

%CB1 group
figure(3);
set(gcf,'color','w');
imagesc(CB1_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(CB1_percMEAN_DSM)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(CB1_percMEAN_DSM)),'XTickLabel',labels);
% xtickangle(45);
title 'CB1: Confusion Matrix';
   ylabel('target');
        xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);


%CB2 group
figure(4);
set(gcf,'color','w');
imagesc(CB2_percMEAN_DSM,clims);
set(gca, 'YTick',(1:1:length(CB2_percMEAN_DSM)),'YTickLabel',labels);
set(gca, 'XTick',(1:1:length(CB2_percMEAN_DSM)),'XTickLabel',labels);
%xtickangle(45);
title 'CB2: Confusion Matrix';
   ylabel('target');
        xlabel('predicted');
ax=gca;
set(ax,'FontName','Avenir','FontSize',35, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0],'DataAspectRatio', [1,1,1]);
colorbar;
ax=colorbar;
set(ax,'FontName','Avenir','FontSize',25, 'FontWeight','bold',...
       'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0]);


