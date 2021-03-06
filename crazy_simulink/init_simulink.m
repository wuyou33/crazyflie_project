close all;
clear all;

% Add simulink folders to path
addpath(genpath('.'));

% Initiate quadcopter model
run('quadcopter_init'); % /model

% Initiate PD baseline controller
run('init_pd_controller'); % /PD_controller

% Initiate PD posiiton controller
run('init_pd_position_controller'); % /PD_controller

% Sample rates
innerLoopSampleRate = 0.01; % 1000 Hz
outerLoopSampleRate = 0.05; % 20 Hz