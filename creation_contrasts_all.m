function creation_contrasts_all(sujet_code)

%creation_contrasts
%Seb Baez Aout 2018
%ex: creation_contrasts ('s001')

% mov_suff_1 = [1,zeros(1,20),1,0] 
% mov_suff_2 = [0,1,zeros(1,20),1,0] 
% mov_suff_3 = [0,0,1,zeros(1,20),1,0] 
% 
% res_suff_1 = [0,0,0,1,zeros(1,20),1,0] 
% res_suff_2 = [0,0,0,0,1,zeros(1,20),1,0] 
% res_suff_3 = [0,0,0,0,0,1,zeros(1,20),1,0] 
% 
% mov_neu_1 = [0,0,0,0,0,0,1,zeros(1,20),1,0] 
% mov_neu_2 = [0,0,0,0,0,0,0,1,zeros(1,20),1,0] 
% mov_neu_3 = [0,0,0,0,0,0,0,0,1,zeros(1,20),1,0] 
% 
% res_neu_1 = [0,0,0,0,0,0,0,0,0,1,zeros(1,20),1,0] 
% res_neu_2 = [0,0,0,0,0,0,0,0,0,0,1,zeros(1,20),1,0] 
% res_neu_3 = [0,0,0,0,0,0,0,0,0,0,0,1,zeros(1,20),1,0] 


spm('defaults','fmri');
global defaults;
spm_jobman('initcfg');
job = 1;

tmp = pwd;
folder = fullfile(tmp,sujet_code);
% folder = fullfile(tmp,sujet_code,'reordered');
cd(folder)

%     [SPM_file] = spm_select(1, 'any', 'Select SPM_matrix', [], pwd, 'SPM.mat');
     [SPM_file] = [pwd,   '\SPM.mat'];
    
matlabbatch{1}.spm.stats.con.spmmat = {SPM_file};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Mov_suff_1';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Mov_suff_2';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Mov_suff_3';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Rest_suff_1';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Rest_suff_2';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Rest_suff_3';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'Mov_neu_1';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'Mov_neu_2';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'Mov_neu_3';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'Rest_neu_1';
matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'Rest_neu_2';
matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'Rest_neu_3';
matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'Suff_Neu';
matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = [1 1 1 0 0 0 -1 -1 -1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 -1 -1 -1 0];
matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'Neu_Suff';
matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = [-1 -1 -1 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 -1 -1 -1 0 0 0 1 1 1 0];
matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'Rest_Suff_Neu';
matlabbatch{1}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 1 1 1 0 0 0 -1 -1 -1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 -1 -1 -1 0];
matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{16}.tcon.name = 'Rest_Neu_Suff';
matlabbatch{1}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 -1 -1 -1 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 -1 -1 -1 0 0 0 1 1 1 0];
matlabbatch{1}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{17}.tcon.name = 'Mov_suff';
matlabbatch{1}.spm.stats.con.consess{17}.tcon.weights = [1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0];
matlabbatch{1}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{18}.tcon.name = 'Rest_suff';
matlabbatch{1}.spm.stats.con.consess{18}.tcon.weights = [0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0];
matlabbatch{1}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{19}.tcon.name = 'Mov_neu';
matlabbatch{1}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0];
matlabbatch{1}.spm.stats.con.consess{19}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{20}.tcon.name = 'Rest_neu';
matlabbatch{1}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0];
matlabbatch{1}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{21}.tcon.name = 'Mov_rest_suff';
matlabbatch{1}.spm.stats.con.consess{21}.tcon.weights = [1 1 1 -1 -1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 -1 -1 -1 0];
matlabbatch{1}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{22}.tcon.name = 'Mov_rest_neu';
matlabbatch{1}.spm.stats.con.consess{22}.tcon.weights = [0 0 0 0 0 0 1 1 1 -1 -1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 -1 -1 -1 0];
matlabbatch{1}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{23}.fcon.name = 'F';
matlabbatch{1}.spm.stats.con.consess{23}.fcon.weights = [repmat([eye(12) zeros(12, 9)],1,2) zeros(12,2)];
matlabbatch{1}.spm.stats.con.consess{23}.fcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 0;


	[job_id, mod_job_idlist] = cfg_util('initjob',matlabbatch);
    cfg_util('savejob', job_id, 'contrasts_job.m');
    output_part = spm_jobman('run',matlabbatch);
    clear matlabbatch;

    


