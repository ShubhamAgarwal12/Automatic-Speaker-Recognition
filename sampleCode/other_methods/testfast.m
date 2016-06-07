 %NOISE_SNR  = 'clean';
 %NOISE_SNR  = '10dB';
NOISE_SNR  = '05dB';

tmp = load(['testList_' NOISE_SNR], GENDER);
testList = tmp.(GENDER);

NumTestData = length(testList);
testData10 = cell(NumTestData,1);
testData20 = cell(NumTestData,1);
testData30 = cell(NumTestData,1);
testData40 = cell(NumTestData,1);
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
    snd=WienerScalart96(snd,Fs);
    
    
    %-------------------------
    % Extract features
    %-------------------------
    % GFCC FEATURES
    gt = gen_gammaton(Fs, 64);  % get gammatone filterbank
    sig = reshape(snd, 1, length(snd));
    g=fgammaton(sig, gt, Fs, 64);
 
        gfcc10 = gtf2gtfcc(g(:, :), 2, 10)';
        cmvn_gfcc10 = cmvn(gfcc10',true);
        feature_warped_gfcc10 = fea_warping(cmvn_gfcc10,301);
        currFeatures10 = feature_warped_gfcc10';
        
        gfcc20 = gtf2gtfcc(g(:, :), 2, 20)';
        cmvn_gfcc20 = cmvn(gfcc20',true);
        feature_warped_gfcc20 = fea_warping(cmvn_gfcc20,301);
        currFeatures20 = feature_warped_gfcc20';
        
        gfcc30 = gtf2gtfcc(g(:, :), 2, 30)';
        cmvn_gfcc30 = cmvn(gfcc30',true);
        feature_warped_gfcc30 = fea_warping(cmvn_gfcc30,301);
        currFeatures30 = feature_warped_gfcc30';
        
        gfcc40 = gtf2gtfcc(g(:, :), 2, 40)';
        cmvn_gfcc40 = cmvn(gfcc40',true);
        feature_warped_gfcc40 = fea_warping(cmvn_gfcc40,301);
        currFeatures40 = feature_warped_gfcc40';
    
    testData10{i,1} = currFeatures10;
    testData20{i,1} = currFeatures20;
    testData30{i,1} = currFeatures30;
    testData40{i,1} = currFeatures40;
end

%-------------------------
% Predict the speaker from GMMs
%-------------------------
fprintf('classifying...\n');
predLabel10=func_gmmTest(gmmModel10, testData10);
predLabel20=func_gmmTest(gmmModel20, testData20);
predLabel30=func_gmmTest(gmmModel30, testData30);
predLabel40=func_gmmTest(gmmModel40, testData40);

%%
% ---------------------------------
%   Performance Evaluation
% ---------------------------------
tmp = load('testLabel', GENDER);
testLabel = tmp.(GENDER);

fprintf('evaluating...\n');
tf10 = testLabel ~= predLabel10;
tf20 = testLabel ~= predLabel20;
tf30 = testLabel ~= predLabel30;
tf40 = testLabel ~= predLabel40;
errRate10 = mean( tf10(:) );
errRate20 = mean( tf20(:) );
errRate30 = mean( tf30(:) );
errRate40 = mean( tf40(:) );
fprintf(' ==> Error Rate 10: %.2f %%\n', errRate10*100);
fprintf(' ==> Error Rate 20: %.2f %%\n', errRate20*100);
fprintf(' ==> Error Rate 30: %.2f %%\n', errRate30*100);
fprintf(' ==> Error Rate 40: %.2f %%\n', errRate40*100);

toc