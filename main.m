clear; close all; clc

%% Read config file
filename = 'C:\Users\gary\SkyDrive\Documents\Grad School\Resources\Data Sets\Gleason CD\Feb4_2005_Data_Ice\RI_Script.dat';
config = readConfigFile(filename);

%% Start processing
filename = 'C:\Users\gary\SkyDrive\Documents\Grad School\Resources\Data Sets\Gleason CD\Feb4_2005_Data_Ice\RI.raw';
for i = 1:size(config, 2)
    disp(['Starting Script Entry ' num2str(i)])
    readRawData(filename, config(i), i);
end

disp('Finished processing script');
