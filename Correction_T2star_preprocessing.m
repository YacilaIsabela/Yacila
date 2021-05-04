function Correction_T2star_preprocessing(tr_value,voxels_size, sujet_code)
%
% script Fred & Seb 27/02/2017
% enlevement du slice timing Seb 24/04/17
%----------------------------------------------------------

% Ex: Correction_T2star_preprocessing(2.0,[3 3 3.6],'s001')

% batch spm12 irmf pre-traitement - BL 08092016
% pre-traitement protocole 

% 0- get data
% 1- acquisition descending : slice timing => aawell*sovt*
% 2- recalage des series fonctionnelles : mean only => meanaawell*sovt_run1
% 3- recalage de la t2 sur la t1
% 4- recalage de la t2* sur la t2
% 5- recalage de la mean fonctionnelle sur la t2* 

% data dans l'espace "T2* natif" :
% 6- normalisation estimate and write de la mean fonctionnelle sur le template t2* 
% 	avec ecriture des fonctionnelle normalisee sur la t2* => waawell*sovt*
% 7- ecriture de la mean des fonctionnelles normalisee sur la t2* => wmeanaawell*sovt_run1

% data dans l' espace MNI :
% 8- segmentation de l'irm VBM faite au pr??alable => y_anat_t1
% 9- normalize des fonctionnelles 2 2 2 => wwaawell*sovt*
% 10- normalize de la mean des fonctionnelles 2 2 2 => wwmeanaawell*sovt_run1
% 11- smooth 3D a 8 mm => swwaawell*sovt*

% Masque de Gris Fonctionnelle
% 12- normalisation normalisation de la t2* => wt2*
% 13 segmentation de la wt2* => c1wt2* 


% config spm
% emi_configspm12;

spm('defaults','fmri');
global defaults;
spm_jobman('initcfg');


job = 1;

tmp = pwd;
folder = fullfile(tmp,sujet_code);
cd(folder)

% ---------------------------------------------------------------
% etape 0 : get images
% ---------------------------------------------------------------
        % get number of subjects/sessions
        %nsessions = spm_input('Number of subjects/sessions',1, 'e', 1);
    nsessions = 2;

	ndyn=zeros(1,nsessions);
	
	for i = 1: nsessions,
		% Choose the images
        
		clear tmp_exp;
		tmp_exp = ['^awell.*_sovt_run' num2str(i) '.*$'];
		clear files;
		[files] = spm_select(Inf,'image',...
			['Select functional images for session ' num2str(i)],[], pwd, tmp_exp, [1 Inf]);
	
		[nfiles,m] = size(files);
        ndyn(i) = nfiles;
		tmp_files = cell(nfiles,1);
		for j = 1:nfiles,
			tmp_files{j}=deblank(files(j,:));
			matlabbatch{1}.spm.temporal.st.scans{1,i}{j,1} = tmp_files{j};
		end
		
	end;
	
[t1_file] = spm_select(1, 'image', 'Select IRM - T1', [], pwd, '^awell.*_anat_t1.*$');
[t2_file] = spm_select(1, 'image', 'Select IRM - T2', [], pwd, '^awell.*_anat_t2\..*$');
[t2star_file] = spm_select(1, 'image', 'Select IRM - T2* (anat series)', [], pwd, '^awell.*anat_t2star.*$');

% -----------------------------------------------------------------------------
% etape 1 : slice timing des fonctionnelles : Ecriture des aawell*_activation.nii
% -----------------------------------------------------------------------------

% les fonctionnelles recalees


% proto 

p=files(1,:);
vol =spm_vol(p);
nb_slices=vol.dim(3);

tr = tr_value;
so = [nb_slices:-1:1];

matlabbatch{1}.spm.temporal.st.nslices = nb_slices;
matlabbatch{1}.spm.temporal.st.tr = tr;
ta = tr-(tr/nb_slices);
matlabbatch{1}.spm.temporal.st.ta = round(ta*10000)/10000;
matlabbatch{1}.spm.temporal.st.so = so;
matlabbatch{1}.spm.temporal.st.refslice = so(1,ceil(nb_slices/2)); %rang/2 du nb_slices;
matlabbatch{1}.spm.temporal.st.prefix = 'x';


% ---------------------------------------------------------------------------------------------------------------------
% etape 2 : recalage (estimation et reslice) des fonctionnelles entre elles : Ecriture de la meanaawell*_activation.nii
% ---------------------------------------------------------------------------------------------------------------------
% recalage des fonctionnelles entre elles

