function creation_batch_odd (sujet_code)
%Script fait par Seb Baez Aout 2018
%modifi? pour analyses nouveau filtre Fev 2019
% creation_batch_odd ('s035')

odds = {'s004','s005','s006','s010','s011', 's012','s016','s017','s018','s022', 's023','s024', ...
    's028','s029', 's030','s034','s035', 's036','s040', 's041', 's042','s046','s047','s048', ...
    's055','s056','s057', 's061', 's062','s063', 's067', 's068', 's069','s073', 's074', 's075', ...
    's079', 's080', 's081', 's085','s086', 's087','s091', 's092', 's093', 's097', 's098', 's099', ...
    's103', 's104', 's105','s109', 's110','s111', 's115', 's116', 's117', 's121', 's122','s123',...
    's127', 's128', 's129', 's133', 's134','s135', 's139', 's140', 's141', 's145', 's146','s147'...
    's151','s152','s153'} ;

spm('defaults','fmri');
global defaults;
spm_jobman('initcfg');

job = 1;


%% go to the folder of the participant
% get data from the .mat files
%sujet_code = 's005';
tmp = pwd;
folder = fullfile(tmp,sujet_code);
cd(folder)

foldernew = fullfile(folder);

nomFichier1 = sprintf('video_awelli1v1%s_1.mat',sujet_code);
nomFichier2 = sprintf('video_awelli1v1%s_2.mat',sujet_code);
% 
% nomFichier1 = sprintf('video_awelli4v4s901_2.mat');
% nomFichier2 = sprintf('video_awelli4v4s901_2.mat');

load (nomFichier2, 'data','t_croix_start')
data1 = data;
t_croix_start1 = t_croix_start
clear data
clear t_croix_start

load (nomFichier1,'data','t_croix_start')

%% get images:
nsessions = 2;
ndyn=zeros(1,nsessions);

% i = session
% z = run

	for i = 1: nsessions  
        z = i;                          %ici le numero de sessionn est le meme que le numero du RUN
        if ismember(sujet_code, odds)   %ici pour ces participants, si le numero de sesion = 1 le RUN =  2
            if i == 1
            z = 2;
            else
            z = 1;
            end
        end
            clear tmp_exp;
            tmp_exp = ['^fswwawell.*_sovt_run' num2str(z) '.*$'];
            clear files;
            [files] = spm_select(Inf,'image',...
                ['Select functional images for session ' num2str(i)],[], pwd, tmp_exp, [1 : 293]); %305 = 5 vomules + to the longest length 288 volumes
            [nfiles,m] = size(files);
            ndyn(i) = nfiles;
            tmp_files = cell(nfiles,1);
            for j = 1:nfiles,
                tmp_files{j}=deblank(files(j,:));
                images{1}.scans{1,i}{j,1} = tmp_files{j};
		end
	
    end
    
    if ismember(sujet_code, odds)
    [rp_file1] = spm_select(1, 'any', 'Select IRM - rp session 1', [], pwd, 'rp.*_sovt_run2');
    [rp_file2] = spm_select(1, 'any', 'Select IRM - rp session 2', [], pwd, 'rp.*_sovt_run1');
    else
    [rp_file1] = spm_select(1, 'any', 'Select IRM - rp session 1', [], pwd, 'rp.*_sovt_run1');
    [rp_file2] = spm_select(1, 'any', 'Select IRM - rp session 2', [], pwd, 'rp.*_sovt_run2');
    end
    
matlabbatch{1}.spm.stats.fmri_spec.dir = {foldernew};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
%%
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = images{1, 1}.scans{1,1};

