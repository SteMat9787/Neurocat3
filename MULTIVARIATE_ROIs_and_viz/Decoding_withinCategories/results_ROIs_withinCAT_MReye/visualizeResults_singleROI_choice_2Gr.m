%Visualize the dotplots in figure 6 
load('Mask_WORDS_CON>CB2_TFCE_05FWE_V1mask_word.mat');

%title_string='VOTC&LOC - Decoding within cat - BODY';
title_string='Decoding within cat - BODIES';

Group_combo= 3;
%1=CON-CAT
%2=CON-CB1
%3=CON-CB2
%4=CAT-CB1
%5=CAT-CB2

    dataCAT=(CAT_all_accuracy(17:30))*100;

    dataCON=(CON_all_accuracy(1:16))*100;
    
    dataC1B=(CB1_all_accuracy(31:43))*100;

    dataC2B=(CB2_all_accuracy(44:56))*100;
    
    %%%set the color for each condition in RGB (and divide them by 256 to be matlab compatible)
    Col_A=[255 158 74]/256; %CON
    %Col_=[24 96 88]/256;%SCEB %darker version of ColA
    Col_B= [105 170 153]/256; %CAT
    Col_C=[159 111 209]/256;%C1B
    Col_D=[73 10 124]/256;%C2B
%     Col_C=[208 110 48]/256;%C1B %darker orange
%     Col_D=[162 50 16]/256;%C2B %even ddarker orange

    %I want to only include 2 groups. I use this loop to select the
    %correct data based on the group_combo I previously specified
if Group_combo==1
%1=CON-CAT
%2=CON-CB1
%3=CON-CB2
%4=CAT-CB1
%5=CAT-CB2
data=[dataCON,[dataCAT;0;0]];
XTickLabel={'CON','CAT'};
Colors=[Col_A;Col_B];
elseif Group_combo==2
data=[dataCON,[dataC1B;0;0;0]]; 
XTickLabel={'CON','CB1'}; %these go under each column
Colors=[Col_A;Col_C];
elseif Group_combo==3
data=[dataCON,[dataC2B;0;0;0]];
XTickLabel={'CON','CB2'}; %these go under each column
Colors=[Col_A;Col_D];
elseif Group_combo==4
data=[dataCAT,[dataC1B;0]]; 
XTickLabel={'CAT','CB1'}; %these go under each column
Colors=[Col_B;Col_C];
elseif Group_combo==5
data=[dataCAT,[dataC2B;0]]; 
XTickLabel={'CAT','CB2'}; %these go under each column
Colors=[Col_B;Col_D];
end %if group_combo


%data=[[dataCON],[dataCAT;0;0],[dataC1B;0;0;0], [dataC2B;0;0;0]];

%% make a dot plot taking into account the overlap/density of the plot. 
%%This script gives 2 possible solutions:

%%1.  Baloon dot plot: if the values  are closer than a treshold
%%value they will be merge in one marker. The size of the marker will
%%increase according to the number of values that it represents. 

%%2. Jittered dot plot: there will be one marker for each value. In case of
%%close/overlapping values, the markers will be jittered on the x axis. The
%%size of the marker will not change. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EVERYTHING TO BE SET IS HERE: 

% % set the density_distance for clustering (all the values that are
% % within the density distance will be plotted as one marker, the size
% % of the marker will increase according to the number of values that it
% % represents) 
density_distance=-0.1; %if not density clustering put 0 here

%%%%set jittering (normally to be used when the density clustering is not implemented)
jitterAmount=0.2;% for no jittering put 0 here (otherwise try 0.15/ to be adjusted according to the data)

%%set the size of the markers that represent one value
starting_size=2000; % in the density_plot this will be the smallest marker size (= 1 sub), in the jittered plot all the markers will be of this size


%%set the shape of the markers
%Here some possibilities
% 'o'	Circle
% '+'	Plus sign
% '*'	Asterisk
% '.'	Point
% 'x'	Cross
% 'square' or 's'	Square
% 'diamond' or 'd'	Diamond
% '^'	Upward-pointing triangle
% 'v'	Downward-pointing triangle
% '>'	Right-pointing triangle
% '<'	Left-pointing triangle
% 'pentagram' or 'p'	Five-pointed star (pentagram)
% 'hexagram' or 'h'	Six-pointed star (hexagram)
% 'none'	No markers
 shape='.';

%%set the width of the edge of the markers
LineWidthMarkers=3;
%%set the width of the edge of the mean line
LineWidthMean=8;
%%set the length of the mean line
LineLength=0.4; %the actual length will be the double of this value

%%set if you want filled or empty markers
% % % NB: Option to fill the interior of the markers, specified as 'filled'.
% % % Use this option with markers that have a face, for example, 'o' or 'square'.
% % %     Not fort Markers that do not have a face and contain only edges ('+', '*', '.', and 'x').

