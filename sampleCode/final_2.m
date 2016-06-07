function predLabel=final_2(path_name,GENDER)
% ------------------------------------
%   Sample System for EE214B Project
% ------------------------------------
%   Speaker Identification
%   
%   Soo Jin Park (sj.park@ucla.edu)
%   May-04-2016
% ------------------------------------
tic
addpath('../msr-identity/');
addpath('../gfcc-dependencies/');



%%

ftrParams.WINsec  = 0.020;
ftrParams.STEPsec = 0.010;

ftrParams.numCeps = 20;
ftrParams.numFilt = [];

gmmParams.NumMixtures = 16;
gmmParams.NumKmeans   = 10;
gmmParams.RegFactor   = 1e-06;

%%
MatLabInfo    = ver('matlab');
MatLabVersion = MatLabInfo.Version;

%%
% ---------------------------------
%   Train
% ---------------------------------
tmp = load('trainList', GENDER);
trainList = tmp.(GENDER);

trainData = cell(length(trainList),1);
fprintf('extracting features...\n');
for nSpk = 1:length(trainList)
    
    currSpkList = trainList{nSpk};
    currSpkData = [];
    for i=1:length(currSpkList)
        
        %-------------------------
        % Read a sound file
        %-------------------------
        currFile = currSpkList{i};
        currFile = strrep(currFile,'\','/');
        display(currFile)
        if MatLabVersion < 8.0
            [snd,Fs] = wavread(currFile);
        else
            [snd,Fs] = audioread(currFile);
        end
        %snd=WienerScalart96(snd,Fs);
        
        
        %-------------------------
        % Extract features
        %-------------------------
        % GFCC FEATURES
        gt = gen_gammaton(Fs, 32);% get gammatone filterbank
        sig = reshape(snd, 1, length(snd));
        
        g=fgammaton(sig, gt, Fs, 32);
        gfcc = gtf2gtfcc(g(:, :), 2, 23)';
        cmvn_gfcc = cmvn(gfcc',true);
        feature_warped_gfcc = fea_warping(cmvn_gfcc,301);
        currFeatures = feature_warped_gfcc';
        
        % MFCC FEATURES (for comparison)
        %mfcc = get_MFCC(snd,Fs, ftrParams);
        %currFeatures = mfcc;
        
       
        %-------------------------
        % Concatenate features from the same speaker
        %-------------------------
        
        
        currSpkData = cat(1, currSpkData, currFeatures);
    end
    
    trainData{nSpk,1} = currSpkData;
end

%-------------------------
% Train Gaussian Mixture Model
%-------------------------
fprintf('training GMM model...\n');
gmmModel=func_gmmTrain(trainData, gmmParams);


%%
% ---------------------------------
%   Test
% ---------------------------------
testData = cell(1,1);
fprintf('extracting features...\n');



%-------------------------
% Read a sound file
%-------------------------
currFile = path_name;
currFile = strrep(currFile,'\','/');
if MatLabVersion < 8.0
    [snd,Fs] = wavread(currFile);
else
    [snd,Fs] = audioread(currFile);
end
    
    
    
%-------------------------
% Extract features
%-------------------------

% GFCC FEATURES
gt = gen_gammaton(Fs, 32);  % get gammatone filterbank
sig = reshape(snd, 1, length(snd));
g=fgammaton(sig, gt, Fs, 32);
gfcc = gtf2gtfcc(g(:, :), 2, 23)';
    
%get CMVN
cmvn_gfcc = cmvn(gfcc',true);
    
%perform feature warping
feature_warped_gfcc = fea_warping(cmvn_gfcc,301);
currFeatures = feature_warped_gfcc';
testData{1,1} = currFeatures;
    
%------------------------------
% Predict the speaker from GMMs
%------------------------------
fprintf('classifying...\n');
predLabel=func_gmmTest(gmmModel, testData);

display(predLabel);

toc
end