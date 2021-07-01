clear all
close all
clc

spm('defaults','fmri');

spm_jobman('initcfg');


tmp = 'E:\MRI_postintervention';

% sujet_code = {'s001' 's002' 's003' 's005' 's006' 's008' 's009' 's010' 's011' 's012' 's013' 's014' 's015' ...
%     's016' 's017' 's018' 's019' 's020' 's021' 's022' 's023' 's024' 's025' 's026' 's027' 's029' 's030' ...
%     's031' 's033' 's035' 's036' 's037' 's038' 's039' 's040' 's041' 's042' 's043' 's044' 's045' 's048' ...
%     's049' 's050' 's052' 's053' 's054' 's055' 's056' 's057' 's058' 's059'  's060' 's061' 's062'...
%     's064' 's065' 's066' 's067' 's069' 's070' 's072' 's073' 's074' 's075' 's076' 's077' 's078' 's079' 's080' 's081'...
%     's082' 's083' 's084' 's085' 's086' 's087' 's090' 's091' 's093' 's094' 's095' 's096' 's097' 's099' 's100'...
%     's101' 's102' 's103' 's104' 's108' 's109' 's110' 's111' 's112' 's113' 's114' 's115' 's116' 's117' 's118' ...
%     's120' 's121' 's122' 's123' 's124' 's125' 's126' 's128' 's129' 's130' 's131' ...
%     's132' 's134' 's135' 's136' 's137' 's138' 's139' 's141' 's142' 's143' 's144' ...
%     's145' 's146' 's147' 's149' 's150' 's151' 's152' 's153' 's155' 's156'};

sujet_code = { 's002' };%mettre les noms des dossiers ou sont les images pour chaque participant

[nfiles,m] = size(sujet_code);

for i = 1:m
tic
    try

    folder= fullfile(tmp,sujet_code(i));
    cd(folder{1,1})
    
      [rp_file1] = dir('*run1.txt');
      rp1 = load(rp_file1.name);
      rp1_new = rp1(1:293,:);
      dlmwrite(rp_file1.name,rp1_new) 
      
      [rp_file2] = dir('*run2.txt');
      rp2 = load(rp_file2.name);
      rp2_new = rp2(1:293,:);
      dlmwrite(rp_file2.name,rp2_new)



    catch ME
        fprintf('IDIOT you did a mistake!! :( -> estimation of 1st level without success for participant : %s \n', sujet_code{i}, ME.message);
        continue
    end
     fprintf('BRAVO SEB :) -> estimation of 1st level worked successfully for participant : %s\n',sujet_code{i});

     cd(tmp)
     
toc
end