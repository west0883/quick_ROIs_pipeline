% pipeline_quick_ROIs.m
% Sarah West
% 12/7/21

% This script allows you to draw and save quick ROIs for initial network
% analysis via the "Run Section" feature of the Matlab Editor. Each step is called as a function. 

% Use "create_mice_all.m" before using this.

%% Initial Setup  
% Put all needed paramters in a structure called "parameters", which you
% can then easily feed into your functions. 
clear all; 

%Create the experiment name. 
parameters.experiment_name='Random Motorized Treadmill';

% Get experiement directory, where create_mice_all.mat is saved
parameters.dir_exper = ['Y:\Sarah\Analysis\Experiments\' parameters.experiment_name '\']; 

% Output directory
parameters.dir_output_base=['Y:\Sarah\Analysis\Experiments\' parameters.experiment_name '\quick ROIs\']; 

% Location and filenames of ROI masks (cell array formatting) and
% variable name (string).
parameters.ROI_dir_in_base = {['Y:\Sarah\Analysis\Experiments\' parameters.experiment_name '\quick ROIs\']};
parameters.ROI_input_filename = {'quickROIs_m', 'mouse number', '.mat'}; 
parameters.ROI_input_variable = 'masks';

% Is there a brain mask for this mouse?
parameters.mask_flag=true; 

% Directory, file name, and variable name for brain mask, if present.
parameters.brainMask_dir_in = {parameters.dir_exper 'masks\'};
parameters.brainMask_input_filename = {'masks_m', 'mouse number', '.mat'};
parameters.brainMask_input_variable = 'indices_of_mask';

% (DON'T EDIT). Load the "mice_all" variable you've created with "create_mice_all.m"
load([parameters.dir_exper 'mice_all.mat']);

% Add mice_all to parameters structure.
parameters.mice_all = mice_all; 

% ****Change here if there are specific mice, days, and/or stacks you want to work with**** 
parameters.mice_all=parameters.mice_all(2:3);
 
% List the names of the regions you want to draw. 
parameters.ROI_names ={'M2 left';
                       'M2 right';
                       'M1 left';
                       'M1 right';
                       'visual left';
                       'visual right';
                       'retrosplenial left';
                       'retrosplenial right'}; 

% Number of pixels you expect to have:
parameters.pixels = [256, 256];

%% Run masking
manual_ROI_masking_loop(parameters);

%% Delete any you don't like
delete_quickROI_masks(parameters);

%% Apply brain mask indices
apply_brain_masks(parameters); 
        
%% Or, use an atlas in .mat format (I'm using the adjusted one from LocaNMF)
% Initial Setup  

% Atlas should already be aligned with the mouse via the LocaNMF
% preprocessing pipeline.

clear all; 

%Create the experiment name. 
parameters.experiment_name='Random Motorized Treadmill';

% Get experiement directory, where create_mice_all.mat is saved
parameters.dir_exper = ['Y:\Sarah\Analysis\Experiments\' parameters.experiment_name '\']; 

% Output directory
parameters.dir_output_base=['Y:\Sarah\Analysis\Experiments\' parameters.experiment_name '\atlas ROIs preliminary analysis\']; 

% Is there a brain mask for this mouse?
parameters.mask_flag=true; 

% Directory, file name, and variable name for brain mask, if present.
parameters.brainMask_dir_in = {parameters.dir_exper 'masks\'};
parameters.brainMask_input_filename = {'masks_m', 'mouse number', '.mat'};
parameters.brainMask_input_variable = 'indices_of_mask';

% (DON'T EDIT). Load the "mice_all" variable you've created with "create_mice_all.m"
load([parameters.dir_exper 'mice_all.mat']);

% Aligned atlas input directory
parameters.dir_input_atlas = {[parameters.dir_exper 'LocaNMF\preprocessed\aligned atlases\'], 'mouse number', '\' };
parameters.input_atlas_filename = 'atlas.mat'; 

% Add mice_all to parameters structure.
parameters.mice_all = mice_all; 

% ****Change here if there are specific mice, days, and/or stacks you want to work with**** 
parameters.mice_all=parameters.mice_all(2);

%% 
% regionprops used to find centroids of subdivided original atlas. New order 
% listed with centroids sorting a-p within general regions/
new_order = {
301	'MOB_L'
8	'FRP1_L'
217	'ORBm1_L'
198	'PL1_L'
186	'ACAd1_L'
347	'MOs_rl_L'
21	'MOs_rm_L'
341	'MOs_c_L'
15	'MOp_l_L'
353	'MOp_m_L'
50	'SSp_m1_L'
57	'SSp_ul1_L'
29	'SSp_n1_L'
71	'SSp_un1_L'
43	'SSp_ll1_L'
78	'SSs1_L'
64	'SSp_tr1_L'
36	'SSp_bfd1_L'
98	'AUD_L'
92	'VISC1_L'
268	'VISa1_L'
136	'VISam1_L'
275	'VISrl1_L'
129	'VISal1_L'
164	'VISpm1_L'
171	'VISli1_L'
150	'VISp1_L'
143	'VISl1_L'
178	'VISpor1_L'
157	'VISpl1_L'
255	'RSPd1_L'
261	'RSPv1_L'
249	'RSPagl1_L'
282	'TEa1_L'
295	'ECT1_L'
335	'RHP_L'};

parameters.dir_new_order = 'Y:\Sarah\Analysis\Pipelines\LocaNMF preprocessing\new_region_order.mat';
save([parameters.dir_new_order], 'new_order');


%% Reformat atlas.
% Reformats the atlas so each region is its own dimension in the atlas
% stack, with zeroes everywhere else. Makes the linear algebra of
% extraction easier/possible. Also reorders the regions based on new_order
% above.
parameters.dir_new_order = 'Y:\Sarah\Analysis\Pipelines\LocaNMF preprocessing\new_region_order.mat';

ReformatAtlas(parameters);


        