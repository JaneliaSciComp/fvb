function prot_513_comparison_summary(exp_group1, exp_group2, ...
    analysis_feature, plot_mode, saveplot)
% author: Austin Edwards
% 
% input:
%       exp_group1 - cell array of strings containing paths to experiments
%                    in group 1
%       exp_group2 - cell array of strings containing paths to experiments
%                    in group 2 (-1 if no experiments in group 2)
%       analysis_feature - string of feature to plot
%       plot_mode
%       save_plot

if nargin < 5,
    saveplot = 1;
end

% set exp_group2 to be -1 if no experiments in group2
if isnumeric(exp_group2) == 1, exp_group2 = -1;
end

% get number of experiments in each group
nexp_group1 = length(exp_group1);
nexp_group2 = length(exp_group2);

% Create structs with metadata for experiments
exp_group1 = parse_explist(exp_group1,plot_mode);
if ~isnumeric(exp_group2),
    exp_group2 = parse_explist(exp_group2,plot_mode);
end

if plot_mode == 2 && (~isnumeric(exp_group2) || nexp_group1 > 1),
    error('Cannot plot individual tubes for more than one experiment')
end

close all

figure(1)
set(1, 'Position', [30 55 1500 1500]);

% Seq 2 : Optomotor Response

seq = 'seq2';

plot_conditions = [0 0.67 2 5 10 20 42 42 20 10 5 2 0.67 0]; %stimulus speeds
x_variable = 'Temporal Freqency (Hz)';
y_variable = 'Direction Index';
sequence_title = 'Optomotor (Temporal Tuning)';
num_conditions = length(plot_conditions);
half_num_conditions = num_conditions/2;
y_lim = 1;
n_y_lim = -0.2;

subplot_count = 1;
linear_motion_comparison;
subplot_count = subplot_count + 1;

% Seq 3 : Contrast

seq = 'seq3';

plot_conditions = [0.07, 0.2, 0.5, 0.7, 1, 1, 0.7, 0.5, 0.2, 0.07]; %stimulus speeds
x_variable = 'Contrast';
y_variable = 'Direction Index';
sequence_title = 'Contrast (Constant Intensity)';
num_conditions = length(plot_conditions);
half_num_conditions = num_conditions/2;
y_lim = 1;
n_y_lim = -0.2;

linear_motion_comparison;
subplot_count = subplot_count + 1;

% Seq 4 : Contrast

seq = 'seq4';

plot_conditions = [0.1, 0.3, 0.4, 0.7, 1, 1, 0.7, 0.4, 0.2, 0.1]; %stimulus speeds
x_variable = 'Contrast';
y_variable = 'Direction Index';
sequence_title = 'Contrast (Increasing Intensity)';
num_conditions = length(plot_conditions);
half_num_conditions = num_conditions/2;
y_lim = 1;
n_y_lim = -0.2;

linear_motion_comparison;
subplot_count = subplot_count + 1;

% Seq 5 : Spatial

seq = 'seq5';

plot_conditions = [3, 4, 6, 8, 12, 16, 32, 32, 16, 12, 8, 6, 4, 3]; %stimulus speeds
x_variable = 'Pixels per Cycle';
y_variable = 'Direction Index';
sequence_title = 'Optomotor (Spatial Tuning)';
num_conditions = length(plot_conditions);
half_num_conditions = num_conditions/2;
y_lim = 1;
n_y_lim = -0.2;

linear_motion_comparison;
subplot_count = subplot_count + 1;

% Seq 6 : Phototaxis
seq = 'seq6';
min_num_flies = 2; % minimum number of flies in tubes
del_t = 1/25; %inverse frames per second
dir1_starts = [125 875 1625 2375];
dir2_starts = [500 1250 2000 2750];
ma_points = 8; % number of points to use in ma smoothing of the velocity plot
plot_conditions = {'G = 25', 'G = 120', 'UV = 36', 'UV = 200'};
X_label_short = {'GL', 'GH', 'UL', 'UH'};
tube_length = 112.55; %length of tube in mm

num_conditions = length(dir1_starts);
analysis_feature = 'cum_dir_index_max';

