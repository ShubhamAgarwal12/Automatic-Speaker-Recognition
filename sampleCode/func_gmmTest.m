function [predLabel] = func_gmmTest(gmmModel, testData, testLabel)

if nargin>2
    FIG = true;
else
    FIG = false;
end


NumClass = size(gmmModel,1);
NumTokens = size(testData,1);

predLabel = NaN*ones(NumTokens,1);
for nToken = 1:NumTokens
    currTestFeatures = testData{nToken,1};
    
    NumFrames = size(currTestFeatures, 1);
    

    likelihood = NaN*ones(NumFrames,NumClass);
    for iClass = 1:NumClass
        likelihood(:,iClass)=log(pdf(gmmModel{iClass,1}, currTestFeatures));
    end    
    meanLL = mean(likelihood,1);

    [~,maxIdx] = max(meanLL);
    predLabel(nToken) = maxIdx;

    % Plot the likelihood from each frame
    % for analysis
    if FIG
        h=plot(likelihood);
        
        LEGEND = strsplit( num2str(1:NumClass));
        legend(h, LEGEND, 'location', 'EastOutside');
        
        title(['Token ' num2str(nToken)]);
        
        xlabel('frame')
        ylabel('log-likelihood')
        
        trueIdx = testLabel(nToken);
        predIdx = predLabel(nToken);

        
        set(h(trueIdx), 'linewidth', 3);
        set(h(predIdx), 'marker','o'); % curr pred label
    end
    

end


end
