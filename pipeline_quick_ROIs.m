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
parameters.mice_all=parameters.mice_all(1);
 
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
        
        