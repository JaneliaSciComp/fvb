function exp_detail = prot_532_analysis(exp_directory, save_plots, folder_path, temp, phase, AD, protocol, analysis_version)
% analysis for protocols 3.1 and 4.1

close all

%% step 1: find the experiment_details file
if all(exp_directory == -1)
    directory_name = uigetdir;
    if (directory_name ~= 0)
        cd(directory_name)
        exp_directory = directory_name;
    else
        error('program terminated, must select a directory name');
    end
else
    cd(exp_directory)
end
cur_dir = dir('*.exp'); % grab local experiment file

if length(cur_dir) ~= 1
    error('EXP file not found (or found too many), check file name or directory!');
end

load(cur_dir.name, '-mat') % load the experiment file

% CD to the directory of the experiment (typically one of the two
% temperatures
try
    cd([exp_directory filesep folder_path])
catch
    error('The directory for the data path is incorrect, check filesystem')
end

cur_dir = dir('*.m');


cnt = 0; % counter for error checking
for j = 1:length(cur_dir)
    %cur_dir(j).name %just debug
    if (strcmp(cur_dir(j).name(1:16), 'sequence_details'))
        try 
            fid = fopen([cur_dir(j).name(1:end-2) '.m']);
            script = fread(fid, '*char')';
            fclose(fid);
            eval(script);
            
            % compensate for unwise choice of the analysis detail path info so
            % update after the eval is run...
            analysis_detail = AD;        
            analysis_detail.exp_path = [exp_directory AD.analysis_path]; % test this...do we need anything else?
        catch exception
            fprintf(['Error: sequence_details file ' cur_dir(j).name ' does not load or is missing crucial info.'])            
            throw(exception)
        end
        cnt = cnt + 1;
    end
end

if cnt == 0
    error('No experiment_details file found, check file name or directory!');
elseif cnt > 1
    error('Too many experiment files, please re-check this');
end


for j = 1: length(cur_dir)
    if length(cur_dir(j).name) > 5
        if (strcmp(cur_dir(j).name(end-2:end), 'pdf'))
            delete(cur_dir(j).name)
        end
    end
end
    


cd([analysis_detail.exp_path]) 


if phase == 1,
    
    %% seq1, ReversePhi, 4pix, 15/0 Contrast
    sequence = 'seq1';
    min_num_flies = 2; % minimum number of flies in tubes
    del_t = 1/25; %inverse frames per second
    dir1_starts = [125,625,1125,1625,2125,2625,3125,3625,4125,4625,5125,5625,6125,6625];
    dir2_starts = [375,875,1375,1875,2375,2875,3375,3875,4375,4875,5375,5875,6375,6875];
    trial_length = 250;
    ma_points = 8; % number of points to use in ma smoothing of the velocity plot
    plot_conditions = [0 0.67 2 5 10 20 42 42 20 10 5 2 0.67 0]; %stimulus speeds
    x_variable = 'Temporal Freqency';
    main_title = 'Reverse Phi, 4pixels, 15/0 Contrast';
    
    try
        load([analysis_detail.seq(1).path '_analysis_info.mat'])
    catch
        error(['No analysis_info in directory ' pwd ' bad name or analysis not run'])
    end
    linear_motion_analysis;
    
    %% seq2, ReversePhi, 4pix
    sequence = 'seq2';
    min_num_flies = 2; % minimum number of flies in tubes
    del_t = 1/25; %inverse frames per second
    dir1_starts = [125,625,1125,1625,2125,2625,3125,3625,4125,4625,5125,5625,6125,6625];
    dir2_starts = [375,875,1375,1875,2375,2875,3375,3875,4375,4875,5375,5875,6375,6875];
    trial_length = 250;
    ma_points = 8; % number of points to use in ma smoothing of the velocity plot
    plot_conditions = [0 0.67 2 5 10 20 42 42 20 10 5 2 0.67 0]; %stimulus speeds
    x_variable = 'Temporal Freqency';
    main_title = 'Reverse Phi, 4pixels, 15/2 Contrast';
    
    try
        load([analysis_detail.seq(2).path '_analysis_info.mat'])
    catch
        error(['No analysis_info in directory ' pwd ' bad name or analysis not run'])
    end
    linear_motion_analysis;
    
end

if phase == 2;
    
    %% seq3, ReversePhi, 2pix
    sequence = 'seq3';
    min_num_flies = 2; % minimum number of flies in tubes
    del_t = 1/25; %inverse frames per second
    dir1_starts = [125,625,1125,1625,2125,2625,3125,3625,4125,4625,5125,5625,6125,6625];
    dir2_starts = [375,875,1375,1875,2375,2875,3375,3875,4375,4875,5375,5875,6375,6875];
    trial_length = 250;
    ma_points = 8; % number of points to use in ma smoothing of the velocity plot
    plot_conditions = [0 0.67 2 5 10 20 42 42 20 10 5 2 0.67 0]; %stimulus speeds
    x_variable = 'Temporal Freqency';
    main_title = 'Reverse Phi, 2pixels';
    
    try
        load([analysis_detail.seq(3).path '_analysis_info.mat'])
    catch
        error(['No analysis_info in directory ' pwd ' bad name or analysis not run'])
    end
    linear_motion_analysis;
    
    %% seq4, Optomotor
    sequence = 'seq4';
    min_num_flies = 2; % minimum number of flies in tubes
    del_t = 1/25; %inverse frames per second
    dir1_starts = [125,625,1125,1625,2125,2625,3125,3625,4125,4625,5125,5625,6125,6625];
    dir2_starts = [375,875,1375,1875,2375,2875,3375,3875,4375,4875,5375,5875,6375,6875];
    trial_length = 250;
    ma_points = 8; % number of points to use in ma smoothing of the velocity plot
    plot_conditions = [0 0.67 2 5 10 20 42 42 20 10 5 2 0.67 0]; %stimulus speeds
    x_variable = 'Temporal Freqency';
    main_title = 'Optomotor';
    
    try
        load([analysis_detail.seq(4).path '_analysis_info.mat'])
    catch
        error(['No analysis_info in directory ' pwd ' bad name or analysis not run'])
    end
    linear_motion_analysis;

end

%% now save all of the data:
analysis_results(phase).analysis_version = analysis_version;
analysis_results(phase).BoxName = BoxName;
analysis_results(phase).TopPlateID = TopPlateID;

save([analysis_detail.exp_path filesep folder_path '_analysis_results.mat'],'analysis_results')