phototaxis_comparison;
subplot_count = subplot_count + 1;

% Seq 7 : Color Preference

seq = 'seq7';
min_num_flies = 2; % minimum number of flies in tubes
del_t = 1/25; %inverse frames per second
dir1_starts = [125 625 1125 1625 2125 2625 3125 3625 4125 4625 5125 5625 6125 6625 7125 7625 8125 8625 9125 9625 10125 10625]; 
dir2_starts = [375 875 1375 1875 2375 2875 3375 3875 4375 4875 5375 5875 6375 6875 7375 7875 8375 8875 9375 9875 10375 10875];
plot_conditions = [0 5 10 15 20 30 40 50 75 100 200 200 100 75 50 40 30 20 15 10 5 0];
x_variable = 'Green Intensity';
y_variable = 'cum_dir_index_peak';
sequence_title = 'Color Preference, UV Constant';

num_conditions = length(dir1_starts);
half_num_conditions = num_conditions/2;
analysis_feature = 'cum_dir_index_peak';
y_lim_DI = 1;
y_lim_cum_DI = 4*y_lim_DI;

color_preference_comparison;
subplot_count = subplot_count + 1;

% Seq 8 : Optomotor Response

seq = 'seq8';
min_num_flies = 2; % minimum number of flies in tubes
del_t = 1/25; %inverse frames per second
dir1_starts = [125 625 1125 1625 2125 2625 3125 3625 4125 4625 5125 5625 6125 6625 7125 7625 8125 8625 9125 9625 10125 10625]; 
dir2_starts = [375 875 1375 1875 2375 2875 3375 3875 4375 4875 5375 5875 6375 6875 7375 7875 8375 8875 9375 9875 10375 10875];
plot_conditions = [5 7 10 15 20 30 40 50 75 100 200 200 100 75 50 40 30 20 15 10 7 5];
x_variable = 'UV Intensity';
y_variable = 'cum_dir_index_peak';
sequence_title = 'Color Preference, Green Constant';

num_conditions = length(dir1_starts);
half_num_conditions = num_conditions/2;
analysis_feature = 'cum_dir_index_peak';
y_lim_DI = 1;
y_lim_cum_DI = 4*y_lim_DI;

color_preference_comparison;
subplot_count = subplot_count + 1;

if plot_mode == 1 || plot_mode == 2,
    text(30, 0.25*y_lim_DI, ... 
             [exp_group1(1).genotype, ' ', '~18 days'], ...
             'HorizontalAlignment', 'right', ...
             'Interpreter', 'none', ...
             'FontSize', 14, ...
             'Color', 'k', ...
             'BackgroundColor',[1 1 1])
    text(30, -0.25*y_lim_DI, ... 
             exp_group1(1).exp_datetime, ...
             'HorizontalAlignment', 'right', ...
             'Interpreter', 'none', ...
             'FontSize', 14, ...
             'Color', 'k', ...
             'BackgroundColor',[1 1 1])

   if ~isnumeric(exp_group2),
        text(30, -0.75*y_lim, ... 
            [exp_group2(1).genotype, ' ', '~14 days'], ...
            'HorizontalAlignment', 'right', ...
            'Interpreter', 'none', ...
            'FontSize', 14, ...
            'Color', 'r', ...
            'BackgroundColor',[1 1 1])

        text(30, -1.25*y_lim, ... 
            exp_group2(1).exp_datetime, ...
            'HorizontalAlignment', 'right', ...
            'Interpreter', 'none', ...
            'FontSize', 14, ...
            'Color', 'r', ...
            'BackgroundColor',[1 1 1])
   end
end

if plot_mode == 1,
    suptitle('Protocol 5.13 Comparison Summary')
end

if plot_mode == 2,
    suptitle('Protocol 5.13 Comparison Summary - Individual Tubes with Mean')
end

if plot_mode == 3,
    suptitle('Protocol 5.13 Comparison Summary - Individual Tubes')
end

if saveplot == 1,
    save2pdf(['~/Desktop/', 'comparison_summary.pdf']);
end