% ------------------------------------
%   Sample System for EE214B Project
% ------------------------------------
%   Speaker Identification
%   
%   Soo Jin Park (sj.park@ucla.edu)
%   May-04-2016
% ------------------------------------

tic
% --------- Choose gender ----------
% GENDER =  'male';
 GENDER =  'female';

% --------- Choose SNR -------------
% NOISE_SNR  = 'clean';
 NOISE_SNR  = '10dB';
%NOISE_SNR  = '05dB';

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
        display(i);
        
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
        
        %gt = gen_gammaton(Fs, 2);  % get gammatone filterbank
        %sig = reshape(snd, 1, length(snd));
        %g=fgammaton(sig, gt, Fs, 2);
        %gfcc = gtf2gtfcc(g, 2, 23);
        
        %-------------------------
        % Extract features
        %-------------------------
        %mfcc = get_MFCC(snd,Fs, ftrParams);
        pncc = PNCC_IEEETran('noname.feat',currFile)';
        cmvn_pncc = cmvn(pncc',true);
        feature_warped_pncc = fea_warping(cmvn_pncc,301);
    
        currFeatures = feature_warped_pncc';
        display(size(currFeatures,1));
            
        %display(size(mfcc));
        
        %-------------------------
        % Concatenate features from the same speaker
        %-------------------------
        %currFeatures = mfcc;
        %currFeatures = pncc;
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
tmp = load(['testList_' NOISE_SNR], GENDER);
testList = tmp.(GENDER);

NumTestData = length(testList);
testData = cell(NumTestData,1);
fprintf('extracting features...\n');

for i = 1:NumTestData
    %-------------------------
    % Read a sound file
    %-------------------------
    currFile = testList{i};
    currFile = strrep(currFile,'\','/');
    if MatLabVersion < 8.0
        [snd,Fs] = wavread(currFile);
    else
        [snd,Fs] = audioread(currFile);
    end
    
    %-------------------------
    % Extract features
    %-------------------------
    %mfcc = get_MFCC(snd,Fs, ftrParams);
    pncc = PNCC_IEEETran('noname.feat',currFile)';
    cmvn_pncc = cmvn(pncc',true);
    feature_warped_pncc = fea_warping(cmvn_pncc,301);
    
    %currFeatures = mfcc;
    currFeatures = feature_warped_pncc';

    
    testData{i,1} = currFeatures;
end

%-------------------------
% Predict the speaker from GMMs
%-------------------------
fprintf('classifying...\n');
predLabel=func_gmmTest(gmmModel, testData);

%%
% ---------------------------------
%   Performance Evaluation
% ---------------------------------
tmp = load('testLabel', GENDER);
testLabel = tmp.(GENDER);

fprintf('evaluating...\n');
tf = testLabel ~= predLabel;
errRate = mean( tf(:) );
fprintf(' ==> Error Rate : %.2f %%\n', errRate*100);

toc