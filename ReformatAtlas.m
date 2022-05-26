% ReformatAtlas.m
% Sarah West
% 1/31/22

% Requires a .mat atlas (usnig LocaNMF atlas aligned to mouse) with a field 
% of .areanames that holds the name and atlas value of each area. Reformats 
% the atlas so each region is its own dimension in the atlas
% stack, with zeroes everywhere else. Makes the linear algebra of
% extraction easier/possible.

function [] = ReformatAtlas(parameters)

    % For each mouse 
    for mousei = 1:size(parameters.mice_all,2)
        mouse = parameters.mice_all(mousei).name;
        
        % Get directory name. 
        filename = CreateFileStrings([parameters.dir_input_atlas parameters.input_atlas_filename], mouse, [], [], [], false);
       
        % Load atlas
        load(filename);

        % Load new, ordered list of area names (is left only).
        load(parameters.dir_new_order);
 
        % Add in right side regions.
            % Make a cell twice as large to hold everything
            all_regions = cell(2* size(new_order,1), 2); 

            % Put in left regions
            all_regions(1:2:end) = new_order;

            % Put in right regions region-by-region (because is a cell) 
            for regioni = 1:size(new_order,1)

                 % values, which are just negatives of left
                 all_regions{regioni * 2, 1} = -1 * new_order{regioni,1};

                 % Names. Remove last "L" and replace with "R"
                 all_regions{regioni*2, 2} = [new_order{regioni,2}(1:end-1) 'R'];

            end

        % Create holding atlas of zeros
        new_atlas = zeros(size(atlas,1), size(atlas,2), size(all_regions,1)); 

        % For each region 
        for regioni = 1:size(all_regions,1)
            
            % Get the name of the region and corresponding atlas value.
            region_name = all_regions{regioni,2};
            value = all_regions{regioni, 1};

            % Get indices of atlas region.
            indices = find(atlas == value);
            
            % Put into new atlas.
            holder = zeros(size(atlas));
            holder(indices) = 1;
            new_atlas(:, :, regioni) = holder;

            % Make new region names variable
            regions(regioni).name = region_name;

        end 

        % Rename new atlas 
        atlas = new_atlas; 

        % Get mouse-specific output folder
        dir_out = [parameters.dir_output_base mouse '\']; 
        mkdir(dir_out);

        % Save atlas and region names
        save([dir_out 'atlas.mat'], 'atlas', 'regions')
        
    end
end