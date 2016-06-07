function a = cochleagram(r, winLength)
% Generate a cochleagram from responses of a Gammatone filterbank.
% It gives the log energy of T-F units
% The first variable is required.
% r: gammatone filter responses
% winLength: window (frame) length in samples
% Written by ZZ Jin, and adapted by Xiaojia Zhao in Sep'11

if nargin < 2
    winLength = 160;      % default window length in sample points which is 20 ms for 8 KHz sampling frequency
end

[numChan,sigLength] = size(r);     % number of channels and input signal length

winShift = winLength/2;            % frame shift (default is half frame)
increment = 1;
M = floor(sigLength/winShift);     % number of time frames

% calculate energy for each frame in each channel
a = zeros(numChan,M);
for m = 1:M      
    for i = 1:numChan
        if m == M
            a(i, m) = r(i, (M-1)*winShift + 1 : end) * r(i, (M-1)*winShift + 1 : end)';
        else
            startpoint = (m-increment)*winShift;
            a(i,m) = r(i,startpoint+1:startpoint+winLength)*r(i,startpoint+1:startpoint+winLength)';
        end
    end
end
