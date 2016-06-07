function gtfeatures(ctl_list, ext, sampFreq, bTrain, numChannel)
% Generate gammatone features (GF) and gammatone frequency cepstral
% coefficients (GFCC).

% ctl_list: list of files to be processed
% ext: extension to the filenames in the ctl_list, default is ''
% sampFreq: sampling frequency, default is 8000
% bTrain: boolean variable indicating whether training or test data is
%   being processed. Training data was stored in the WAV format, while test
%   data in ASCII format
% numChannel: number of channels

% Written by Yang Shao, and adapted by Xiaojia Zhao in Oct'11

if ~exist('ctl_list', 'var')
    fprintf(1, 'Input file list is missing!\n');
    exit;
end

if ~exist('ext', 'var')
    ext = '';
end

if ~exist('sampFreq', 'var')
    sampFreq = 8000;
end

if ~exist('bTrain', 'var')
    bTrain = 0;
end

if ~exist('numChannel', 'var')
    numChannel = 64;
end

fd=fopen(ctl_list,'r');
gt = gen_gammaton(sampFreq, numChannel);  % get gammatone filterbank

while feof(fd)==0
    
    tic
    
    entry=fscanf(fd,'%s\n',1);
    fprintf('%s',entry); fprintf('\n');

    if bTrain == 1
        rawfd = fopen(strcat(entry, '.wav'));     % Training files are stored in the WAV format
        [sig, count] = fread(rawfd, inf, 'int16');
        sig = sig(23:end);
        fclose(rawfd);
    else
        entry = [entry, ext];   % Test files are stored in the ASCII format
        sig = dlmread(entry);
    end
    
    
    sig = reshape(sig, 1, length(sig));  % gammatone filtering function requires input to be row vector
    
    fprintf('file read'); fprintf('\n');
    
    g=fgammaton(sig, gt, sampFreq, numChannel);     % gammatone filter pass and decimation to get GF features
    fprintf('gammatone filtered'); fprintf('\n');
    
    gfcc = gtf2gtfcc(g(11:end, :), 2, 23);  % apply dct to get GFCC features with first 10 channels of GF excluded which correspond to freq. range < 200 Hz
    
    writeHTK(strcat(entry,'.gtf'), g(11:end, :));     % write GF features

    writeHTK(strcat(entry,'.gtfcc'), gfcc);     % write GFCC features
    
    fprintf('output written'); fprintf('\n');
    
    clear g sig
    fprintf('time consumed: %f (sec)',toc); fprintf('\n');
        
end
fclose(fd);
