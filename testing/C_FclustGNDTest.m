%Test FclustGND function
%AUTHOR: Eric Fields
%VERSION DATE: 20 June 2017

%Load a GND for testing
if ispc()
    load('R:\Public\GK_lab\Eric\FMUT_development\FMUT\testing\EmProb_13subs_Test.GND', '-mat');
elseif ismac()
    load('/Volumes/as-rsch-ncl1$/Public/GK_lab/Eric/FMUT_development/FMUT/testing/EmProb_13subs_Test.GND', '-mat');
end

%Define general variables
time_wind = [500, 800];

%% Exact interaction

GND = FclustGND(GND, ...
              'bins',          [24, 26, 27, 29], ...
              'factor_names',  {'Probability', 'Emotion'}, ... 
              'factor_levels', [2, 2], ... 
              'time_wind',     time_wind, ... 
              'n_perm',        500, ...
              'alpha',         0.05, ...
              'exclude_chans', {'centroparietal_cluster'}, ...
              'save_GND',      'no', ...
              'chan_hood',     75, ...
              'thresh_p',      .05, ...
              'plot_raster',   'yes', ...
              'output_file',   fullfile('outputs', 'Fclust_test.xlsx'));

%F==t^2
[~, start_sample] = min(abs( GND.time_pts - time_wind(1) ));
[~, end_sample  ] = min(abs( GND.time_pts - time_wind(2) ));
assert(all(all(GND.F_tests(end).F_obs.ProbabilityXEmotion - GND.grands_t(1:32, start_sample:end_sample, 51).^2 < 1e-4)));


%% One-way ANOVA

GND = FclustGND(GND, ...
              'bins',          [24, 26, 27], ...
              'factor_names',  {'NEU_Probability'}, ... 
              'factor_levels', 3, ... 
              'time_wind',     time_wind, ... 
              'n_perm',        500, ...
              'alpha',         0.05, ...
              'exclude_chans', {'centroparietal_cluster'}, ...
              'save_GND',      'no', ...
              'chan_hood',     75, ...
              'thresh_p',      .05, ...
              'plot_raster',   'yes', ...
              'output_file',   fullfile('outputs', 'Fclust_test_oneway.xlsx'));
          

%% Approximate interaction  

GND = FclustGND(GND, ...
              'bins',          [24:29, 31, 32, 33], ...
              'factor_names',  {'Probability', 'Emotion'}, ... 
              'factor_levels', [3, 3], ... 
              'time_wind',     time_wind, ... 
              'n_perm',        500, ...
              'alpha',         0.05, ...
              'exclude_chans', {'centroparietal_cluster'}, ...
              'save_GND',      'no', ...
              'chan_hood',     75, ...
              'thresh_p',      .05, ...
              'plot_raster',   'no');

          
%% Mean window

GND = FclustGND(GND, ...
              'bins',          [24, 26, 27, 29], ...
              'factor_names',  {'Probability', 'Emotion'}, ... 
              'factor_levels', [2, 2], ... 
              'time_wind',     time_wind, ...
              'mean_wind',     'yes', ...
              'n_perm',        500, ...
              'alpha',         0.05, ...
              'exclude_chans', {'centroparietal_cluster'}, ...
              'save_GND',      'no', ...
              'chan_hood',     75, ...
              'thresh_p',      .05, ...
              'plot_raster',   'yes', ...
              'output_file',   fullfile('outputs', 'FclustGND_meanwind_test.xlsx'));

%Calculate t-test on same data
GND = clustGND(GND, 51, ...
               'chan_hood',    75, ...
               'n_perm',       500, ...
               'time_wind',    time_wind, ...
               'mean_wind',    'yes', ...
               'exclude_chans', {'centroparietal_cluster'}, ...
               'plot_raster',  'no', ...
               'plot_gui',     'no', ...
               'plot_mn_topo', 'no', ...
               'save_GND',     'no', ...
               'verblevel',    2);
 
%F==t^2
assert(all(GND.F_tests(end).F_obs.ProbabilityXEmotion - GND.t_tests(end).data_t.^2 < 1e-9))
          
