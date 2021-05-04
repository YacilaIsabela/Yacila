%% run batch of segmentation for each participant
%created by Seb Baez May 2017

clear all
close all
clc

spm('defaults','fmri');
global defaults;
spm_jobman('initcfg');

tmp = pwd;

sujets = {'s108' 's111' 's115' 's117' 's121' 's125' 's126' 's130' 's132' 's135' 's145' 's155' 's156'}; %mettre les noms des dossiers ou sont les images pour chaque participant

%sujets = {'s109'} ;
[nfiles,m] = size(sujets);

tic
for i = 1:m
    
    try

    folder= fullfile(tmp,sujets(i));
    cd(folder{1,1})
    run segmentation_job.m
    output_part = spm_jobman('run',matlabbatch);

    catch ME
        fprintf('IDIOT you did a mistake!! :( -> segmentation without success: %s\n', ME.message);
        continue
    end
     fprintf('BRAVO SEB :) ->  segmentation worked successfully\n');

end
toc