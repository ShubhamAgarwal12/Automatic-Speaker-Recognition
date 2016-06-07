function [f, tmp]=fgammaton(sig, gamma, sampFreq, numChannel)
% Filter input signal with a gammatone filterbank and generate GF features
% sig: input signal
% gamma: gammtone filter impulse responses
% sampFreq: sampling frequency
% numChannel: number of channels
% Written by Yang Shao, and adapted by Xiaojia Zhao in Oct'11

[ignore,stepBound]=size(sig);

d = 2^ceil(log2(length(sig)));

tmp =ifft((fft((ones(numChannel,1)*sig)',d).*fft(gamma(:,1:stepBound)',d)));

f=(abs(resample(abs(tmp(1:stepBound,:)),100,sampFreq)')).^(1/3);
