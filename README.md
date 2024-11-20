# Neurocat3
This is an fMRI project titled "Impact of a transient neonatal visual deprivation on the development of the ventral occipito-temporal cortex in humans"

Most of the scripts used for analyses and data visualization are stored here in Github, while data and masks are stored in OSF 

There are 2 main folders here:
1 MULTIVARIATE_searchlight
2 MULTIVARIATE_ROIs_and_viz

In **MULTIVARIATE_searchlight** are stored the 4 matlab scripts used to run the main 4 multivariate searchlight anaalyses of the paper:
1. SplitHalf_searchlight_Mattioni19112024
2. sm_RSAsearchlight_Categ_HmaxC_reegressOUT_Mattioni19112024
3. Decoding_lda_NeuroCat3_BetweenCategories_Mattioni19112024
4. Decoding_lda_NeuroCat3_WithinCategoriess_Mattioni19112024

The brain maps results from these searchlight analyses are shown in the paper in figures 4 (splithalf), figure 5 (RSA), figure 6 and Supplemental figure 3 (Within category decoing), supplemental figure 2 (Between category decoding).
We alsso created some brrain mask based on these results (shared on OSF) that wee used to visualize repreesentational dissimilarity matrices, confusion matrices and dotplot graphs --> see next section

In **MULTIVARIATE_ROIs_and_viz** are stored the script for ROI multivariate analyses used for visualization only in the mask created from searchlight analyses.


In the folder 'Splithalf_ROI' there is:
- the matlab script 'Splithalf_ROI_Mattioni19112024.m' used to run the ROI splithalf analysis.
- a folder 'results_splithalfROI' where are stored the splithalf correlation results for each mask aand the matab script 'visualizeResults_singleROI_choose2Gr.m' to visualize the dotplot graphs of figure 4 panels E-F-G-I-L

In the folder 'RSA_ROI' there is:
- the script 'DSM_extractBrainActivity_allSub_NeuroCAT3_allGr.m' to extract the representational dissimilarity matrix of each subject from each mask.
- These RDMs are stored into the folder 'BrainDSM', and cana bee visualized using the script 'Visualize_DSM_normalizedAllGrtogether.m' in the same folder.
- The script 'corrANDpartCorr_with_CAT5_HmaxC1.m' iss used for the RSA analysis to correrlate brain DSMs with external models: HmaxC1 and Categorical (stored in the folder Models)
- In the folder 'Results_RSA' there are the file with the Spearman's correlation values for the two models with the brain RDMs from every subject in every brain region.
    - Using the script 'visualizeResults_singleROI_RSAcategorical_choice_2Gr.m' the results with categorical model can be visualized in dotplot graphs;
    -  Using the script 'visualizeResults_singleROI_RSAhmaxc1_choice_2Gr.m' the results with HmaxC1 model can be visualized in dotplot graphs
    - To add the gray bars (see dotplot graphs in figure 5) representing the maximal level of correlation the vaalues sstored in the folder 'Intra_Corr_results' are used.
 
In the folder 'Decoding_betweenCategories' there is:
- the matlab script 'Decoding_betweenCAT_ROIs_Mattioni20112024.m' used to run the ROI between categories decoding analysis.
- a folder 'Results_lda_and_viz' where are stored the results for each mask and the matab script 'visualizeResults_singleROI_choose2Gr.m' to visualize the dotplot graphs of figure SI 2 panels E-F-G-H. To plot the confusion matrices for each group and ROI the script 'Visualize_Confusion_Matrices.m' can be used.

In the folder 'Decoding_withinCategories' there is:
- the matlab script 'MVPA_ROIaccuracy_withinCAT_Mattioni20112024.m' used to run the ROI within categories decoding analysis.
- a folder 'results_ROIs_withinCAT_and_viz' where are stored the results for each mask and category and the matab script 'visualizeResults_singleROI_choose2Gr.m' to visualize the dotplot graphs of figure 6 panels E-F-G-H. To plot the confusion matrices for each group and ROI the script 'Visualize_Confusion_Matrices.m' can be used.