%filled=0; %0 if you want empty markers
filled=1; % 1 if you want filled markers

%%set if you want the error bars or not
error_bar=1; end_points=1; % with error bars with endpoints
%error_bar=1; end_points=0; % with error bars only one line (no endpoints)
%error_bar=0 %without error bars
% 
% %%%set the color for each condition in RGB (and divide them by 256 to be matlab compatible)
%     Col_A=[255 158 74]/256; %CON
%     %Col_=[24 96 88]/256;%SCEB %darker version of ColA
%     Col_B=[105 170 153]/256; %CAT
%     Col_C=[159 111 209]/256;%C1B
%     Col_D=[73 10 124]/256;%C2B
% %     Col_C=[208 110 48]/256;%C1B %darker orange
% %     Col_D=[162 50 16]/256;%C2B %even ddarker orange
% Colors=[Col_A;Col_B;Col_C;Col_D];

%%%set the transparency of the markers
Transparency=0.7;

%%set other characteristics of the graph
XTick= 1:2;
% XTickLabel={'CON','CAT','C1B','C2B'}; %these go under each column
xLim=[0,max(XTick)+1];
yMin= min(min(data));
yMax=max(max(data))+20;
% yLim=[yMin yMax]; %put here your xLim
yLim=[0 105]; %put here your xLim
FontName='Avenir'; %set the style of the labels
FontSize=55; %%set the size of the labels
Y_label='LDA Accuracy %'; %%write here your measure/label for y axis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%visualize data
figure()
set(gcf,'color','w'); %to have white background


for i_col=1:length(XTick)
    col= data(:,i_col);
    
    %eliminate the cell with zeros
    empty_cell=(col==0);
    col(empty_cell)=[];
    
    %call the function that average the values according to the density distance and
    %give as outputs the new vector and the size of each density cluster
    [new_vec,size]=compute_density(col,density_distance, starting_size);
    data_density=new_vec;
    [row] = length(data_density);
    xrow = repmat(i_col,row,1);
    %plot the marker for each sub (density clustered)
    if filled==0 %%for empty markers
        scatter(xrow(:), data_density(:),size, shape,'MarkerEdgeColor',Colors(i_col,:),'MarkerEdgeAlpha',Transparency,'LineWidth',LineWidthMarkers,'jitter','on', 'jitterAmount', jitterAmount);
    elseif filled==1 %%for filled markers
        scatter(xrow(:), data_density(:),size, shape,'filled','MarkerFaceColor',Colors(i_col,:),'MarkerEdgeColor',Colors(i_col,:),'MarkerEdgeAlpha',Transparency,'MarkerFaceAlpha',Transparency,'LineWidth',LineWidthMarkers,'jitter','on', 'jitterAmount', jitterAmount);
    end
    hold on;
    %%plot the mean
    plot([xrow(1,1)-LineLength; xrow(1,1) + LineLength], repmat(mean(col, 1), 2, 1),'LineWidth',LineWidthMean,'Color',Colors(i_col,:));
    
    if error_bar==1
    %%plot the st. err
    stDev=std(col); %compute the standard deviation
    stErr=stDev/sqrt(length(col)); %compute the standard error
    plot([xrow(1,1); xrow(1,1)], [mean(col)+stErr mean(col)-stErr],'k','LineWidth',3)%,'Color',Colors(i_col,:));
    %%plot the 2 small line at the endpoint of the error bar
    if end_points==1
    hold on
    plot([xrow(1,1)-0.05 xrow(1,1)+0.05],[mean(col)+stErr mean(col)+stErr],'k','LineWidth',3)%,'Color',Colors(i_col,:));
    hold on
    plot([xrow(1,1)-0.05 xrow(1,1)+0.05],[mean(col)-stErr mean(col)-stErr],'k','LineWidth',3)%,'Color',Colors(i_col,:));
    end %if end_points
    end %if error bar
    
     plot([xrow(1,1)-30 xrow(1,1)+30],[16.6667 16.6667],'k:','LineWidth',2)%,'Color',Colors(i_col,:));
    
     title (title_string);
end %for col(umns) number
ax=gca;
set(ax,'FontName',FontName,'FontSize',FontSize, 'FontWeight','bold',...
    'LineWidth',2.5,'TickDir','out', 'TickLength', [0,0],...
    'yLim',yLim,'xLim',xLim,'XTick', XTick,'XTickLabel', XTickLabel,'FontSize',FontSize);
% xlabel(['ANIM','HUMAN','OBJ','BIG'],'FontSize',18,'FontAngle','italic');
ylabel(Y_label,'FontSize',FontSize,'FontAngle','italic');
%xtickangle(45);