%%
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Mov_Suff_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = [data.movieon(1,1)/1000 ; data.movieon(1,7)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = [data.movieduration(1,1)/1000; data.movieduration(1,7)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'Mov_Suff_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = [data.movieon(1,2)/1000; data.movieon(1,8)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = [data.movieduration(1,2)/1000; data.movieduration(1,8)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'Mov_Suff_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = [data.movieon(1,3)/1000; data.movieon(1,9)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = [data.movieduration(1,3)/1000; data.movieduration(1,9)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'Rest_Suff_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = [data.reston(1,2)/1000 ; data.reston(1,6)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name = 'Rest_Suff_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = [(data.reston(1,2)/1000)+30 ; (data.reston(1,6)/1000)+30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).name = 'Rest_Suff_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).onset = [(data.reston(1,2)/1000)+60 ; (data.reston(1,6)/1000)+60];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).name = 'Mov_Neu_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).onset = [data.movieon(1,4)/1000; data.movieon(1,10)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).duration = [data.movieduration(1,4)/1000; data.movieduration(1,10)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).name = 'Mov_Neu_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).onset = [data.movieon(1,5)/1000; data.movieon(1,11)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).duration = [data.movieduration(1,5)/1000; data.movieduration(1,11)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(9).name = 'Mov_Neu_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(9).onset = [data.movieon(1,6)/1000; data.movieon(1,12)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(9).duration = [data.movieduration(1,6)/1000; data.movieduration(1,12)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(9).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(9).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(10).name = 'Rest_Neu_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(10).onset = [data.reston(1,4)/1000 ; data.reston(1,8)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(10).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(10).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(10).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(11).name = 'Rest_Neu_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(11).onset = [(data.reston(1,4)/1000)+30 ; (data.reston(1,8)/1000)+30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(11).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(11).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(11).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(12).name = 'Rest_Neu_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(12).onset = [(data.reston(1,4)/1000)+60 ; (data.reston(1,8)/1000)+60];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(12).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(12).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(12).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(13).name = 'Instruc_Rest';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(13).onset = [(data.reston(1,[2,4,6,8])'/1000)-4];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(13).duration = [4;4;4;4];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(13).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(13).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(13).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(14).name = 'Instruc_Film';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(14).onset = [(data.movieon(1,[4,7,10])'/1000)-4];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(14).duration = [4;4;4];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(14).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(14).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(14).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(15).name = 'Croix de fix_start';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(15).onset = [t_croix_start(1,1)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(15).duration = [data.croixduration(1,1)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(15).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(15).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(15).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {rp_file1};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 256;

%%
matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = images{1, 1}.scans{1,2};

%%
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'Mov_Suff_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = [data1.movieon(1,4)/1000; data1.movieon(1,10)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = [data1.movieduration(1,4)/1000;data1.movieduration(1,10)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'Mov_Suff_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = [data1.movieon(1,5)/1000;data1.movieon(1,11)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = [data1.movieduration(1,5)/1000;data1.movieduration(1,11)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = 'Mov_Suff_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = [data1.movieon(1,6)/1000;data1.movieon(1,12)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = [data1.movieduration(1,6)/1000;data1.movieduration(1,12)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).name = 'Rest_Suff_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).onset = [data1.reston(1,4)/1000 ; data1.reston(1,8)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).name = 'Rest_Suff_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).onset = [(data1.reston(1,4)/1000)+30 ; (data1.reston(1,8)/1000)+30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).name = 'Rest_Suff_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).onset = [(data1.reston(1,4)/1000)+60 ; (data1.reston(1,8)/1000)+60];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).name = 'Mov_Neu_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).onset = [data1.movieon(1,1)/1000;data1.movieon(1,7)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).duration = [data1.movieduration(1,1)/1000;data1.movieduration(1,7)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).name = 'Mov_Neu_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).onset = [data1.movieon(1,2)/1000;data1.movieon(1,8)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).duration = [data1.movieduration(1,2)/1000;data1.movieduration(1,8)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(9).name = 'Mov_Neu_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(9).onset = [data1.movieon(1,3)/1000;data1.movieon(1,9)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(9).duration = [data1.movieduration(1,3)/1000;data1.movieduration(1,9)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(9).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(9).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(10).name = 'Rest_Neu_1';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(10).onset = [data1.reston(1,2)/1000 ; data1.reston(1,6)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(10).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(10).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(10).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(11).name = 'Rest_Neu_2';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(11).onset = [(data1.reston(1,2)/1000)+30 ; (data1.reston(1,6)/1000)+30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(11).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(11).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(11).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(12).name = 'Rest_Neu_3';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(12).onset = [(data1.reston(1,2)/1000)+60 ; (data1.reston(1,6)/1000)+60];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(12).duration = [30;30];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(12).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(12).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(13).name = 'Instruc_Rest';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(13).onset = [(data1.reston(1,[2,4,6,8])'/1000)-4];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(13).duration = [4;4;4;4];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(13).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(13).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(13).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(14).name = 'Instruc_Film';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(14).onset = [(data1.movieon(1,[4,7,10])'/1000)-4];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(14).duration = [4;4;4];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(14).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(14).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(14).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(15).name = 'Croix de fix_start';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(15).onset = [t_croix_start1(1,1)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(15).duration = [data1.croixduration(1,1)/1000];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(15).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(15).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(15).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {rp_file2};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 256;

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    

cd (foldernew)

	[job_id, mod_job_idlist] = cfg_util('initjob',matlabbatch);
    cfg_util('savejob', job_id, 'first_level_job.m');
    clear matlabbatch;

    
   