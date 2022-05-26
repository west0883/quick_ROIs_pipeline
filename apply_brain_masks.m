% apply_brain_masks.m
% Sarah West
% 12/8/21

function [] = apply_brain_masks(parameters)
    
    % Establish directory
    dir_in=[parameters.dir_exper 'quick ROIs\']; 

    % Display where data is being saved for user
    disp(['data saved in ' dir_in]); 
    
    % For each mouse ,
    for mousei=1:size(parameters.mice_all,2)
        mouse=parameters.mice_all(mousei).name;
        
        % Load quick ROI masks 
        load([dir_in 'quickROIs_m' mouse '.mat']); 
        
        % Rename so variables don't get confused.
        eval(['ROI_masks = ' parameters.ROI_input_variable ';']);
        eval(['clear ' parameters.ROI_input_variable]);
        
        % If you need to apply a brain mask, 
        if parameters.mask_flag

            % Load brain masks 
            brainMask_combined_input_name = [parameters.brainMask_dir_in parameters.brainMask_input_filename];
            brainMask_file_string = CreateFileStrings(brainMask_combined_input_name, mouse, [], [], [], false); 
            load(brainMask_file_string, parameters.brainMask_input_variable); 
           
            % Rename brain mask indices to avoid confusion/overwriting. 
            eval(['brain_mask= ' parameters.brainMask_input_variable ';']);
            eval(['clear ' parameters.brainMask_input_variable]);

            % Get the inverse of the brain mask.
            %inverse_brain_mask_indices=true(parameters.pixels(1), parameters.pixels(2)); 
            %inverse_brain_mask_indices(brain_mask_indices)= 0;
            
            % Reshape both sets of masks
            % inverse_brain_mask_indices = reshape(inverse_brain_mask_indices, parameters.pixels(1) * parameters.pixels(2), size(inverse_brain_mask_indices,3));
            listed =find(inverse_brain_mask_indices == 1);
            ROI_masks =reshape(ROI_masks, parameters.pixels(1) * parameters.pixels(2), size(ROI_masks,3));
            ROI_masks_nobrain = ROI_masks;
            ROI_masks_nobrain(listed,:) = [];
        end
    
    % Save
end 