% fonctionnelle a recaler
	for i = 1: nsessions,
		for j = 1:ndyn(i),
			clear tmp;
			tmp = matlabbatch{1}.spm.temporal.st.scans{1,i}{j,1}; %{1,s}{f,1}
			[pth,nam,ext] = fileparts(tmp);
			clear sl_tmp; 
			sl_tmp = fullfile(pth,['' nam ext]); %enlev? le 'a' car il ajoutait le 'a' aux images afin de les trouver dans les fichiers
			matlabbatch{2}.spm.spatial.realign.estwrite.data{1,i}{j,1}= sl_tmp;
			 
		end
	end;


matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality=0.9;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep= 4;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm=5; % PET : 7mm et IRM : 5mm.
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm=0; % PET : 1 et IRM : 0.
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp=2; % 2nd Degree B-Spline -> 7
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap=[0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight={};
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which= [0 1]; % [2 1] : All Images + Mean Image  ou [0 1] : Mean Image Only
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp= 4; % 4th Degree B-Spline -> 7
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap= [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask= 1;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';

% ---------------------------------------------------------------------
%  etape 3 : estimation du recalage la T2 sur la T1
% ---------------------------------------------------------------------
matlabbatch{3}.spm.spatial.coreg.estimate.ref= {t1_file};
matlabbatch{3}.spm.spatial.coreg.estimate.source= {t2_file};

matlabbatch{3}.spm.spatial.coreg.estimate.other= {''};
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun='nmi'; % Normalised Mutual Information
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep= [4 2];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol= [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm=[7 7];


% --------------------------------------------------------------------------------------------------
%  etape 4 : estimation du recalage de la T2* sur la T2
% --------------------------------------------------------------------------------------------------
matlabbatch{4}.spm.spatial.coreg.estimate.ref{1,1} = t2_file;
matlabbatch{4}.spm.spatial.coreg.estimate.source{1,1} = t2star_file;

matlabbatch{4}.spm.spatial.coreg.estimate.other= {''};
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.cost_fun='nmi'; % Normalised Mutual Information
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.sep= [4 2];
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.tol= [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.fwhm=[7 7];

% ------------------------------------------------------------------------------------------
%  etape 5 : estimation du recalage de la mean fonctionnelle sur la T2*
% ------------------------------------------------------------------------------------------
clear tmp;
tmp = matlabbatch{2}.spm.spatial.realign.estwrite.data{1,1}{1,1};
[pth,nam,ext] = fileparts(tmp);
clear mean_tmp; 
mean_tmp = fullfile(pth,['mean' nam ext]);

matlabbatch{5}.spm.spatial.coreg.estimate.ref{1,1}= t2star_file;
matlabbatch{5}.spm.spatial.coreg.estimate.source{1,1}= mean_tmp;

k=0;
	for i = 1: nsessions,
		for j = 1:ndyn(i),
			k=k+1;
			clear tmp;
			tmp = matlabbatch{2}.spm.spatial.realign.estwrite.data{1,i}{j,1};
			matlabbatch{5}.spm.spatial.coreg.estimate.other{k,1}= tmp; 
		end
	end;

matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.cost_fun='nmi'; % Normalised Mutual Information
matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.sep= [4 2];
matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.tol= [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.fwhm=[7 7];


% -------------------------------------------------------------------------------------------------------------------------------
%  etape 6 : normalisation de la mean fonctionnelle sur la T2* : ??criture des meanaawell*_activation_sn.mat et wwaawell*activation.nii
% -------------------------------------------------------------------------------------------------------------------------------

matlabbatch{6}.spm.tools.oldnorm.estwrite.subj.source{1,1}=mean_tmp;
matlabbatch{6}.spm.tools.oldnorm.estwrite.subj.wtsrc={};
%matlabbatch{6}.spm.tools.oldnorm.estwrite.subj.resample ; cell 801 rafimapt1s009*


matlabbatch{6}.spm.tools.oldnorm.estwrite.subj.resample = matlabbatch{5}.spm.spatial.coreg.estimate.other;

matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.template{1,1}=t2star_file;
matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.weight={''};
matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.smosrc=4;
matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.smoref=4;
matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.regtype='subj';
matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.cutoff=25;
matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.nits=16;
matlabbatch{6}.spm.tools.oldnorm.estwrite.eoptions.reg=1;

matlabbatch{6}.spm.tools.oldnorm.estwrite.roptions.preserve=0;
matlabbatch{6}.spm.tools.oldnorm.estwrite.roptions.bb=[-90 -120 -100 ; 90 120 100];
%matlabbatch{6}.spm.tools.oldnorm.estwrite.roptions.vox=[2.8 2.8 2.8];
matlabbatch{6}.spm.tools.oldnorm.estwrite.roptions.vox= voxels_size;
matlabbatch{6}.spm.tools.oldnorm.estwrite.roptions.interp=7;
matlabbatch{6}.spm.tools.oldnorm.estwrite.roptions.wrap=[0 0 0];
matlabbatch{6}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';

% -----------------------------------------------------------------------------------------------
%  etape 7 : ecriture  de la mean fonctionnelle normalisee sur la T2* : wmeanaawell*_activation.nii
% -----------------------------------------------------------------------------------------------
[pth,nam,ext] = fileparts(mean_tmp);
clear mean_matname; 
mean_matname = fullfile(pth,[nam '_sn.mat']);

matlabbatch{7}.spm.tools.oldnorm.write.subj.matname{1,1} = mean_matname;
matlabbatch{7}.spm.tools.oldnorm.write.subj.resample{1,1} = mean_tmp;
matlabbatch{7}.spm.tools.oldnorm.write.roptions.preserve = 0;
matlabbatch{7}.spm.tools.oldnorm.write.roptions.bb = [-90 -120 -100 ; 90 120 100];
%matlabbatch{7}.spm.tools.oldnorm.write.roptions.vox = [2.8 2.8 2.8];
matlabbatch{7}.spm.tools.oldnorm.write.roptions.vox = voxels_size;
matlabbatch{7}.spm.tools.oldnorm.write.roptions.interp = 1;
matlabbatch{7}.spm.tools.oldnorm.write.roptions.wrap = [0 0 0];
matlabbatch{7}.spm.tools.oldnorm.write.roptions.prefix = 'w';

% -----------------------------------------------------------------------------------------------
% etape 9 : ecriture des fonctionnelles normalisees dans MNI : ecriture de wwaawell*activation.nii
% -----------------------------------------------------------------------------------------------
clear tmp;
tmp = t1_file;
[pth,nam,ext] = fileparts(tmp);
clear mat_tmp; 
mat_tmp = fullfile(pth,['y_' nam '.nii']);


matlabbatch{8}.spm.spatial.normalise.write.subj.def{1,1} = mat_tmp;
matlabbatch{8}.spm.spatial.normalise.write.woptions.vox = [2 2 2];%faut il changer a 3x3x3 ???
matlabbatch{8}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70;78 76 85];
matlabbatch{8}.spm.spatial.normalise.write.woptions.interp = 1;
k=0;
	for i = 1: nsessions,
		for j = 1:ndyn(i),
			k=k+1;
			clear tmp;
			tmp = matlabbatch{2}.spm.spatial.realign.estwrite.data{1,i}{j,1};
			[pth,nam,ext] = fileparts(tmp);
			clear recal_tmp; 
			recal_tmp = fullfile(pth,['w' nam ext]);
			matlabbatch{8}.spm.spatial.normalise.write.subj.resample{k,1}= recal_tmp; 

		end
	end;



% -----------------------------------------------------------------------------------------------
% etape 10 : ecriture de la mean  : ecriture des wwmeanaawell*activation.nii
% -----------------------------------------------------------------------------------------------
[pth,nam,ext] = fileparts(mean_tmp);
clear wmean_tmp; 
wmean_tmp = fullfile(pth,['w' nam ext]);

clear tmp;
tmp = t1_file;
[pth,nam,ext] = fileparts(tmp);

matlabbatch{9}.spm.spatial.normalise.write.subj.def{1,1} = mat_tmp;
matlabbatch{9}.spm.spatial.normalise.write.woptions.vox = [2 2 2]; %faut il changer a 3x3x3 ???
matlabbatch{9}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70;78 76 85];
matlabbatch{9}.spm.spatial.normalise.write.subj.resample{1,1} = wmean_tmp;
%matlabbatch{9}.spm.spatial.normalise.write.subj.resample{2} = biais_tmp;
matlabbatch{9}.spm.spatial.normalise.write.subj.resample{2,1} = tmp;
matlabbatch{9}.spm.spatial.normalise.write.woptions.interp = 1;

% -----------------------------------------------------------------------------------------------
% etape 11 : smooth 8 mm des fonctionnelles   : ecriture des swwaawell*activation.nii
% -----------------------------------------------------------------------------------------------
k = 0;
% smooth des fonctionnelles normalisees
	for i = 1: nsessions,
		for j = 1:ndyn(i),
			k = k+1;
			clear tmp;
			tmp = matlabbatch{8}.spm.spatial.normalise.write.subj.resample{k,1};
			[pth,nam,ext] = fileparts(tmp);
			clear norm_tmp; norm_tmp = fullfile(pth,['w' nam ext]);
			matlabbatch{10}.spm.spatial.smooth.data{k,1}= norm_tmp; 
		end
	end;

matlabbatch{10}.spm.spatial.smooth.fwhm= [8 8 8];
matlabbatch{10}.spm.spatial.smooth.dtype = 0;
matlabbatch{10}.spm.spatial.smooth.im = 0;
matlabbatch{10}.spm.spatial.smooth.prefix = 's';


% -----------------------------------------------------------------------------------------------
% etape 12 : ecriture de la T2* normalisee: utilisation des parametres de norm calculees de la segmentation
% -----------------------------------------------------------------------------------------------

clear tmp;
tmp = t1_file;
[pth,nam,ext] = fileparts(tmp);
clear mat_tmp; 
mat_tmp = fullfile(pth,['y_' nam '.nii']);
matlabbatch{11}.spm.spatial.normalise.write.subj.def{1,1} = mat_tmp;
matlabbatch{11}.spm.spatial.normalise.write.woptions.vox = [2 2 2];%faut il changer a 3x3x3 ???
matlabbatch{11}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70;78 76 85];
matlabbatch{11}.spm.spatial.normalise.write.subj.resample{1,1}= t2star_file;
matlabbatch{11}.spm.spatial.normalise.write.woptions.interp = 1;


% ------------------------------------------------------
% etape 13 : segmentation de la t2* normalisee 
% ------------------------------------------------------
[pth,nam,ext] = fileparts(t2star_file);
clear wt2star_f;
wt2star_f = fullfile(pth,['w' nam ext]);

matlabbatch{12}.spm.tools.oldseg.data{1,1}=wt2star_f;
matlabbatch{12}.spm.tools.oldseg.output.GM=[0 0 1]; % [0 0 1] pour Native Space ou [0 1 1] pour Native + Unmodulated Normalised
matlabbatch{12}.spm.tools.oldseg.output.WM=[0 0 0]; % Native Space
matlabbatch{12}.spm.tools.oldseg.output.CSF=[0 0 0]; % None
matlabbatch{12}.spm.tools.oldseg.output.biascor=0; % bias corrected version of your image
matlabbatch{12}.spm.tools.oldseg.output.cleanup=2; % 

matlabbatch{12}.spm.tools.oldseg.opts.tpm{1,1}=fullfile(spm('Dir'),'\toolbox\OldSeg\grey.nii');
matlabbatch{12}.spm.tools.oldseg.opts.tpm{2,1}=fullfile(spm('Dir'),'\toolbox\OldSeg\white.nii');
matlabbatch{12}.spm.tools.oldseg.opts.tpm{3,1}=fullfile(spm('Dir'),'\toolbox\OldSeg\csf.nii');

matlabbatch{12}.spm.tools.oldseg.opts.ngaus= [2 2 2 4];
matlabbatch{12}.spm.tools.oldseg.opts.regtype= 'mni';
matlabbatch{12}.spm.tools.oldseg.opts.warpreg= 1; % Warping Regularisation
matlabbatch{12}.spm.tools.oldseg.opts.warpco= 25; % Warp Frequency Cutoff : Cutoff of DCT bases. 
matlabbatch{12}.spm.tools.oldseg.opts.biasreg= 1.0000e-04; % very light regularisation (0.0001)
matlabbatch{12}.spm.tools.oldseg.opts.biasfwhm= 60;
matlabbatch{12}.spm.tools.oldseg.opts.samp= 3;
matlabbatch{12}.spm.tools.oldseg.opts.msk = {''};


% -----------------------------------------------------------------
% SAVE AND RUN SPM12
% -----------------------------------------------------------------
	
	[job_id, mod_job_idlist] = cfg_util('initjob',matlabbatch);
        cfg_util('savejob', job_id, 'bl_imap12_sovt_sensevbmpretraite_job.m');
        %output_part = spm_jobman('run',matlabbatch);
	clear matlabbatch;

