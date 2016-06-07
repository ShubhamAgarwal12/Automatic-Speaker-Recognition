function gt = gen_gammaton(sampFreq, numChannel)
% Create gammatone filterbank
% Written by Yang Shao, and adapted by Xiaojia Zhao in Oct'11

if ~exist('sampFreq', 'var')
    sampFreq = 8000; % sampling frequency, default is 8000
end


if  ~exist('numChannel', 'var')
    numChannel = 64; % number of channels, default is 64
end


stepBound=100000; 

filterOrder=4;     % filter order

phase(1:numChannel)=zeros(numChannel,1);        % original phase
erb_b=hz2erb([50,sampFreq/2]);       % upper and lower bound of ERB
erb=[erb_b(1):diff(erb_b)/(numChannel-1):erb_b(2)];     % ERB segment
cf=erb2hz(erb);       % center frequency
b=1.019*24.7*(4.37*cf/1000+1);       % rate of decay

gt=zeros(numChannel,stepBound);

tmp_t=[1:stepBound]/sampFreq;

for i=1:numChannel
    
    gain=10^((loudness(cf(i))-60)/20)/3*(2*pi*b(i)/sampFreq).^4;
    gt(i,:)=gain*sampFreq^3*tmp_t.^(filterOrder-1).*exp(-2*pi*b(i)*tmp_t).*cos(2*pi*cf(i)*tmp_t+phase(i));
end
