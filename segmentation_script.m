% batch spm12 irmf pre-traitement - BL 30/09/2014

% VERIFY and CHANGE the path of the tpm files according to the SPM file, Seb 27/17/2017

% 1- segment : modif bl de la proc??dure spm_preproc_write8.m pour ??crire les m0wc1 au lieu des mwc1
% 2- smooth 3D ?? 8 mm
% 3- normalisation des mIRMa
function segmentation_script (sujet_code)


spm('defaults','pet');
global defaults;
spm_jobman('initcfg');


job = 1;

tmp = pwd;
folder = fullfile(tmp,sujet_code);
cd(folder)
% ---------------------------------------------------------------
% Etape 1 : get IRMa images
% ---------------------------------------------------------------
	
[t1_files,status] = spm_select(Inf, 'image', 'Select IRM - T1', [], pwd, '^a.*_anat_t1.*$');
[nfiles,m] = size(t1_files);

% ----------------------------------------------------------------------------------------------
% Etape 2 : segmentation MNI de l'IRMa
% ----------------------------------------------------------------------------------------------
		tmp_files = cell(nfiles,1);
		for j = 1:nfiles 
			tmp_files{j}=deblank(t1_files(j,:));
			matlabbatch{1}.spm.spatial.preproc.channel.vols{j} = tmp_files{j};
		end

matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1]; % m ?
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'C:\Neuroimaging\spm12\tpm\TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1]; % c1 + rc1 (dartel)
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [1 1]; % wc1 et m0wc1
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'C:\Neuroimaging\spm12\tpm\TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1]; % c2 + rc2 (dartel)
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [1 1]; % wc2 et m0wc2
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'C:\Neuroimaging\spm12\tpm\TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 1]; % c3 + rc3 (dartel)
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [1 0]; % wc3
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'C:\Neuroimaging\spm12\tpm\TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'C:\Neuroimaging\spm12\tpm\TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'C:\Neuroimaging\spm12\tpm\TPM.nii,6'};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 2;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1]; % y_ et iy

% -----------------------------------------------------------------------------------------------
% Etape 3 : normalisation dans MNI des m IRMa
% -----------------------------------------------------------------------------------------------

		for j = 1:nfiles
			clear tmp;
			tmp =deblank(t1_files(j,:));
			[pth,nam,ext] = fileparts(tmp);
			clear ref_tmp; 
			ref_tmp = fullfile(pth,['y_' nam '.nii']);
			matlabbatch{2}.spm.spatial.normalise.write.subj(j).def = {ref_tmp}; 
			clear resample_tmp; 
			resample_tmp = fullfile(pth,['m' nam '.nii']);
			matlabbatch{2}.spm.spatial.normalise.write.subj(j).resample = {resample_tmp}; 
		end


matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
                                                          90 90 108];
matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [1.5 1.5 1.5];
matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 4;


% -----------------------------------------------------------------
% SAVE batch SPM12
% -----------------------------------------------------------------
	
	[job_id, mod_job_idlist] = cfg_util('initjob',matlabbatch);
        cfg_util('savejob', job_id, 'segmentation_job.m');
	clear matlabbatch;
