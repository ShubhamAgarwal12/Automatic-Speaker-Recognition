function gmmModel=func_gmmTrain(trainCell, gmmParams)

NumMixtures = gmmParams.NumMixtures;
NumKmeans   = gmmParams.NumKmeans;
RegFactor   = gmmParams.RegFactor;



%% =============== GMM train ================= %%
NumClass   = size(trainCell, 1);

gmmModel = cell(NumClass, 1);

h = waitbar(0,'training GMM models');
for idxClass = 1:NumClass
    waitbar(idxClass/NumClass,h);
    currClassData = trainCell{idxClass,1};
    
    % ----- initialize -----
    warning('off','stats:kmeans:FailedToConvergeRep');
    clusterIdx = kmeans(currClassData, NumMixtures, 'replicates', NumKmeans);
%     warning('on','all');
    
    % ----- train -----
    options = statset('MaxIter',200);
    gmmModel{idxClass} = gmdistribution.fit(currClassData, NumMixtures,...
        'CovType','diagonal','Start',clusterIdx,'Regularize',RegFactor,'Options',options);
    
    
end
delete(h);



