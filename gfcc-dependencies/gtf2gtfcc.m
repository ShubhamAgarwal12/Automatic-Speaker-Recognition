function [ outData ] = gtf2gtfcc( inData, ccST, ccEND )
% Apply DCT on GF features to get GFCC features
% ccST: low cut-off coefficient
% ccEND: high cut-off coefficient
% Written by Yang Shao, and adapted by Xiaojia Zhao in Oct'11

 [chnNum frmNum] = size(inData);

 mtx = dctmtx(chnNum);
 
 outData = mtx * inData;
 outData = outData(ccST:ccEND, :);
 
